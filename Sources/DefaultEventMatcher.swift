// DefaultEventMatcher.swift
// The MIT License (MIT)
//
// Copyright (c) 2016 J-Tech Creations, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
