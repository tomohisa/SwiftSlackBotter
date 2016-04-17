// BotInfo.swift
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
import JSON

public struct BotInfo {
  public enum ChannelType {
    case Channel
    case PrivateChannel
    case DirectMessage
  }
  public let json : JSON?
  public var users = [SlackUser]()
  public var channels = [SlackChannel]()
  public var privateChannels = [SlackGroup]()
  public var directMessages = [SlackDirectMessage]()

  public init(json:JSON? = nil) {
    self.json = json
    log.debug(json)
    if let users = json?["users"]?.array {
      for user in users {
        self.users.append(SlackUser(json:user))
      }
    }
    if let channels = json?["channels"]?.array {
      for channel in channels {
        self.channels.append(SlackChannel(json:channel))
      }
    }
    if let privateChannels = json?["groups"]?.array {
      for privateChannel in privateChannels {
        self.privateChannels.append(SlackGroup(json:privateChannel))
      }
    }
    if let directMessages = json?["ims"]?.array {
      for im in directMessages {
        self.directMessages.append(SlackDirectMessage(json:im))
      }
    }
  }
  public var botId : String? {
    get {
      return self.json?["self"]?["id"]?.string
    }
  }
  public func channelType(id:String?) -> ChannelType? {
    guard let id = id else {
      return nil
    }
    for channel in channels {
      if channel.id == id && channel.is_channel {
        return .Channel
      }
    }
    for channel in privateChannels {
      if channel.id == id && channel.is_group {
        return .PrivateChannel
      }
    }
    for channel in directMessages {
      if channel.id == id && channel.is_im {
        return .DirectMessage
      }
    }
    return nil
  }
  public func isChannel(id:String?) -> Bool {
    guard let id = id else {
      return false
    }
    for channel in channels {
      if channel.id == id && channel.is_channel {
        return true
      }
    }
    return false
  }
  public func usernameFor(id:String?) -> String {
    guard let id = id else {
      return ""
    }
    for user in users {
      if user.id == id {
        return user.name == nil ? "" : user.name!
      }
    }
    return ""
  }
  public func userRealNameFor(id:String?) -> String {
    guard let id = id else {
      return ""
    }
    for user in users {
      if user.id == id {
        return user.real_name == nil ? "" : user.real_name!
      }
    }
    return ""
  }
}
