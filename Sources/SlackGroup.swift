import JSON

public struct SlackGroup {
  var members = [String]()
  let creator : String?
  let is_archived : Bool
  let is_group : Bool
  let is_open : Bool
  let has_pins : Bool
  let is_mpim : Bool
  let name : String?
  let id : String?
  let json : JSON
  public init(json:JSON) {
    self.json = json

    if let members = json["members"]?.array {
      for member in members {
        if member.isString {
          if let member = member.string {
            self.members.append(member)
          }
        }
      }
    }

    self.creator = json["creator"]?.string
    self.is_archived = json["is_archived"]?.bool == true
    self.is_group = json["is_group"]?.bool == true
    self.is_open = json["is_open"]?.bool == true
    self.has_pins = json["has_pins"]?.bool == true
    self.is_mpim = json["is_mpim"]?.bool == true
    self.name = json["name"]?.string
    self.id = json["id"]?.string
  }
}
