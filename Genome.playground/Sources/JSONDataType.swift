

extension String : JSONDataType {}

extension Int : JSONDataIntegerType {}
extension Int8 : JSONDataIntegerType {}
extension Int16 : JSONDataIntegerType {}
extension Int32 : JSONDataIntegerType {}
extension Int64 : JSONDataIntegerType {}

extension UInt : JSONDataIntegerType {}
extension UInt8 : JSONDataIntegerType {}
extension UInt16 : JSONDataIntegerType {}
extension UInt32 : JSONDataIntegerType {}
extension UInt64 : JSONDataIntegerType {}

extension Double : JSONDataFloatingPointType {}

extension Float : JSONDataFloatingPointType {}
extension Float80 : JSONDataFloatingPointType {}

// MARK: JSON Data Type

public protocol JSONDataType {
    func rawRepresentation() throws -> AnyObject
    static func newInstance(rawValue: AnyObject) throws -> Self
}

extension JSONDataType {
    public func rawRepresentation() throws -> AnyObject {
        return self as! AnyObject
    }
    
    public static func newInstance(rawValue: AnyObject, _: JSON = [:], currentKey: KeyType? = nil) throws -> Self {
//        guard let value = rawValue as? Self else { throw 
        // TODO: Throw
        return rawValue as! Self
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
        return self as! Int
    }
    
    public static func newInstance(rawValue: AnyObject, _: JSON = [:], currentKey: KeyType? = nil) throws -> Self {
        guard let intValue = rawValue as? Int else {
            let error = unexpectedResult(rawValue, expected: Int.self, keyPath: self.lastKey, targetType: Int.self)
            throw logError(error)
        }
        
        print("Self: \(Self.self)")
        return Self(intValue)
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
        return self as! Double
    }
    
    public static func newInstance(rawValue: AnyObject, _: JSON = [:]) throws -> Self {
        guard let intValue = rawValue as? Double else {
            throw
                MappingError
                    .UnableToMap("jsonValue: \(rawValue) ofType: \(rawValue.dynamicType) expected: \(Self.self)")
        }
        
        return Self(intValue)
    }
}