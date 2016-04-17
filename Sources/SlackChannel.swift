// SlackChannel.swift
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

public struct SlackChannel {
  let is_channel : Bool
  let id : String?
  let creator : String?
  let is_archived : Bool
  let is_general : Bool
  let created : Int?
  let is_member : Bool
  let has_pins : Bool
  let name : String?
  let json : JSON?
  public init(json:JSON) {
    self.json = json
    self.is_channel = json["is_channel"]?.bool == true
    self.id = json["id"]?.string
    self.creator = json["creator"]?.string
    self.is_archived = json["is_archived"]?.bool == true
    self.is_general = json["is_general"]?.bool == true
    self.created = json["created"]?.int
    self.is_member = json["is_member"]?.bool == true
    self.has_pins = json["has_pins"]?.bool == true
    self.name = json["name"]?.string
  }
}
