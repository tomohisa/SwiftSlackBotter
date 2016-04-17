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
    for directMessage in directMessages {
      if directMessage.user == id {
        guard let directMessageId = directMessage.id else { return "" }
        return directMessageId
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
