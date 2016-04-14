import Data
import JSON
import Log

public class DefaultEventMatcher : EventMatcher {
  public enum Error : ErrorType {
    case EventUnmatch
    case InvalidJson
  }
  public func matchWithRawData(rawdata: Data) throws -> RTMEvent? {
    let eventJson: JSON = try JSONParser().parse(rawdata)
    return try self.matchWithJSONData(eventJson)
  }
  public func matchWithJSONData(jsondata: JSON) throws -> RTMEvent? {
    if HelloEvent.isJSOMMatch(jsondata) {
      return try HelloEvent(rawdata: nil,jsondata: jsondata)
    }
    if MessageEvent.isJSOMMatch(jsondata) {
      return try MessageEvent(rawdata: nil,jsondata: jsondata)
    }
    log.debug(jsondata)
    return nil
  }
}
