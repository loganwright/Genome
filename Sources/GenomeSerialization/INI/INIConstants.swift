//
//  INIConstants.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/12/16.
//
//

internal struct INIConstants {
    
    /// The informal value for the boolean true.
    internal static let trueValue: String = "true"
    /// The informal value for the boolean false.
    internal static let falseValue: String = "false"
    /// The value for null
    internal static let nullValue: String = "\0"
    
    /// Assists in the unescaping of strings.
    internal static let unescapeMapping: [UnicodeScalar: UnicodeScalar] = [
                                                                              "\\": "\\",
                                                                              "0": "\0",
                                                                              "a": "\u{7}",
                                                                              "b": "\u{8}",
                                                                              "t": "\t",
                                                                              "r": "\r",
                                                                              "n": "\n",
                                                                              ";": ";"
                                                                              ]
    /// Assists in the escaping of strings.
    internal static let escapeMapping: [Character : String] = [
                                                                  "\\": "\\\\",
                                                                  "\0": "\\0",
                                                                  "\u{7}": "\\a",
                                                                  "\u{8}": "\\b",
                                                                  "\t": "\\t",
                                                                  "\r": "\\r",
                                                                  "\n": "\\n",
                                                                  ";": "\\;"
    ]
}
