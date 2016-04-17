import Event

public protocol EventObserver {
  func onEvent(event:RTMEvent, bot:Bot) throws
}

public class DefaultEventObserver : EventObserver {
  public var onMessage : ((MessageEvent, Bot) throws -> Void)? = nil
  public var onOwnMessage : ((MessageEvent, Bot) throws -> Void)? = nil
  public var onHello : ((HelloEvent, Bot) throws -> Void)? = nil
  public init(onMessage:((MessageEvent, Bot) throws -> Void)? = nil) {
    self.onMessage = onMessage
  }
  public func onEvent(event:RTMEvent, bot:Bot) throws {
    log.debug("botid=\(bot.botInfo.botId)")
    switch event {
      case let hello as HelloEvent:
        try onHello?(hello, bot)
      case let message as MessageEvent:
        if message.user == bot.botInfo.botId || message.isBotMessage {
          log.debug("bot message")
          try onOwnMessage?(message, bot)
        } else {
          log.debug("user message")
          try onMessage?(message, bot)
        }
      default:
        break;
    }
  }
}
