import JSON

public struct SlackUser {
  let tz : String?
  let tz_offset : Int?
  let name : String?
  let tz_label : String?
  let id : String?
  let real_name : String?
  let team_id : String?
  let json : JSON?
  public init(json:JSON) {
    self.json = json
    self.tz = json["tz"]?.string
    self.tz_offset = json["tz_offset"]?.int
    self.name = json["name"]?.string
    self.id = json["id"]?.string
    self.tz_label = json["ttz_labelz"]?.string
    self.real_name = json["real_name"]?.string
    self.team_id = json["team_id"]?.string
  }
}
