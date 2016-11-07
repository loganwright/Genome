/**
     Sometimes convertible operations require a greater context beyond
     just a Node.

     Any object can conform to Context and be included in initialization
*/
public protocol Context {}

extension Node : Context {}
extension Array : Context {}
extension Dictionary : Context {}

public let EmptyNode = Node.object([:])
