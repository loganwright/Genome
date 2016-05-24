//
//  XMLConstants.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/14/16.
//
//

internal struct XMLConstants {
    
    /// The less than symbol: <
    internal static let lessThanScalar: UnicodeScalar = "<"
    
    /// The greater than symbol: <
    internal static let greaterThanScalar: UnicodeScalar = ">"
    
    /// The ampersand: &
    internal static let ampersandScalar: UnicodeScalar = "&"
    
    /// The start of a CDATA sequence.
    internal static let cDataStartSequence: String = "<![CDATA["
    
    /// The end of a CDATA sequence.
    internal static let cDataEndSequence: String = "]]>"
    
    /// The start of a comment sequence.
    internal static let commentStartSequence: String = "<!--"
    
    /// The end of a comment sequence.
    internal static let commentEndSequence: String = "-->"
}