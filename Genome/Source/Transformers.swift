//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: Transformer Base

public class Transformer<InputType, OutputType> {
    
    internal let map: Map
    internal let transformer: InputType? throws -> OutputType

    private var allowsNil: Bool
    
    public init(map: Map, transformer: InputType throws -> OutputType) {
        self.map = map
        self.transformer = { input in
            return try transformer(input!)
        }
        self.allowsNil = false
    }
    
    public init(map: Map, transformer: InputType? throws -> OutputType) {
        self.map = map
        self.transformer = transformer
        self.allowsNil = true
    }
    
    internal func transformValue<T>(value: T) throws -> OutputType {
        if let input = value as? InputType {
            return try transformer(input)
        } else {
            throw logError(unexpectedInput(value))
        }
    }
    
    internal func transformValue<T>(value: T?) throws -> OutputType {
        if allowsNil {
            guard let unwrapped = value else { return try transformer(nil) }
            return try transformValue(unwrapped)
        } else {
            let unwrapped = try enforceValueExists(value)
            return try transformValue(unwrapped)
        }
        
    }
    
    private func unexpectedInput<ValueType>(value: ValueType) -> ErrorType {
        let message = "Unexpected Input: \(value) ofType: \(ValueType.self) Expected: \(InputType.self) KeyPath: \(map.lastKey)"
        return TransformationError.UnexpectedInputType(message)
    }
    
    private func enforceValueExists<T>(value: T?) throws -> T {
        if let unwrapped = value {
            return unwrapped
        } else {
            let error = TransformationError.UnexpectedInputType("Unexpectedly found nil input.  KeyPath: \(map.lastKey) Expected: \(InputType.self)")
            throw logError(error)
        }
    }
}


// MARK: From Dna

public final class FromDnaTransformer<DnaType: DnaConvertibleType, TransformedType> : Transformer<DnaType, TransformedType> {
    override public init(map: Map, transformer: DnaType throws -> TransformedType) {
        super.init(map: map, transformer: transformer)
    }
    
    override public init(map: Map, transformer: DnaType? throws -> TransformedType) {
        super.init(map: map, transformer: transformer)
    }
    
    public func transformToDna<OutputDnaType: DnaConvertibleType>(transformer: TransformedType throws -> OutputDnaType) -> TwoWayTransformer<DnaType, TransformedType, OutputDnaType> {
        let toDnaTransformer = ToDnaTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromDnaTransformer: self, toDnaTransformer: toDnaTransformer)
    }
    
    internal func transformValue(dna: Dna?) throws -> TransformedType {
        let validDna: Dna
        if allowsNil {
            guard let unwrapped = dna else { return try transformer(nil) }
            validDna = unwrapped
        } else {
            validDna = try enforceValueExists(dna)
        }
        
        let input = try DnaType.newInstance(validDna, context: validDna)
        return try transformer(input)
    }
}

// MARK: To Dna

public final class ToDnaTransformer<ValueType, OutputDnaType: DnaConvertibleType> : Transformer<ValueType, OutputDnaType> {
    override public init(map: Map, transformer: ValueType throws -> OutputDnaType) {
        super.init(map: map, transformer: transformer)
    }
    
    func transformFromDna<InputDnaType>(transformer: InputDnaType throws -> ValueType) -> TwoWayTransformer<InputDnaType, ValueType, OutputDnaType> {
        let fromDnaTransformer = FromDnaTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromDnaTransformer: fromDnaTransformer, toDnaTransformer: self)
    }
    
    func transformFromDna<InputDnaType>(transformer: InputDnaType? throws -> ValueType) -> TwoWayTransformer<InputDnaType, ValueType, OutputDnaType> {
        let fromDnaTransformer = FromDnaTransformer(map: map, transformer: transformer)
        return TwoWayTransformer(fromDnaTransformer: fromDnaTransformer, toDnaTransformer: self)
    }
    
    internal func transformValue(value: ValueType) throws -> Dna {
        let transformed = try transformer(value)
        return try transformed.dnaRepresentation()
    }
}

// MARK: Two Way Transformer

public final class TwoWayTransformer<InputDnaType: DnaConvertibleType, TransformedType, OutputDnaType: DnaConvertibleType> {
    
    var map: Map {
        let toMap = toDnaTransformer.map
        return toMap
    }
    
    public let fromDnaTransformer: FromDnaTransformer<InputDnaType, TransformedType>
    public let toDnaTransformer: ToDnaTransformer<TransformedType, OutputDnaType>
    
    public init(fromDnaTransformer: FromDnaTransformer<InputDnaType, TransformedType>, toDnaTransformer: ToDnaTransformer<TransformedType, OutputDnaType>) {
        self.fromDnaTransformer = fromDnaTransformer
        self.toDnaTransformer = toDnaTransformer
    }
}

// MARK: Map Extensions

public extension Map {
    public func transformFromDna<DnaType: DnaConvertibleType, TransformedType>(transformer: DnaType throws -> TransformedType) -> FromDnaTransformer<DnaType, TransformedType> {
        return FromDnaTransformer(map: self, transformer: transformer)
    }
    
    public func transformFromDna<DnaType: DnaConvertibleType, TransformedType>(transformer: DnaType? throws -> TransformedType) -> FromDnaTransformer<DnaType, TransformedType> {
        return FromDnaTransformer(map: self, transformer: transformer)
    }
    
    public func transformToDna<ValueType, DnaOutputType: DnaConvertibleType>(transformer: ValueType throws -> DnaOutputType) -> ToDnaTransformer<ValueType, DnaOutputType> {
        return ToDnaTransformer(map: self, transformer: transformer)
    }
}

// MARK: Operators

public func <~> <T: DnaConvertibleType, DnaInputType>(inout lhs: T, rhs: FromDnaTransformer<DnaInputType, T>) throws {
    switch rhs.map.type {
    case .FromDna:
        try lhs <~ rhs
    case .ToDna:
        try lhs ~> rhs.map
    }
}

public func <~> <T: DnaConvertibleType, DnaOutputType: DnaConvertibleType>(inout lhs: T, rhs: ToDnaTransformer<T, DnaOutputType>) throws {
    switch rhs.map.type {
    case .FromDna:
        try lhs <~ rhs.map
    case .ToDna:
        try lhs ~> rhs
    }
}

public func <~> <DnaInput, TransformedType, DnaOutput: DnaConvertibleType>(inout lhs: TransformedType, rhs: TwoWayTransformer<DnaInput, TransformedType, DnaOutput>) throws {
    switch rhs.map.type {
    case .FromDna:
        try lhs <~ rhs.fromDnaTransformer
    case .ToDna:
        try lhs ~> rhs.toDnaTransformer
    }
}

public func <~ <T, DnaInputType: DnaConvertibleType>(inout lhs: T, rhs: FromDnaTransformer<DnaInputType, T>) throws {
    switch rhs.map.type {
    case .FromDna:
        try lhs = rhs.transformValue(rhs.map.result)
    case .ToDna:
        break
    }
}

public func ~> <T, DnaOutputType: DnaConvertibleType>(lhs: T, rhs: ToDnaTransformer<T, DnaOutputType>) throws {
    switch rhs.map.type {
    case .FromDna:
        break
    case .ToDna:
        let output = try rhs.transformValue(lhs)
        try rhs.map.setToLastKey(output)
    }
}
