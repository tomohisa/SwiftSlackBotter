import Data
import JSON
import Log

public struct MessageEvent : RTMEvent {
  public var type : String
  public var rawData : Data?
  public var jsonData : JSON?
  public let channel : String?
  public let user : String?
  public let text : String?
  public let ts : String?
  public var subtype : String? {
    get {
      return jsonData?["subtype"]?.string
    }
  }
  public var isBotMessage : Bool {
    get {
      guard let subtype = self.subtype else {
        return false
      }
      log.debug(subtype)
      return subtype == "bot_message"
    }
  }
  public init(rawdata:Data? = nil, jsondata: JSON?) throws {
    var jsonval1 = jsondata

    if jsondata == nil && rawdata != nil {
      guard let rawdata = rawdata else {
        throw RTMEventError.InvalidType
      }
      jsonval1 = try JSONParser().parse(rawdata)
    }
    guard let jsonval = jsonval1 else {
      throw RTMEventError.InvalidType
    }

    guard let typeval = jsonval["type"]!.string else {
      throw RTMEventError.InvalidType
    }
    type = typeval
    rawData = rawdata
    jsonData = jsondata
    self.channel = jsonval["channel"] == nil ? nil : jsonval["channel"]!.string
    self.user = jsonval["user"] == nil ? nil : jsonval["user"]!.string
    self.text = jsonval["text"] == nil ? nil : jsonval["text"]!.string
    self.ts = jsonval["ts"] == nil ? nil : jsonval["ts"]!.string
  }
  public static func isJSOMMatch(jsondata: JSON) -> Bool {
    guard let type = jsondata["type"] else {
      return false
    }
    if type == "message" {
      return true;
    }
    return false;
  }
}
