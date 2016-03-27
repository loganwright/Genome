import CoreData

#if swift(>=3.0)
#else
    public typealias ErrorProtocol = ErrorType
#endif

extension NSManagedObjectContext : Context {}

public class ManagedObject: NSManagedObject, MappableBase {
    
//    #if swift(>=3.0)
    public enum Error: ErrorProtocol {
        case ExpectedManagedObjectContext
        case UnableToCreateObject
    }
//    #else
//    public enum Error: ErrorType {
//        case ExpectedManagedObjectContext
//        case UnableToCreateObject
//    }
//    #endif
    
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
    public init(node: Node, context: Context = EmptyNode) throws {
        let map = Map(node: node, context: context)
        self = try make(Self.self, with: map)
    }
}

private func make<T: ManagedObject>(type: T.Type, with map: Map) throws -> T {
    guard let context = map.context as? NSManagedObjectContext else {
        throw logError(T.Error.ExpectedManagedObjectContext)
    }
    #if swift(>=3.0)
        let entity = NSEntityDescription.entity(forName: T.entityName, in: context)
    #else
        let entity = NSEntityDescription.entityForName(T.entityName, inManagedObjectContext: context)
    #endif
    guard let new = entity as? T else {
        throw logError(T.Error.UnableToCreateObject)
    }
        
    try new.sequence(map)
    return new
}
