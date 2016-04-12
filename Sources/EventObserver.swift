import Event

public protocol EventObserver {
  func onEvent(listen: EventListener<RTMEvent>.Listen) -> EventListener<RTMEvent>
}

public class DefaultEventObserver : EventObserver{
  private let eventEmitter : EventEmitter<RTMEvent> = EventEmitter<RTMEvent>()

  public func onEvent(listen: EventListener<RTMEvent>.Listen) -> EventListener<RTMEvent> {
      return eventEmitter.addListener(listen: listen)
  }
}
