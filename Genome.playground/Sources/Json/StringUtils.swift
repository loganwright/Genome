//
//  StringUtils.swift
//  JsonSerializer
//
//  Created by Fuji Goro on 2014/09/15.
//  Copyright (c) 2014 Fuji Goro. All rights reserved.
//

let unescapeMapping: [UnicodeScalar: UnicodeScalar] = [
    "t": "\t",
    "r": "\r",
    "n": "\n",
]

let escapeMapping: [Character : String] = [
    "\r": "\\r",
    "\n": "\\n",
    "\t": "\\t",
    "\\": "\\\\",
    "\"": "\\\"",

    "\u{2028}": "\\u2028", // LINE SEPARATOR
    "\u{2029}": "\\u2029", // PARAGRAPH SEPARATOR

    // XXX: countElements("\r\n") is 1 in Swift 1.0
    "\r\n": "\\r\\n",
]

let hexMapping: [UnicodeScalar : UInt32] = [
    "0": 0x0,
    "1": 0x1,
    "2": 0x2,
    "3": 0x3,
    "4": 0x4,
    "5": 0x5,
    "6": 0x6,
    "7": 0x7,
    "8": 0x8,
    "9": 0x9,
    "a": 0xA, "A": 0xA,
    "b": 0xB, "B": 0xB,
    "c": 0xC, "C": 0xC,
    "d": 0xD, "D": 0xD,
    "e": 0xE, "E": 0xE,
    "f": 0xF, "F": 0xF,
]

let digitMapping: [UnicodeScalar:Int] = [
    "0": 0,
    "1": 1,
    "2": 2,
    "3": 3,
    "4": 4,
    "5": 5,
    "6": 6,
    "7": 7,
    "8": 8,
    "9": 9,
]

extension String {
    public var escapedJsonString: String {
        let mapped = characters
            .map { escapeMapping[$0] ?? String($0) }
            .joinWithSeparator("")
        return "\"" + mapped + "\""
    }
}

public func escapeAsJsonString(source : String) -> String {
    return source.escapedJsonString
}

func digitToInt(b: UInt8) -> Int? {
    return digitMapping[UnicodeScalar(b)]
}

func hexToDigit(b: UInt8) -> UInt32? {
    return hexMapping[UnicodeScalar(b)]
}

