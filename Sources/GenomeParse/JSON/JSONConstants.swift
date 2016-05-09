//
//  JSONConstants.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/9/16.
//
//

internal struct JSONConstants {
    internal static let trueValue: String = "true"
    internal static let falseValue: String = "false"
    internal static let nullValue: String = "null"
    
    internal static let unescapeMapping: [UnicodeScalar: UnicodeScalar] = [
                                                                              "t": "\t",
                                                                              "r": "\r",
                                                                              "n": "\n",
                                                                              ]
    
    internal static let escapeMapping: [Character : String] = [
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
}
