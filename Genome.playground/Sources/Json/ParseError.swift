//
//  ParseError.swift
//  JsonSerializer
//
//  Created by Fuji Goro on 2014/09/15.
//  Copyright (c) 2014 Fuji Goro. All rights reserved.
//

protocol Parser {
    var lineNumber: Int { get }
    var columnNumber: Int { get }
}

public class ParseError: ErrorType, CustomStringConvertible {
    public let reason: String
    let parser: Parser

    public var lineNumber: Int {
        return parser.lineNumber
    }
    public var columnNumber: Int {
        return parser.columnNumber
    }

    public var description: String {
        return "\(Mirror(reflecting: self))[\(lineNumber):\(columnNumber)]: \(reason)"
    }

    init(_ reason: String, _ parser: Parser) {
        self.reason = reason
        self.parser = parser
    }
}

public class UnexpectedTokenError: ParseError { }

public class InsufficientTokenError: ParseError { }

public class ExtraTokenError: ParseError { }

public class NonStringKeyError: ParseError { }

public class InvalidStringError: ParseError { }

public class InvalidNumberError: ParseError { }