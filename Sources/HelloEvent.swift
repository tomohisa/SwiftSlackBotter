import Data
import JSON


public struct HelloEvent : RTMEvent {
  public var type : String
  public var rawData : Data?
  public var jsonData : JSON?
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
  }
  public static func isJSOMMatch(jsondata: JSON) -> Bool {
    guard let type = jsondata["type"] else {
      return false
    }
    if type == "hello" {
      return true;
    }
    return false;
  }
}
