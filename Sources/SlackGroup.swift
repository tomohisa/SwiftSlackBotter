// SlackGroup.swift
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

public struct SlackGroup {
  var members = [String]()
  let creator : String?
  let is_archived : Bool
  let is_group : Bool
  let is_open : Bool
  let has_pins : Bool
  let is_mpim : Bool
  let name : String?
  let id : String?
  let json : JSON
  public init(json:JSON) {
    self.json = json

    if let members = json["members"]?.arrayValue {
      for member in members {
        if member.isString {
          if let member = member.stringValue {
            self.members.append(member)
          }
        }
      }
    }

    self.creator = json["creator"]?.stringValue
    self.is_archived = json["is_archived"]?.booleanValue == true
    self.is_group = json["is_group"]?.booleanValue == true
    self.is_open = json["is_open"]?.booleanValue == true
    self.has_pins = json["has_pins"]?.booleanValue == true
    self.is_mpim = json["is_mpim"]?.booleanValue == true
    self.name = json["name"]?.stringValue
    self.id = json["id"]?.stringValue
  }
}
