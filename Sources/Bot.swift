import WebSocket
import Environment
import HTTPSClient
import JSON
import Event
import Log
import Venice
import StandardOutputAppender

public let logger = Logger(name: "swiftBot-Log", appender: StandardOutputAppender(), levels: .info)

public class Bot {
    public enum Error: ErrorProtocol {
        case ServerError
        case RTMConnectionError
        case SocketConnectionError
        case TokenError
        case InitializeError
        case EventUnmatchError
        case PostFailedError
        case ReactFails
    }
    let botToken : String
    var webSocketUri : URI? = nil
    let client : HTTPSClient.Client
    var webSocketClient : WebSocket.Client? = nil
    let eventMatcher : EventMatcher
    public var botInfo : BotInfo = BotInfo()
    public var isBotActive : Bool = false
    public var observers = [EventObserver]()
    public func addObserver(observer:EventObserver) {
        observers.append(observer)
    }

    public var periodicBots = [PeriodicBotService]()
    public func add(periodicBot b:PeriodicBotService) {
        periodicBots.append(b)
        co { [weak self] in
            while b.done == false {
                guard let wself = self else { break }
                guard wself.isBotActive else {
                    nap(for: 10.second)
                    logger.debug("waiting for bot to become active ...")
                    continue
                }
                do {
                    if let serviceCall = b.serviceCall {
                        logger.debug("running periodic bot...")
                        try serviceCall(wself)
                        logger.debug("finished running periodic bot...")
                    }
                } catch let error {
                    if let onError = b.onError {
                        onError(error)
                    }
                    logger.info("Error on Periodic Service Bot\(error)")
                }
                nap(for: b.frequency)
            }
            guard let wself = self else { return }
            for (index, _) in wself.periodicBots.enumerated() {
                wself.periodicBots.remove(at: index)
                break
            }
        }
    }

    private let headers: Headers = ["Content-Type": "application/x-www-form-urlencoded"]

    public init (token: String? = nil, event_matcher : EventMatcher = DefaultEventMatcher()) throws {
        if token == nil {
            guard let t = Environment().getVar("SLACK_BOT_TOKEN") else {
                throw Error.TokenError
            }
            self.botToken = t
        }else{
            self.botToken = token!
        }
        self.eventMatcher = event_matcher
        do {
            self.client = try Client(uri: URI("https://slack.com"))
        } catch {
            throw Error.InitializeError
        }
    }

    public func start() throws {
        try rtm_start()
        try socket_connect()
    }

    private func rtm_start() throws {
        do {
            var response :Response
            response = try client.get("/api/rtm.start?token=" + self.botToken)
            let buffer = try response.body.becomeBuffer()
            print(buffer)
            let json = try JSONParser().parse(data: buffer)
            guard let url = json["url"], uri = url.string else {
                throw Error.RTMConnectionError
            }
            self.webSocketUri = try URI(uri)
            self.botInfo = BotInfo(json:json)
            self.isBotActive = true
        } catch {
            throw Error.RTMConnectionError
        }
    }

    private func socket_connect() throws {
        guard let uri = self.webSocketUri else {
            throw Error.RTMConnectionError
        }
        do {
            self.webSocketClient = try WebSocket.Client(uri:uri) {
                (socket: Socket) throws -> Void in
                logger.debug("setting up socket:")
                self.setupSocket(socket: socket)
            }
            try self.webSocketClient!.connect(uri.description)
            logger.debug("successfully connected \(self.webSocketClient)")
        } catch let error {
            logger.error("\(error)")
            throw Error.SocketConnectionError
        }
    }

    func setupSocket(socket: Socket) {
        socket.onText { (message: String) in try self.parseSlackEvent(message: message) }
        socket.onPing { (data) in try socket.pong() }
        socket.onPong { (data) in try socket.ping() }
        socket.onBinary { (data) in logger.debug(data) }
        socket.onClose { (code: CloseCode?, reason: String?) in
            logger.info("close with code: \(code ?? .NoStatus), reason: \(reason ?? "no reason")")
        }
    }
    func parseSlackEvent(message: String) throws {
        guard let event = try self.eventMatcher.matchWithJSONData(jsondata: try JSONParser().parse(data: message.data)) else {
            return;
        }
        for observer in observers {
            try observer.onEvent(event: event, bot:self)
        }
    }

    public func reply(message:String,event:MessageEvent) throws {
        guard let channel:String = event.channel else {
            return
        }
        try self.postMessage(channel: channel,text:message,asUser:true)
    }

    public func postMessage(channel: String, text:String, asUser:Bool = true, botName:String?=nil) throws {
        do {
            let body = "token=\(self.botToken)&channel=\(channel)&text=\(text)&as_user=\(asUser)" + (botName == nil ? "" : "&username=\(botName)")
            try client.post("/api/chat.postMessage", headers: headers, body: body)
        } catch { throw Error.PostFailedError }
    }
    public func react(message:MessageEvent,with name:String) throws {
        do {
            guard let channel = message.channel, timestamp = message.ts else {
                throw Error.ReactFails
            }
            let body = "token=\(self.botToken)&name=\(name)&channel=\(channel)&timestamp=\(timestamp)"
            try client.post("/api/reactions.add", headers: headers, body: body)
        } catch {
            throw Error.ReactFails
        }
    }
    public func reactionGetFor(message:MessageEvent) throws -> MessageEvent? {
        do {
            guard let channel = message.channel, timestamp = message.ts else {
                throw Error.ReactFails
            }
            let body = "token=\(self.botToken)&channel=\(channel)&timestamp=\(timestamp)"
            var response : Response = try client.post("/api/reactions.get", headers: headers, body: body)
            let json : JSON = try JSONParser().parse(data: try response.body.becomeBuffer())
            guard let ok = json["ok"]?.bool else { return nil }
            guard ok == true else { return nil }
            if json["type"]?.string != "message" { return nil }
            guard let messageJson = json["message"] else { return nil }
            guard MessageEvent.isJSOMMatch(jsondata: messageJson) else { return nil }
            return try MessageEvent(rawdata: nil,jsondata: messageJson)
        } catch {
            throw Error.ReactFails
        }
    }

    public func postDirectMessage(username name: String, text:String, asUser:Bool = true, botName:String?=nil) throws {
        try postMessage(channel: botInfo.directMessageIdFor(username:name),text:text , asUser:asUser, botName:botName)
    }
}
 
