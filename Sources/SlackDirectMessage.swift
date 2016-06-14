// SlackDirectMessage.swift
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

public struct SlackDirectMessage {
  let is_org_shared : Bool
  let id : String?
  let is_im : Bool
  let created : String?
  let user : String?
  let unread_count : Int?
  let has_pins : Bool
  let unread_count_display : Int?
  let is_open : Bool

  let json : JSON
  public init(json:JSON) {
    self.json = json

    self.is_org_shared = json["is_org_shared"]?.booleanValue == true
    self.id = json["id"]?.stringValue
    self.is_im = json["is_im"]?.booleanValue == true
    self.created = json["created"]?.stringValue
    self.user = json["user"]?.stringValue
    self.unread_count = json["unread_count"]?.intValue
    self.has_pins = json["has_pins"]?.booleanValue == true
    self.unread_count_display = json["unread_count_display"]?.intValue
    self.is_open = json["is_open"]?.booleanValue == true
  }
}
