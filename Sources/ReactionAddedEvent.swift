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
import Axis

public struct ReactionAddedEvent : RTMEvent {
    public var type : String = ""
    public var user : String?  = nil
    public var reaction : String? = nil
    public var ts : String? = nil
    public var event_ts : String? = nil
    public var item_user : String? = nil
    public var item : RTMEvent? = nil
    
    public var map : Map? = nil
    
    public init(map: Map) {
        self.map = map
        if let type = map.dictionary?["type"]?.string { self.type = type }
        if let user = map.dictionary?["user"]?.string { self.user = user }
        if let reaction = map.dictionary?["reaction"]?.string { self.reaction = reaction }
        if let ts = map.dictionary?["ts"]?.string { self.ts = ts }
        if let event_ts = map.dictionary?["event_ts"]?.string { self.event_ts = event_ts }
        if let item_user = map.dictionary?["item_user"]?.string { self.item_user = item_user }
        if let itemMap = map.dictionary?["item"] {
            self.item = MessageEvent(map: itemMap)
        }
    }
    
    public static func isJSOMMatch(map: Map) -> Bool {
        guard let type = map.dictionary?["type"] else {
            return false
        }
        if type == "reaction_added" {
            return true;
        }
        return false;
    }
}
