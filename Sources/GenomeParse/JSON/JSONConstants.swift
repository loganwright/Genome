//
//  JSONConstants.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/9/16.
//
//

internal struct JSONConstants {
    
    /// The value for the boolean true.
    internal static let trueValue: String = "true"
    /// The value for the boolean false.
    internal static let falseValue: String = "false"
    /// The value for null.
    internal static let nullValue: String = "null"
    /// The informal exponent lowercase identifier.
    internal static let exponentLowercaseScalar: UnicodeScalar = "e"
    /// The indormal uppercase identifier.
    internal static let exponentUppercaseScalar: UnicodeScalar = "E"
    
    /// Assists in the unescaping of strings.
    internal static let unescapeMapping: [UnicodeScalar: UnicodeScalar] = [
                                                                              "t": "\t",
                                                                              "r": "\r",
                                                                              "n": "\n",
                                                                              ]
    /// Assists in the escaping of strings.
    internal static let escapeMapping: [Character : String] = [
                                                                  "\r": "\\r",
                                                                  "\n": "\\n",
                                                                  "\t": "\\t",
                                                                  "\\": "\\\\",
                                                                  "\"": "\\\"",
                                                                  
                                                                  "\u{2028}": "\\u2028", // LINE SEPARATOR
                                                                  "\u{2029}": "\\u2029", // PARAGRAPH SEPARATOR
        
                                                                  "\r\n": "\\r\\n" // XXX: countElements("\r\n") is 1 in Swift 1.0
        ]
}
