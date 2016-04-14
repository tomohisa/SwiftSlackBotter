import Data
import JSON

public protocol EventMatcher {
  func matchWithRawData(rawdata: Data) throws -> RTMEvent?
  func matchWithJSONData(jsondata: JSON) throws -> RTMEvent?
}
