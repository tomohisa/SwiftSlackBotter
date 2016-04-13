import WebSocket
import Environment
import HTTPSClient
import JSON
import Event
import Log

public let log = Log(levels:.Info)

public class Bot {
  public enum Error: ErrorType {
    case ServerError
    case RTMConnectionError
    case SocketConnectionError
    case TokenError
    case InitializeError
    case EventUnmatchError
    case PostFailedError
  }
  let botToken : String
  var webSocketUri : URI?
  let client : HTTPSClient.Client
  var webSocketClient : WebSocket.Client?
  let eventMatcher : EventMatcher
  var uniqueReplyId : Int = 1
  var socketToSend: Socket? = nil

  var teamInfo : JSON? = nil
  public var botId : String? {
    get {
      return self.teamInfo?["self"]?["id"]?.string
    }
  }
  public

  var observers = [EventObserver]()
  public func addObserver(observer:EventObserver) {
    observers.append(observer)
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
    self.webSocketUri = nil
    self.webSocketClient = nil
    self.eventMatcher = event_matcher
    do {
      self.client = try Client(host:"slack.com", port:443)
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
      #if false
        let json = try JSONParser().parse(response.body.buffer)
        self.webSocketUri = try URI(json["url"]!.string!)
      #else
        let json = try JSONParser().parse(Data(response.body.buffer!))
        self.webSocketUri = try URI(string:json["url"]!.string!)
      #endif
      self.teamInfo = json
      log.trace(json)
    } catch {
      throw Error.RTMConnectionError
    }
  }

  private func socket_connect() throws {
    guard let uri = self.webSocketUri else {
      throw Error.RTMConnectionError
    }
    do {
      self.webSocketClient = try WebSocket.Client(ssl: true, host: uri.host!, port: 443) {
                  (socket: Socket) throws -> Void in
                  self.setupSocket(socket)
              }
      try self.webSocketClient!.connect(uri.description)
    } catch {
      throw Error.SocketConnectionError
    }
  }

  func setupSocket(socket: Socket) {
    socket.onText { (message: String) in try self.parseSlackEvent(message) }
    socket.onPing { (data) in try socket.pong() }
    socket.onPong { (data) in try socket.ping() }
    socket.onBinary { (data) in log.debug(data) }
    socket.onClose { (code: CloseCode?, reason: String?) in
        log.info("close with code: \(code ?? .NoStatus), reason: \(reason ?? "no reason")")
    }
    self.socketToSend = socket
  }
  func parseSlackEvent(message: String) throws {
    let eventJson = try JSONParser().parse(message.data)

    guard let event = try self.eventMatcher.matchWithJSONData(eventJson) else {
      return;
    }
    for observer in observers {
      try observer.onEvent(event, bot:self)
    }
  }

  public func reply(message:String,event:MessageEvent) throws {
    guard let channel:String = event.channel else {
      return
    }
    try self.postMessage(channel,text:message,asUser:true)
  }

  public func postMessage(channel: String, text:String, asUser:Bool = true, botName:String?=nil) throws {
    do {
      let body = "token=\(self.botToken)&channel=\(channel)&text=\(text)&asUser=\(asUser)" + (botName == nil ? "" : "&username=\(botName)")
          try client.post("/api/chat.postMessage", headers: headers, body: body)
    } catch { throw Error.PostFailedError }
  }
}
