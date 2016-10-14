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
import Axis

public class DefaultEventMatcher : EventMatcher {
  public enum EventError : Error {
    case EventUnmatch
    case InvalidJson
  }
  public func match(rawdata: Buffer) throws -> RTMEvent? {
    return try self.match(map: try JSONMapParser.parse(rawdata))
  }
  public func match(map: Map) throws -> RTMEvent? {
    if HelloEvent.isJSOMMatch(map: map) {
        return HelloEvent(map: map)
    }
    if MessageEvent.isJSOMMatch(map: map) {
      return MessageEvent(map: map)
    }
    if ReactionAddedEvent.isJSOMMatch(map: map) {
      return ReactionAddedEvent(map: map)
    }
    logger.debug(map)
    return nil
  }
}
