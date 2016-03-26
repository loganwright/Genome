//import CoreData
//
//extension NSManagedObjectContext : Context {}
//
//public class ManagedObject: NSManagedObject, MappableBase {
//    
//    public enum Error: ErrorProtocol {
//        case ExpectedManagedObjectContext
//        case UnableToCreateObject
//    }
//    
//    // MARK: EntityName
//    
//    public class var entityName: String {
//        return "\(self)"
//            .characters
//            .split { $0 == "." }
//            .map(String.init)
//            .last ?? "\(self)"
//    }
//    
//    // MARK: Sequence
//    
//    public func sequence(map: Map) throws {}
//
//    public class func makeWith(node: Node, context: Context) throws -> Self {
//        return try makeWith(node, context: context, type: self)
//    }
//    
//    public class func makeWith<T: BackingDataType, U: ManagedObject>(node: T, context: Context, type: U.Type) throws -> U {
//        guard let context = context as? NSManagedObjectContext else {
//            throw logError(Error.ExpectedManagedObjectContext)
//        }
//        
//        let entity = NSEntityDescription.entity(forName: entityName, in: context)
//        guard let new = entity as? U else {
//            throw logError(Error.UnableToCreateObject)
//        }
//        
//        let map = Map(node: node, context: context)
//        try new.sequence(map)
//        return new
//    }
//}
