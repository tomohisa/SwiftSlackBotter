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
import Axis

public struct BotInfo {
    public enum ChannelType {
        case Channel
        case PrivateChannel
        case DirectMessage
    }
    public var users = [SlackUser]()
    public var channels = [SlackChannel]()
    public var groups = [SlackGroup]()
    public var ims = [SlackDirectMessage]()
    public var map: Map?
    
    public init(map:Map? = nil) {
        self.map = map
        guard let map = map else {
            return
        }
        logger.debug(map)
        do {
            if let users = map.dictionary?["users"]?.array {
                for user in users {
                    self.users.append(try SlackUser(map:user))
                }
            }
            if let channels = map.dictionary?["channels"]?.array {
                for channel in channels {
                    self.channels.append(try SlackChannel(map:channel))
                }
            }
            if let privateChannels = map.dictionary?["groups"]?.array {
                for privateChannel in privateChannels {
                    self.groups.append(try SlackGroup(map:privateChannel))
                }
            }
            if let directMessages = map.dictionary?["ims"]?.array {
                for im in directMessages {
                    self.ims.append(try SlackDirectMessage(map:im))
                }
            }
        } catch let error {
            logger.debug(error);
        }
    }
    
    public var botId : String? {
        get {
                guard let map = self.map else { return nil }
                return map.dictionary?["self"]?.dictionary?["id"]?.string
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
        for channel in groups {
            if channel.id == id && channel.is_group {
                return .PrivateChannel
            }
        }
        for channel in ims {
            if channel.id == id && channel.is_im {
                return .DirectMessage
            }
        }
        return nil
    }
    public func channelIDFor(_ name:String?) -> String? {
        guard let name = name else { return nil }
        for channel in channels {
            if channel.name == name && channel.is_channel {
                return channel.id
            }
        }
        for channel in groups {
            if channel.name == name && channel.is_group {
                return channel.id
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
    public func userFor(id:String?) -> SlackUser? {
        guard let id = id else {
            return nil
        }
        for user in users {
            if user.id == id {
                return user
            }
        }
        return nil
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
    public func userIdFor(username name:String?) -> String {
        guard let name = name else {
            return ""
        }
        for user in users {
            if user.name == name {
                if let userid = user.id {
                    return userid
                } else { return "" }
            }
        }
        return ""
    }
    public func directMessageIdFor(userid id: String?) -> String {
        guard let id = id else {
            return ""
        }
        for directMessage in ims {
            if directMessage.user == id {
                guard let directMessageId = directMessage.id else { return "" }
                return directMessageId
            }
        }
        return ""
    }
    public func directMessageIdFor(channelID: String?) -> String {
        guard let id = channelID else {
            return ""
        }
        for directMessage in ims {
            if directMessage.id == id {
                guard let userID = directMessage.user else { return "" }
                return self.usernameFor(id: userID)
            }
        }
        return ""
    }
    public func directMessageIdFor(username name: String?) -> String {
        guard let name = name else {
            return ""
        }
        return directMessageIdFor(userid:userIdFor(username: name))
    }
}
