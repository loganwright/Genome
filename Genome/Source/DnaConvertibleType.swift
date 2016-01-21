//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: Constants

public let EmptyDna = Dna.ObjectValue([:])

// MARK: Context

public protocol Context {}

extension Map : Context {}
extension Dna : Context {}
extension Array : Context {}
extension Dictionary : Context {}

// MARK: DnaConvertibleType

public protocol DnaConvertibleType {
    static func newInstance(dna: Dna, context: Context) throws -> Self
    func dnaRepresentation() throws -> Dna
}

// MARK: Dna

extension Dna : DnaConvertibleType {
    public static func newInstance(dna: Dna, context: Context = EmptyDna) -> Dna {
        return dna
    }
    
    public func dnaRepresentation() -> Dna {
        return self
    }
}

// MARK: String

extension String : DnaConvertibleType {
    public func dnaRepresentation() throws -> Dna {
        return .from(self)
    }
    
    public static func newInstance(dna: Dna, context: Context = EmptyDna) throws -> String {
        guard let string = dna.stringValue else {
            throw logError(DnaConvertibleError.UnableToConvert(dna: dna, toType: "\(self)"))
        }
        return string
    }
}

// MARK: Boolean

extension Bool : DnaConvertibleType {
    public func dnaRepresentation() throws -> Dna {
        return .from(self)
    }
    
    public static func newInstance(dna: Dna, context: Context = EmptyDna) throws -> Bool {
        guard let bool = dna.boolValue else {
            throw logError(DnaConvertibleError.UnableToConvert(dna: dna, toType: "\(self)"))
        }
        return bool
    }
}

// MARK: UnsignedIntegerType

extension UInt : DnaConvertibleType {}
extension UInt8 : DnaConvertibleType {}
extension UInt16 : DnaConvertibleType {}
extension UInt32 : DnaConvertibleType {}
extension UInt64 : DnaConvertibleType {}

extension UnsignedIntegerType {
    public func dnaRepresentation() throws -> Dna {
        let double = Double(UIntMax(self.toUIntMax()))
        return .from(double)
    }
    
    public static func newInstance(dna: Dna, context: Context = EmptyDna) throws -> Self {
        guard let int = dna.uintValue else {
            throw logError(DnaConvertibleError.UnableToConvert(dna: dna, toType: "\(self)"))
        }
        
        return self.init(int.toUIntMax())
    }
}

// MARK: SignedIntegerType

extension Int : DnaConvertibleType {}
extension Int8 : DnaConvertibleType {}
extension Int16 : DnaConvertibleType {}
extension Int32 : DnaConvertibleType {}
extension Int64 : DnaConvertibleType {}

extension SignedIntegerType {
    public func dnaRepresentation() throws -> Dna {
        let double = Double(IntMax(self.toIntMax()))
        return .from(double)
    }
    
    public static func newInstance(dna: Dna, context: Context = EmptyDna) throws -> Self {
        guard let int = dna.intValue else {
            throw logError(DnaConvertibleError.UnableToConvert(dna: dna, toType: "\(self)"))
        }
        
        return self.init(int.toIntMax())
    }
}

// MARK: FloatingPointType

extension Float : DnaConvertibleFloatingPointType {
    public var doubleValue: Double {
        return Double(self)
    }
}

extension Double : DnaConvertibleFloatingPointType {
    public var doubleValue: Double {
        return Double(self)
    }
}

public protocol DnaConvertibleFloatingPointType : DnaConvertibleType {
    var doubleValue: Double { get }
    init(_ other: Double)
}

extension DnaConvertibleFloatingPointType {
    public func dnaRepresentation() throws -> Dna {
        return .from(doubleValue)
    }
    
    public static func newInstance(dna: Dna, context: Context = EmptyDna) throws -> Self {
        guard let double = dna.doubleValue else {
            throw logError(DnaConvertibleError.UnableToConvert(dna: dna, toType: "\(self)"))
        }
        return self.init(double)
    }
}

// MARK: Convenience

extension Dna {
    public init(_ dictionary: [String : DnaConvertibleType]) throws{
        self = try Dna.from(dictionary)
    }
    
    public static func from(dictionary: [String : DnaConvertibleType]) throws -> Dna {
        var mutable: [String : Dna] = [:]
        try dictionary.forEach { key, value in
            mutable[key] = try value.dnaRepresentation()
        }
        
        return .from(mutable)
    }
}
