
public enum JSONConvertibleError : ErrorType {
    case UnsupportedType(String)
    case UnableToConvert(json: Json, toType: String)
}

public typealias ContextType = Any // Temporary

public protocol JSONConvertibleType {
    static func newInstance(json: Json, context: Json) throws -> Self
    func jsonRepresentation() throws -> Json
}

// MARK: String

extension String : JSONConvertibleType {
    public func jsonRepresentation() throws -> Json {
        return .from(self)
    }
    
    public static func newInstance(json: Json, context: Json) throws -> String {
        guard let string = json.stringValue else {
            throw JSONConvertibleError.UnableToConvert(json: json, toType: "\(self)")
        }
        return string
    }
}

// MARK: Boolean

extension Bool : JSONConvertibleType {
    public func jsonRepresentation() throws -> Json {
        return .from(self)
    }
    
    public static func newInstance(json: Json, context: Json) throws -> Bool {
        guard let bool = json.boolValue else {
            throw JSONConvertibleError.UnableToConvert(json: json, toType: "\(self)")
        }
        return bool
    }
}

// MARK: UnsignedIntegerType

extension UInt : JSONConvertibleType {}
extension UInt8 : JSONConvertibleType {}
extension UInt16 : JSONConvertibleType {}
extension UInt32 : JSONConvertibleType {}
extension UInt64 : JSONConvertibleType {}

extension UnsignedIntegerType {
    public func jsonRepresentation() throws -> Json {
        let double = Double(UIntMax(self.toUIntMax()))
        return .from(double)
    }
    
    public static func newInstance(json: Json, context: Json) throws -> Self {
        guard let int = json.uintValue else {
            throw JSONConvertibleError.UnableToConvert(json: json, toType: "\(self)")
        }
        
        return self.init(int.toUIntMax())
    }
}

// MARK: SignedIntegerType

extension Int : JSONConvertibleType {}
extension Int8 : JSONConvertibleType {}
extension Int16 : JSONConvertibleType {}
extension Int32 : JSONConvertibleType {}
extension Int64 : JSONConvertibleType {}

extension SignedIntegerType {
    public func jsonRepresentation() throws -> Json {
        let double = Double(IntMax(self.toIntMax()))
        return .from(double)
    }
    
    public static func newInstance(json: Json, context: Json) throws -> Self {
        guard let int = json.intValue else {
            throw JSONConvertibleError.UnableToConvert(json: json, toType: "\(self)")
        }
        
        return self.init(int.toIntMax())
    }
}

// MARK: FloatingPointType

extension Float : JSONConvertibleFloatingPointType {
    public var doubleValue: Double {
        return Double(self)
    }
}

extension Double : JSONConvertibleFloatingPointType {
    public var doubleValue: Double {
        return Double(self)
    }
}

//extension Float80 : JSONConvertibleFloatingPointType {
//    public var doubleValue: Double {
//        return Double(self)
//    }
//}

public protocol JSONConvertibleFloatingPointType : JSONConvertibleType {
    var doubleValue: Double { get }
    init(_ other: Double)
}

extension JSONConvertibleFloatingPointType {
    public func jsonRepresentation() throws -> Json {
        return .from(doubleValue)
    }
    
    public static func newInstance(json: Json, context: Json) throws -> Self {
        guard let double = json.doubleValue else {
            throw JSONConvertibleError.UnableToConvert(json: json, toType: "\(self)")
        }
        return self.init(double)
    }
}
