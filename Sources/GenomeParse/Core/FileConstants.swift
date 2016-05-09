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
    
    internal static let leftSquareBracket = UnicodeScalar(0x005b)
    internal static let leftCurlyBracket = UnicodeScalar(0x007b)
    internal static let rightSquareBracket = UnicodeScalar(0x005d)
    internal static let rightCurlyBracket = UnicodeScalar(0x007d)
    internal static let colon = UnicodeScalar(0x003A)
    internal static let comma = UnicodeScalar(0x002C)
    
    //---------------------------------
    // MARK: Whitespace
    //---------------------------------
    
    internal static let carriageReturn = UnicodeScalar(0x000D)
    internal static let lineFeed = UnicodeScalar(0x000A)
    internal static let backspace = UnicodeScalar(0x0008)
    internal static let formFeed = UnicodeScalar(0x000C)
    internal static let tabCharacter = UnicodeScalar(0x0009)
    internal static let space = UnicodeScalar(0x0020)
    
    //---------------------------------
    // MARK: String Characters
    //---------------------------------
    
    internal static let quotationMark = UnicodeScalar(0x0022)
    internal static let reverseSolidus = UnicodeScalar(0x005C)
    internal static let solidus = UnicodeScalar(0x002F)
    
    //---------------------------------
    // MARK: Numerical Characters
    //---------------------------------
    
    internal static let zeroScalar = "0".unicodeScalars.first!
    internal static let negativeScalar = "-".unicodeScalars.first!
    internal static let positiveScalar = "+".unicodeScalars.first!
    internal static let decimalScalar = ".".unicodeScalars.first!
    
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