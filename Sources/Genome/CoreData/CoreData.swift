import CoreData

extension NSManagedObjectContext : Context {}

public class ManagedObject: NSManagedObject, MappableBase {
    
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
    
    public func sequence(map: Map) throws {}
}

extension MappableBase where Self: ManagedObject {
    public init(node: Node, context: Context) throws {
        let map = Map(node: node, context: context)
        self = try make(Self.self, with: map)
    }
}

private func make<T: ManagedObject>(type: T.Type, with map: Map) throws -> T {
    guard let context = map.context as? NSManagedObjectContext else {
        throw log(T.Error.ExpectedManagedObjectContext)
    }
    #if swift(>=3.0)
        let entity = NSEntityDescription.entity(forName: T.entityName, in: context)
    #else
        let entity = NSEntityDescription.entityForName(T.entityName, inManagedObjectContext: context)
    #endif
    guard let new = entity as? T else {
        throw log(T.Error.UnableToCreateObject)
    }
        
    try new.sequence(map)
    return new
}
