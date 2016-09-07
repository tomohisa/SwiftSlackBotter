// SlackUser.swift
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

public struct SlackUser {
  public let tz : String?
  public let tz_offset : Int?
  public let name : String?
  public let tz_label : String?
  public let id : String?
  public let real_name : String?
  public let team_id : String?
  public let json : JSON?
  public init(json:JSON) {
    self.json = json
    self.tz = json["tz"]?.stringValue
    self.tz_offset = json["tz_offset"]?.intValue
    self.name = json["name"]?.stringValue
    self.id = json["id"]?.stringValue
    self.tz_label = json["ttz_labelz"]?.stringValue
    self.real_name = json["real_name"]?.stringValue
    self.team_id = json["team_id"]?.stringValue
  }
}
