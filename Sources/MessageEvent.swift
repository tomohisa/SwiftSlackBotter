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
import Axis

public struct Reactions {
    public var count : Int = 0
    public var name : String = ""
    public var users : [String] = []
    public var map : Map? = nil
    public init(map: Map){
        self.map = map
        if let count = map.dictionary?["count"]?.int { self.count = count }
        if let name = map.dictionary?["name"]?.string { self.name = name }
        if let users = map.dictionary?["users"]?.array {
            for userMap in users {
                if let user = userMap.string { self.users.append(user) }
            }
        }
    }
}


public struct MessageEvent : RTMEvent {
    public var type : String = ""
    public var channel : String? = nil
    public var user : String? = nil
    public var text : String? = nil
    public var ts : String? = nil
    public var reactions : [Reactions] = []
    public var map : Map? = nil
    
    public init(map: Map) {
        self.map = map
        if let type = map.dictionary?["type"]?.string { self.type = type }
        if let channel = map.dictionary?["channel"]?.string { self.channel = channel }
        if let user = map.dictionary?["user"]?.string { self.user = user }
        if let text = map.dictionary?["text"]?.string { self.text = text }
        if let ts = map.dictionary?["ts"]?.string { self.ts = ts }
        if let reactions = map.dictionary?["reactions"]?.array {
            for reaction in reactions {
                self.reactions.append(Reactions(map: reaction))
            }
        }
    }
    
    public var subtype : String? {
        get {
            guard let subtype = self.map?.dictionary?["subtype"]?.string else { return nil }
            return subtype
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
    public static func isJSOMMatch(map: Map) -> Bool {
        guard let type = map.dictionary?["type"] else {
            return false
        }
        if type == "message" {
            return true;
        }
        return false;
    }
}
