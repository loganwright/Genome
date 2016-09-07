#if Xcode

import CoreData
@_exported import Genome
@_exported import GenomeFoundation
    
extension NSManagedObjectContext : Context {}

public class ManagedObject: NSManagedObject, Genome.MappableBase {

    public enum Error: Swift.Error {
        case expectedManagedObjectContext
        case unableToCreateObject
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
    public init(node: Node, in context: Context) throws {
        let map = Map(node: node, in: context)
        self = try make(type: Self.self, with: map)
    }

    public init(node: NodeRepresentable, in context: NSManagedObjectContext) throws {
        let node = try node.makeNode()
        let map = Map(node: node, in: context)
        self = try make(type: Self.self, with: map)
    }
}

private func make<T: ManagedObject>(type: T.Type, with map: Map) throws -> T {
    guard let context = map.context as? NSManagedObjectContext else {
        throw T.Error.expectedManagedObjectContext
    }

    let entity = NSEntityDescription.entity(forEntityName: T.entityName, in: context)

    guard let new = entity as? T else {
        throw T.Error.unableToCreateObject
    }
        
    try new.sequence(map)
    return new
}

#endif
