// ReactionAddedEvent.swift
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
import JSON
import Log

public struct ReactionAddedEvent : RTMEvent {
  public var type : String
  public var rawData : Data?
  public var jsonData : JSON?
  public var user : String?
  public var reaction : String?
  public var ts : String?
  public var event_ts : String?
  public var item_user : String?
  public var item : RTMEvent? = nil
  public init(rawdata:Data? = nil, jsondata: JSON?) throws {
    var jsonval1 = jsondata

    if jsondata == nil && rawdata != nil {
      guard let rawdata = rawdata else {
        throw RTMEventError.InvalidType
      }
      jsonval1 = try JSONParser().parse(data: rawdata)
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
    self.user = jsonval["user"] == nil ? nil : jsonval["user"]!.string
    self.reaction = jsonval["reaction"] == nil ? nil : jsonval["reaction"]!.string
    self.ts = jsonval["ts"] == nil ? nil : jsonval["ts"]!.string
    self.event_ts = jsonval["event_ts"] == nil ? nil : jsonval["event_ts"]!.string
    self.item_user = jsonval["item_user"] == nil ? nil : jsonval["item_user"]!.string
    if let messageJson = jsonval["item"] {
      self.item = MessageEvent.isJSOMMatch(jsondata: messageJson) ? try MessageEvent(rawdata: nil,jsondata: messageJson) : nil
    }
  }
  public static func isJSOMMatch(jsondata: JSON) -> Bool {
    guard let type = jsondata["type"] else {
      return false
    }
    if type == "reaction_added" {
      return true;
    }
    return false;
  }
}
