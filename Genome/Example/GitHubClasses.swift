
public class GHUser : NSObject, GenomeObject {
    
    public var login: String?
    public var identifier: NSInteger = 0
    public var apiUrl: NSURL?
    public var type: String?
    public var admin: Bool = false
    
    public class func mapping() -> [NSObject : AnyObject]! {
        var mapping: [String : String] = [:]
        mapping["login"] = "login"
        mapping["identifier"] = "id"
        mapping["apiUrl@StringToUrlTransformer"] = "url"
        mapping["type"] = "type"
        mapping["admin"] = "site_admin"
        return mapping
    }
}

public class GHEvent : NSObject, GenomeObject {
    
    public var identifier: NSInteger = 0
    public var url: NSURL?
    public var actor: GHUser?
    public var eventDescription: String?
    public var commitId: String?
    public var createdAt: NSDate?
    
    public class func mapping() -> [NSObject : AnyObject]! {
        var mapping: [String : String] = [:]
        mapping["identifier"] = "id"
        mapping["url@StringToUrlTransformer"] = "url"
        mapping["actor@GHUser"] = "actor"
        mapping["eventDescription"] = "event"
        mapping["commitId"] = "commit_id"
        mapping["createdAt@ISO8601DateTransformer"] = "created_at"
        return mapping
    }
    
}
