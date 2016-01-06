
public protocol JsonConvertibleType {
    static func newInstance(json: Json, context: Json) throws -> Self
    func jsonRepresentation() throws -> Json
}

// MARK: Json

extension Json : JsonConvertibleType {
    public static func newInstance(json: Json, context: Json = [:]) -> Json {
        return json
    }
    
    public func jsonRepresentation() -> Json {
        return self
    }
}

// MARK: String

extension String : JsonConvertibleType {
    public func jsonRepresentation() throws -> Json {
        return .from(self)
    }
    
    public static func newInstance(json: Json, context: Json = [:]) throws -> String {
        guard let string = json.stringValue else {
            throw logError(JsonConvertibleError.UnableToConvert(json: json, toType: "\(self)"))
        }
        return string
    }
}

// MARK: Boolean

extension Bool : JsonConvertibleType {
    public func jsonRepresentation() throws -> Json {
        return .from(self)
    }
    
    public static func newInstance(json: Json, context: Json = [:]) throws -> Bool {
        guard let bool = json.boolValue else {
            throw logError(JsonConvertibleError.UnableToConvert(json: json, toType: "\(self)"))
        }
        return bool
    }
}

// MARK: UnsignedIntegerType

extension UInt : JsonConvertibleType {}
extension UInt8 : JsonConvertibleType {}
extension UInt16 : JsonConvertibleType {}
extension UInt32 : JsonConvertibleType {}
extension UInt64 : JsonConvertibleType {}

extension UnsignedIntegerType {
    public func jsonRepresentation() throws -> Json {
        let double = Double(UIntMax(self.toUIntMax()))
        return .from(double)
    }
    
    public static func newInstance(json: Json, context: Json = [:]) throws -> Self {
        guard let int = json.uintValue else {
            throw logError(JsonConvertibleError.UnableToConvert(json: json, toType: "\(self)"))
        }
        
        return self.init(int.toUIntMax())
    }
}

// MARK: SignedIntegerType

extension Int : JsonConvertibleType {}
extension Int8 : JsonConvertibleType {}
extension Int16 : JsonConvertibleType {}
extension Int32 : JsonConvertibleType {}
extension Int64 : JsonConvertibleType {}

extension SignedIntegerType {
    public func jsonRepresentation() throws -> Json {
        let double = Double(IntMax(self.toIntMax()))
        return .from(double)
    }
    
    public static func newInstance(json: Json, context: Json = [:]) throws -> Self {
        guard let int = json.intValue else {
            throw logError(JsonConvertibleError.UnableToConvert(json: json, toType: "\(self)"))
        }
        
        return self.init(int.toIntMax())
    }
}

// MARK: FloatingPointType

extension Float : JsonConvertibleFloatingPointType {
    public var doubleValue: Double {
        return Double(self)
    }
}

extension Double : JsonConvertibleFloatingPointType {
    public var doubleValue: Double {
        return Double(self)
    }
}

public protocol JsonConvertibleFloatingPointType : JsonConvertibleType {
    var doubleValue: Double { get }
    init(_ other: Double)
}

extension JsonConvertibleFloatingPointType {
    public func jsonRepresentation() throws -> Json {
        return .from(doubleValue)
    }
    
    public static func newInstance(json: Json, context: Json = [:]) throws -> Self {
        guard let double = json.doubleValue else {
            throw logError(JsonConvertibleError.UnableToConvert(json: json, toType: "\(self)"))
        }
        return self.init(double)
    }
}

// MARK: Convenience

extension Json {
    public init(_ dictionary: [String : JsonConvertibleType]) throws{
        self = try Json.from(dictionary)
    }
    
    public static func from(dictionary: [String : JsonConvertibleType]) throws -> Json {
        var mutable: [String : Json] = [:]
        try dictionary.forEach { key, value in
            mutable[key] = try value.jsonRepresentation()
        }
        
        return .from(mutable)
    }
}
