#if !os(Linux)

import CoreData
    
extension NSManagedObjectContext : Context {}

open class ManagedObject: NSManagedObject, Genome.MappableBase {
    public enum Error: Swift.Error {
        case expectedManagedObjectContext
        case unableToCreateObject
    }
    
    // MARK: EntityName
    
    open class var entityName: String {
        return "\(self)"
            .split { $0 == "." }
            .map(String.init)
            .last ?? "\(self)"
    }
    
    // MARK: Sequence
    
    open func sequence(_ map: Map) throws {}
}

extension MappableBase where Self: ManagedObject {
    public init(node: Node, in context: Context) throws {
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
