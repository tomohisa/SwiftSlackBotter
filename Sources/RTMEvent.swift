import Data
import JSON
// Based on following information
// https://api.slack.com/events
public protocol RTMEvent {
  var type : String { get set }
  var rawData : Data? { get set }
  var jsonData : JSON? { get set }
  init(rawdata:Data?, jsondata: JSON?) throws
  static func isJSOMMatch(jsondata: JSON) -> Bool
}

public enum RTMEventError : ErrorType {
  case InvalidType
}
