import JSON

public struct SlackChannel {
  let is_channel : Bool
  let id : String?
  let creator : String?
  let is_archived : Bool
  let is_general : Bool
  let created : Int?
  let is_member : Bool
  let has_pins : Bool
  let name : String?
  let json : JSON?
  public init(json:JSON) {
    self.json = json
    self.is_channel = json["is_channel"]?.bool == true
    self.id = json["id"]?.string
    self.creator = json["creator"]?.string
    self.is_archived = json["is_archived"]?.bool == true
    self.is_general = json["is_general"]?.bool == true
    self.created = json["created"]?.int
    self.is_member = json["is_member"]?.bool == true
    self.has_pins = json["has_pins"]?.bool == true
    self.name = json["name"]?.string
  }
}
