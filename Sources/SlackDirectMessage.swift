import JSON

public struct SlackDirectMessage {
  let is_org_shared : Bool
  let id : String?
  let is_im : Bool
  let created : String?
  let user : String?
  let unread_count : Int?
  let has_pins : Bool
  let unread_count_display : Int?
  let is_open : Bool

  let json : JSON
  public init(json:JSON) {
    self.json = json

    self.is_org_shared = json["is_org_shared"]?.bool == true
    self.id = json["id"]?.string
    self.is_im = json["is_im"]?.bool == true
    self.created = json["created"]?.string
    self.user = json["user"]?.string
    self.unread_count = json["unread_count"]?.int
    self.has_pins = json["has_pins"]?.bool == true
    self.unread_count_display = json["unread_count_display"]?.int
    self.is_open = json["is_open"]?.bool == true
  }
}
