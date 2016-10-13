// HelloEvent.swift
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
import Axis


public struct HelloEvent : RTMEvent, MapConvertible {
  public var type : String
  public var rawData : Buffer?
  public var jsonData : Map?
  public init(rawdata:Buffer? = nil, jsondata: Map?) throws {
    var jsonval1 = jsondata

    if jsondata == nil && rawdata != nil {
      guard let rawdata = rawdata else {
        throw RTMEventError.InvalidType
      }
      jsonval1 = try JSONMapParser.parse(rawdata)
    }
    guard let jsonval = jsonval1 else {
      throw RTMEventError.InvalidType
    }

    guard let typeval = jsonval.dictionary?["type"]?.string else {
      throw RTMEventError.InvalidType
    }
    type = typeval
    rawData = rawdata
    jsonData = jsondata
  }
  public static func isJSOMMatch(map: Map) -> Bool {
    guard let type = map.dictionary?["type"]?.string else {
      return false
    }
    if type == "hello" {
      return true;
    }
    return false;
  }
}
