// MessageEvent.swift
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

public struct Reactions {
    public var count : Int = 0
    public var name : String = ""
    public var users : [String] = []
}


public struct MessageEvent : RTMEvent {
  public var type : String
  public var rawData : Data?
  public var jsonData : JSON?
  public var channel : String?
  public var user : String?
  public var text : String?
  public var ts : String?
  public var reactions : [Reactions] = []
  public var subtype : String? {
    get {
      return jsonData?["subtype"]?.stringValue
    }
  }
  public var isBotMessage : Bool {
    get {
      guard let subtype = self.subtype else {
        return false
      }
      logger.debug(subtype)
      return subtype == "bot_message"
    }
  }
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

    guard let typeval = jsonval["type"]!.stringValue else {
      throw RTMEventError.InvalidType
    }
    type = typeval
    rawData = rawdata
    jsonData = jsondata
    self.channel = jsonval["channel"] == nil ? nil : jsonval["channel"]!.stringValue
    self.user = jsonval["user"] == nil ? nil : jsonval["user"]!.stringValue
    self.text = jsonval["text"] == nil ? nil : jsonval["text"]!.stringValue
    self.ts = jsonval["ts"] == nil ? nil : jsonval["ts"]!.stringValue
    if let reactions = jsonval["reactions"]?.arrayValue {
        for reaction in reactions {
            var r = Reactions()
            if let count = reaction["count"]?.intValue { r.count = count }
            if let name = reaction["name"]?.stringValue { r.name = name }
            if let users = reaction["users"]?.arrayValue {
                for user in users {
                    if let userid = user.stringValue { r.users.append(userid) }
                }
            }
            self.reactions.append(r)
        }
    }
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
