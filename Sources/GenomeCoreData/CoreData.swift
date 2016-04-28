#if xcode

import CoreData
@_exported import Genome
    
extension NSManagedObjectContext : Context {}

public class ManagedObject: NSManagedObject, Genome.MappableBase {

    public enum Error: ErrorProtocol {
        case ExpectedManagedObjectContext
        case UnableToCreateObject
    }
    
    // MARK: EntityName
    
    public class var entityName: String {
        return "\(self)"
            .characters
            .split { $0 == "." }
            .map(String.init)
            .last ?? "\(self)"
    }
    
    // MARK: Sequence
    
    public func sequence(_ map: Map) throws {}
}

extension MappableBase where Self: ManagedObject {
    public init(with node: Node, in context: Context) throws {
        let map = Map(with: node, in: context)
        self = try make(type: Self.self, with: map)
    }

    public init(with convertible: NodeConvertible, in context: NSManagedObjectContext) throws {
        let node = try convertible.toNode()
        let map = Map(with: node, in: context)
        self = try make(type: Self.self, with: map)
    }
}

private func make<T: ManagedObject>(type: T.Type, with map: Map) throws -> T {
    guard let context = map.context as? NSManagedObjectContext else {
        throw T.Error.ExpectedManagedObjectContext
    }

    let entity = NSEntityDescription.entity(forEntityName: T.entityName, in: context)

    guard let new = entity as? T else {
        throw T.Error.UnableToCreateObject
    }
        
    try new.sequence(map)
    return new
}

#endif
