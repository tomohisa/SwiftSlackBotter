import JSON

public struct BotInfo {
  public let json : JSON?
  public var users = [SlackUser]()

  public init(json:JSON? = nil) {
    self.json = json
    if let users = json?["users"]?.array {
      for user in users {
        self.users.append(SlackUser(json:user))
      }
    }
  }
  public var botId : String? {
    get {
      return self.json?["self"]?["id"]?.string
    }
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
