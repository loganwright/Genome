//
//  FileConstants.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/9/16.
//
//

//---------------------------------
// MARK: Line Endings
//---------------------------------

/// Constants for line endings on different file systems.
public enum LineEndings: String {
    /// Unix (i.e Linux, Darwin) line endings: line feed
    case Unix = "\n"
    /// Windows line endings: carriage return + line feed
    case Windows = "\r\n"
}

//---------------------------------
// MARK: File Constants
//---------------------------------

/// Constants for various control characters used in file formats.
internal struct FileConstants {
    
    //---------------------------------
    // MARK: Structure Characters
    //---------------------------------
    
    /// The left square bracket: [
    internal static let leftSquareBracket = UnicodeScalar(0x005b)
    /// The left curly bracket: {
    internal static let leftCurlyBracket = UnicodeScalar(0x007b)
    /// The right square bracket: ]
    internal static let rightSquareBracket = UnicodeScalar(0x005d)
    /// The right curly bracket: }
    internal static let rightCurlyBracket = UnicodeScalar(0x007d)
    /// The colon: :
    internal static let colon = UnicodeScalar(0x003A)
    /// The comma: ,
    internal static let comma = UnicodeScalar(0x002C)
    /// The semicolon: ;
    internal static let semicolon = UnicodeScalar(0x003B)
    /// The octothorpe: #
    internal static let octothorpe = UnicodeScalar(0x0023)
    
    //---------------------------------
    // MARK: Whitespace
    //---------------------------------
    
    /// The carrage return: \r
    internal static let carriageReturn = UnicodeScalar(0x000D)
    /// The line feed: \n
    internal static let lineFeed = UnicodeScalar(0x000A)
    /// The backspace: \b
    internal static let backspace = UnicodeScalar(0x0008)
    /// The form feed: \f
    internal static let formFeed = UnicodeScalar(0x000C)
    /// The tab: \t
    internal static let tabCharacter = UnicodeScalar(0x0009)
    /// The space: " "
    internal static let space = UnicodeScalar(0x0020)
    
    //---------------------------------
    // MARK: String Characters
    //---------------------------------
    
    /// The quotation mark: "
    internal static let quotationMark = UnicodeScalar(0x0022)
    /// The apostrophe mark: '
    internal static let apostropheMark = UnicodeScalar(0x0027)
    /// The reverse solidus: \
    internal static let reverseSolidus = UnicodeScalar(0x005C)
    /// The solidus: /
    internal static let solidus = UnicodeScalar(0x002F)
    
    //---------------------------------
    // MARK: Numerical Characters
    //---------------------------------
    
    /// The zero: 0
    internal static let zeroScalar = "0".unicodeScalars.first!
    /// The minus sign: -
    internal static let negativeScalar = "-".unicodeScalars.first!
    /// The plus sign: +
    internal static let positiveScalar = "+".unicodeScalars.first!
    /// The decimal/period: .
    internal static let decimalScalar = ".".unicodeScalars.first!
    /// The equals sign.
    internal static let equalScalar = "=".unicodeScalars.first!
    
    /// Digits 0-9
    internal static let digitScalars = [
                                           "0".unicodeScalars.first!,
                                           "1".unicodeScalars.first!,
                                           "2".unicodeScalars.first!,
                                           "3".unicodeScalars.first!,
                                           "4".unicodeScalars.first!,
                                           "5".unicodeScalars.first!,
                                           "6".unicodeScalars.first!,
                                           "7".unicodeScalars.first!,
                                           "8".unicodeScalars.first!,
                                           "9".unicodeScalars.first!
    ]
    
    /// Mapping of digits 0-9 as unicode scalars to integers.
    internal static let digitMapping: [UnicodeScalar:Int] = [
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
    
    //---------------------------------
    // MARK: Hex Characters
    //---------------------------------
    
    /// Hex characters 0-f
    internal static let hexScalars = [
                                         "0".unicodeScalars.first!,
                                         "1".unicodeScalars.first!,
                                         "2".unicodeScalars.first!,
                                         "3".unicodeScalars.first!,
                                         "4".unicodeScalars.first!,
                                         "5".unicodeScalars.first!,
                                         "6".unicodeScalars.first!,
                                         "7".unicodeScalars.first!,
                                         "8".unicodeScalars.first!,
                                         "9".unicodeScalars.first!,
                                         "a".unicodeScalars.first!,
                                         "b".unicodeScalars.first!,
                                         "c".unicodeScalars.first!,
                                         "d".unicodeScalars.first!,
                                         "e".unicodeScalars.first!,
                                         "f".unicodeScalars.first!
    ]
    
}