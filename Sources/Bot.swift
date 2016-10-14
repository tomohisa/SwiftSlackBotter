import WebSocketClient
import Axis
import HTTPClient
import Venice

public let logger = Logger(name: "swiftBot-Log")

public class Bot {
    public enum BotError: Error {
        case ServerError
        case RTMConnectionError
        case SocketConnectionError
        case TokenError
        case InitializeError
        case EventUnmatchError
        case PostFailedError
        case ReactFails
        case WrongChannelName
    }
    let botToken : String
    var webSocketUrl : URL? = nil
    let client : HTTPClient.Client
    var webSocketClient : WebSocketClient? = nil
    let eventMatcher : EventMatcher
    public var botInfo : BotInfo = BotInfo()
    public var isBotActive : Bool = false
    public var observers = [EventObserver]()
    public func addObserver(observer:EventObserver) {
        observers.append(observer)
    }
    public var onConnected : ((Bot) -> Void)? = nil

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
            guard let t = environment["SLACK_BOT_TOKEN"] else {
                throw BotError.TokenError
            }
            self.botToken = t
        }else{
            self.botToken = token!
        }
        self.eventMatcher = event_matcher
        do {
            guard let url = URL(string: "https://slack.com") else { throw BotError.InitializeError }
            self.client = try Client(url: url)
        } catch {
            throw BotError.InitializeError
        }
    }

    public func start() throws {
        try rtm_start()
        try socket_connect()
    }
    public func startInBackground() throws {
        try rtm_start()
        try socket_connect_in_background()
    }

    private func rtm_start() throws {
        do {
            var response :Response
            response = try client.get("/api/rtm.start?token=" + self.botToken)
            let buffer = try response.body.becomeBuffer(deadline: 3.second.fromNow())
            let map = try JSONMapParser.parse(buffer)
            guard let url = map.dictionary?["url"]?.string else {
                throw BotError.RTMConnectionError
            }
            self.webSocketUrl = URL(string: url)
            self.botInfo = BotInfo(map: map)
            self.isBotActive = true
        } catch {
            throw BotError.RTMConnectionError
        }
    }

    private func socket_connect() throws {
        guard let uri = self.webSocketUrl else {
            throw BotError.RTMConnectionError
        }
        do {
            self.webSocketClient = try WebSocketClient(url: uri) {
                (socket: WebSocket) throws -> Void in
                logger.debug("setting up socket:")
                self.setupSocket(socket: socket)
                if let onConnected = self.onConnected {
                    onConnected(self)
                }
            }
            try self.webSocketClient!.connect()
            logger.debug("successfully connected \(self.webSocketClient)")
        } catch let error {
            logger.error("\(error)")
            throw BotError.SocketConnectionError
        }
    }
    private func socket_connect_in_background() throws {
        guard let uri = self.webSocketUrl else {
            throw BotError.RTMConnectionError
        }
        do {
            self.webSocketClient = try WebSocketClient(url: uri) {
                (socket: WebSocket) throws -> Void in
                logger.debug("setting up socket:")
                self.setupSocket(socket: socket)
                if let onConnected = self.onConnected {
                    onConnected(self)
                }
            }
            self.webSocketClient!.connectInBackground(failure: { (error) in
                logger.error("\(error)")
            })
            logger.debug("successfully connected \(self.webSocketClient)")
        } catch let error {
            logger.error("\(error)")
            throw BotError.SocketConnectionError
        }
    }

    func setupSocket(socket: WebSocket) {
        let _ = socket.onText { (message: String) in try self.parseSlackEvent(message: message) }
        let _ = socket.onPing { (data) in try socket.pong() }
        let _ = socket.onPong { (data) in try socket.ping() }
        let _ = socket.onBinary { (data) in logger.debug(data) }
        let _ = socket.onClose { (code: CloseCode?, reason: String?) in
            logger.info("close with code: \(code), reason: \(reason ?? "no reason")")
        }
    }
    func parseSlackEvent(message: String) throws {
        guard let event = try self.eventMatcher.match(map: try JSONMapParser.parse(message)) else {
            return
        }
        logger.debug(event.type)
        for observer in observers {
            try observer.onEvent(event: event, bot:self)
        }
    }

    public func reply(message:String,event:MessageEvent) throws {
        guard let channel:String = event.channel else {
            return
        }
        try self.postMessage(channelID: channel,text:message,asUser:true)
    }

    public func postMessage(channelID: String, text:String, asUser:Bool = true, botName:String?=nil) throws {
        do {
            let body = "token=\(self.botToken)&channel=\(channelID)&text=\(text)&as_user=\(asUser)" + (botName == nil ? "" : "&username=\(botName)")
            let _ = try client.post("/api/chat.postMessage", headers: headers, body: body)
        } catch { throw BotError.PostFailedError }
    }
    public func postMessage(channelName: String, text:String, asUser:Bool = true, botName:String?=nil) throws {
        guard let channel = self.botInfo.channelIDFor(channelName) else { throw BotError.WrongChannelName }
        try postMessage(channelID: channel, text:text, asUser:asUser, botName:botName)
    }
    public func react(message:MessageEvent,with name:String) throws {
        do {
            guard let channel = message.channel, let timestamp = message.ts else {
                throw BotError.ReactFails
            }
            let body = "token=\(self.botToken)&name=\(name)&channel=\(channel)&timestamp=\(timestamp)"
            logger.debug(body)
            let _ = try client.post("/api/reactions.add", headers: headers, body: body)
        } catch {
            throw BotError.ReactFails
        }
    }
    public func reactionGetFor(message:MessageEvent) throws -> MessageEvent? {
        do {
            guard let channel = message.channel, let timestamp = message.ts else {
                throw BotError.ReactFails
            }
            let body = "token=\(self.botToken)&channel=\(channel)&timestamp=\(timestamp)"
            var response : Response = try client.post("/api/reactions.get", headers: headers, body: body)
            let map : Map = try JSONMapParser.parse(response.body.becomeBuffer(deadline: 3.seconds.fromNow()))
            guard let ok = map.dictionary?["ok"]?.bool else { return nil }
            guard ok == true else { return nil }
            if map.dictionary?["type"]?.string != "message" { return nil }
            guard let messageMap = map.dictionary?["message"] else { return nil }
            guard MessageEvent.isJSOMMatch(map: messageMap) else { return nil }
            var result = MessageEvent(map: messageMap)
            result.channel = channel
            return result
        } catch {
            throw BotError.ReactFails
        }
    }

    public func getPresenceFor(username:String) throws -> Bool? {
        do {
            let userID = botInfo.userIdFor(username:username)
            if userID == "" {
                throw BotError.ReactFails
            }
            let body = "token=\(self.botToken)&user=\(userID)"
            var response : Response = try client.post("/api/users.getPresence", headers: headers, body: body)
            let map : Map = try JSONMapParser.parse(response.body.becomeBuffer(deadline: 3.seconds.fromNow()))
            guard let ok = map.dictionary?["ok"]?.bool else { return nil }
            guard ok == true else { return nil }
            if map.dictionary?["presence"]?.string == "active" { return true }
            return false;
        } catch {
            throw BotError.ReactFails
        }
    }

    public func postDirectMessage(username name: String, text:String, asUser:Bool = true, botName:String?=nil) throws {
        try postMessage(channelID: botInfo.directMessageIdFor(username:name),text:text , asUser:asUser, botName:botName)
    }
}
