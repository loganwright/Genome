import RealmSwift

public class RealmObject : RealmSwift.Object, MappableBase {
    required public init() {
        super.init()
    }
    
    public func sequence(map: Map) throws {}
    
    public static func makeWith(node: Node, context: Context) throws -> Self {
        let map = Map(node: node, context: context)
        let new = self.init()
        try new.sequence(map)
        return new
    }
}
