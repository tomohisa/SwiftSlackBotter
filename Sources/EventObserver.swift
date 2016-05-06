// EventObserver.swift
// The MIT License (MIT)
//
// Copyright (c) 2016 J-Tech Creations, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
    logger.debug("botid=\(bot.botInfo.botId)")
    switch event {
      case let hello as HelloEvent:
        try onHello?(hello, bot)
      case let message as MessageEvent:
        if message.user == bot.botInfo.botId || message.isBotMessage {
          logger.debug("bot message")
          try onOwnMessage?(message, bot)
        } else {
          logger.debug("user message")
          try onMessage?(message, bot)
        }
      default:
        break;
    }
  }
}
