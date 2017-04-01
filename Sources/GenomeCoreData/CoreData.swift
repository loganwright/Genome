#if Xcode

import CoreData
    
extension NSManagedObjectContext: Context {}

public enum Error: Swift.Error {
    case expectedManagedObjectContext
    case unableToCreateObject
}

public protocol MappableManagedObject: Genome.MappableBase {
    static var entityName: String { get }
    static func create<T: MappableManagedObject>(map: Map) throws -> T
    mutating func sequence(_ map: Map) throws
}

extension MappableManagedObject where Self: NSManagedObject {

    public static func create<T: MappableManagedObject>(map: Map) throws -> T {
        guard let context = map.context as? NSManagedObjectContext else {
            throw Error.expectedManagedObjectContext
        }
        let entityName = T.entityName
        guard var entity = self.create(entityName: entityName, context: context) as? T else {
            throw Error.unableToCreateObject
        }
        try entity.sequence(map)
        return entity
    }

    private static func create(entityName: String, context: NSManagedObjectContext) -> NSManagedObject {
        let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        return entity
    }

}

extension MappableBase where Self: MappableManagedObject {
    public init(node: Node, in context: Context) throws {
        let map = Map(node: node, in: context)
        let entity: Self = try Self.create(map: map)
        self = entity
    }
//    public init(node: Node) throws {
//        let map = Map(node: node, in: node.context)
//        let entity: Self = try Self.create(map: map)
//        self = entity
//    }
}

#endif
