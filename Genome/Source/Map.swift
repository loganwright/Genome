//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: Map

/// This class is designed to serve as an adaptor between the raw dna and the values.  In this way we can interject behavior that assists in mapping between the two.
public final class Map {
    
    // MARK: Map Type
    
    /**
    The representative type of mapping operation
    
    - ToDna:   transforming the object into a dna dictionary representation
    - FromDna: transforming a dna dictionary representation into an object
    */
    public enum OperationType {
        case ToDna
        case FromDna
    }
    
    /// The type of operation for the current map
    public let type: OperationType
    
    /// If the mapping operation were converted to Dna (Type.ToDna)
    public private(set) var toDna: Dna = .ObjectValue([:])
    
    /// The backing Dna being mapped
    public let dna: Dna
    
    /// The greater context in which the mapping takes place
    public let context: Context
    
    // MARK: Private
    
    /// The last key accessed -- Used to reverse Dna Operations
    internal private(set) var lastKey: KeyType = .KeyPath("")
    
    /// The last retrieved result.  Used in operators to set value
    internal private(set) var result: Dna? {
        didSet {
            if let unwrapped = result where unwrapped.isNull {
                result = nil
            }
        }
    }
    
    // MARK: Initialization
    
    /**
    The designated initializer
    
    :param: dna    the dna that will be used in the mapping
    :param: context the context that will be used in the mapping
    
    :returns: an initialized map
    */
    public init(dna: Dna, context: Context = EmptyDna) {
        self.dna = dna
        self.context = context
        self.type = .FromDna
    }
    
    public init() {
        self.dna = [:]
        self.context = EmptyDna
        self.type = .ToDna
    }
    
    // MARK: Subscript
    
    /**
    Basic subscripting
    
    :param: keyPath the keypath to use when getting the value from the backing dna
    
    :returns: returns an instance of self that can be passed to the mappable operator
    */
    public subscript(keyType: KeyType) -> Map {
        lastKey = keyType
        switch keyType {
        case let .Key(key):
            result = dna[key]
        case let .KeyPath(keyPath):
            result = dna.gnm_valueForKeyPath(keyPath)
        }
        return self
    }
    
    // MARK: To Dna
    
    /**
    Accept 'Any' type and convert for things like Int that don't conform to AnyObject, but can be put into Dna Dict and pass a cast to 'AnyObject'
    
    :param: any the value to set to the dna for the value of the last key
    */
    internal func setToLastKey(dna: Dna?) throws {
        guard let dna = dna else { return }
        switch lastKey {
        case let .Key(key):
            toDna[key] = dna
        case let .KeyPath(keyPath):
            toDna.gnm_setValue(dna, forKeyPath: keyPath)
        }
    }
}

extension Map {
    internal func setToLastKey<T : DnaConvertibleType>(any: T?) throws {
        try setToLastKey(any?.dnaRepresentation())
    }
    
    internal func setToLastKey<T : DnaConvertibleType>(any: [T]?) throws {
        try setToLastKey(any?.dnaRepresentation())
    }
    
    internal func setToLastKey<T : DnaConvertibleType>(any: [[T]]?) throws {
        guard let any = any else { return }
        let dna: [Dna] = try any.map { innerArray in
            return try innerArray.dnaRepresentation()
        }
        try setToLastKey(Dna.from(dna))
    }
    
    internal func setToLastKey<T : DnaConvertibleType>(any: [String : T]?) throws {
        guard let any = any else { return }
        var dna: [String : Dna] = [:]
        try any.forEach { key, value in
            dna[key] = try value.dnaRepresentation()
        }
        try setToLastKey(.from(dna))
    }
    
    internal func setToLastKey<T : DnaConvertibleType>(any: [String : [T]]?) throws {
        guard let any = any else { return }
        var dna: [String : Dna] = [:]
        try any.forEach { key, value in
            dna[key] = try value.dnaRepresentation()
        }
        try setToLastKey(.from(dna))
    }
    
    internal func setToLastKey<T : DnaConvertibleType>(any: Set<T>?) throws {
        try setToLastKey(any?.dnaRepresentation())
    }
}

