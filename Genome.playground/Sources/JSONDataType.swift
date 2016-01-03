
enum JSONConvertibleError : ErrorType {
    case UnsupportedType(String)
    case UnableToConvert(json: Json, toType: String)
}

protocol JSONConvertibleType {
    static func newInstance(json: Json) throws -> Self
    func jsonRepresentation() throws -> Json
}

// MARK: String

extension String : JSONConvertibleType {
    static func newInstance(json: Json) throws -> String {
        guard let string = json.stringValue else {
            throw JSONConvertibleError.UnableToConvert(json: json, toType: "\(self)")
        }
        return string
    }
}

// MARK: Boolean

extension Bool : JSONConvertibleType {
    func jsonRepresentation() throws -> Json {
        return .from(self)
    }
    
    static func newInstance(json: Json) throws -> Bool {
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
    func jsonRepresentation() throws -> Json {
        let double = Double(UIntMax(self.toUIntMax()))
        return .from(double)
    }
    
    static func newInstance(json: Json) throws -> Self {
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
    func jsonRepresentation() throws -> Json {
        let double = Double(IntMax(self.toIntMax()))
        return .from(double)
    }
    
    static func newInstance(json: Json) throws -> Self {
        guard let int = json.intValue else {
            throw JSONConvertibleError.UnableToConvert(json: json, toType: "\(self)")
        }
        
        return self.init(int.toIntMax())
    }
}

// MARK: FloatingPointType

extension Float : JSONConvertibleFloatingPointType {
    var doubleValue: Double {
        return Double(self)
    }
}
extension Double : JSONConvertibleFloatingPointType {
    var doubleValue: Double {
        return Double(self)
    }
}
extension Float80 : JSONConvertibleFloatingPointType {
    var doubleValue: Double {
        return Double(self)
    }
}
    
protocol JSONConvertibleFloatingPointType : JSONConvertibleType {
    var doubleValue: Double { get }
    init(_ other: Double)
}

extension JSONConvertibleFloatingPointType {
    func jsonRepresentation() throws -> Json {
        return .from(doubleValue)
    }
    
    static func newInstance(json: Json) throws -> Self {
        guard let double = json.doubleValue else {
            throw JSONConvertibleError.UnableToConvert(json: json, toType: "\(self)")
        }
        return self.init(double)
    }
}
