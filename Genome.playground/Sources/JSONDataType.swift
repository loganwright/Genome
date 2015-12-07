

extension String : JSONDataType {}
extension Bool : JSONDataType {}

// MARK: Integer Type

extension Int : JSONDataIntegerType {}
extension Int8 : JSONDataIntegerType {}
extension Int16 : JSONDataIntegerType {}
extension Int32 : JSONDataIntegerType {}
extension Int64 : JSONDataIntegerType {}

// MARK: Unsigned Integer Type

extension UInt : JSONDataIntegerType {}
extension UInt8 : JSONDataIntegerType {}
extension UInt16 : JSONDataIntegerType {}
extension UInt32 : JSONDataIntegerType {}
extension UInt64 : JSONDataIntegerType {}

// MARK: Floating Point

extension Double : JSONDataFloatingPointType {}

extension Float : JSONDataFloatingPointType {}
extension Float80 : JSONDataFloatingPointType {}

// MARK: JSON Data Type

public protocol JSONDataType {
    func rawRepresentation() throws -> AnyObject
    static func newInstance(rawValue: AnyObject, context: JSON) throws -> Self
}

extension JSONDataType {
    public func rawRepresentation() throws -> AnyObject {
        if let raw = self as? AnyObject {
            return raw
        } else {
            let error = RawConversionError
                .UnableToConvertToJSON
            throw logError(error)
        }
    }
    
    public static func newInstance(rawValue: AnyObject, context _: JSON) throws -> Self {
        if let value = rawValue as? Self {
            return value
        } else {
            let error = RawConversionError
                .UnableToConvertFromJSON(raw: rawValue, ofType: "\(rawValue.dynamicType)", expected: "\(Self.self)")
            throw logError(error)
        }
    }
}

// MARK: Integer Type

public protocol JSONDataIntegerType : JSONDataType {
    init(_ v: Int)
    init(_ rawValue: AnyObject)  throws
}

extension JSONDataIntegerType {
    public init(_ rawValue: AnyObject) throws {
        self = try Self.newInstance(rawValue)
    }
    
    public func rawRepresentation() throws -> AnyObject {
        // HAX: I don't want to do a bunch of type checking for converting up, consider alternatives
        guard let int = Int("\(self)") else {
            let error = RawConversionError.UnableToConvertToJSON
            throw logError(error)
        }
        return int
    }
    
    public static func newInstance(rawValue: AnyObject, context _: JSON = [:]) throws -> Self {
        if let value = rawValue as? Int {
            return Self(value)
        } else {
            let error = RawConversionError
                .UnableToConvertFromJSON(raw: rawValue, ofType: "\(rawValue.dynamicType)", expected: "\(Self.self)")
            throw logError(error)
        }
    }
}

// MARK: Floating Point Type

public protocol JSONDataFloatingPointType : JSONDataType {
    init(_ other: Double)
}

extension JSONDataFloatingPointType {
    public init(_ rawValue: AnyObject) throws {
        self = try Self.newInstance(rawValue)
    }
    
    public func rawRepresentation() throws -> AnyObject {
        // HAX: I don't want to do a bunch of type checking for converting up, consider alternatives
        guard let int = Double("\(self)") else {
            let error = RawConversionError.UnableToConvertToJSON
            throw logError(error)
        }
        return int
    }
    
    public static func newInstance(rawValue: AnyObject, context _: JSON = [:]) throws -> Self {
        if let value = rawValue as? Double {
            return Self(value)
        } else {
            let error = RawConversionError
                .UnableToConvertFromJSON(raw: rawValue, ofType: "\(rawValue.dynamicType)", expected: "\(Self.self)")
            throw logError(error)
        }
    }
}


