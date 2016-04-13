import Event

public protocol EventObserver {
  func onEvent(event:RTMEvent, bot:Bot) throws
}

public class DefaultEventObserver : EventObserver {
  public var onMessage : ((MessageEvent, Bot) throws -> Void)? = nil
  public var onOwnMessage : ((MessageEvent, Bot) throws -> Void)? = nil
  public var onHello : ((HelloEvent, Bot) throws -> Void)? = nil
  public init(onmessage:((MessageEvent, Bot) throws -> Void)? = nil) {
    onMessage = onmessage
  }
  public func onEvent(event:RTMEvent, bot:Bot) throws {
    switch event {
      case let hello as HelloEvent:
        try onHello?(hello, bot)
      case let message as MessageEvent:
        if message.user == bot.botId {
          try onOwnMessage?(message, bot)
        } else {
          try onMessage?(message, bot)
        }
      default:
        break;
    }
  }
}
