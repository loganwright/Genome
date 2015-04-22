
public class StringToUrlTransformer : GenomeTransformer {
    override public class func transformFromJsonValue(fromVal: AnyObject) -> AnyObject? {
        if let urlString = fromVal as? String {
            return NSURL(string: urlString)
        } else if let url = fromVal as? NSURL {
            return url
        } else {
            return nil
        }
    }
    override public class func transformToJsonValue(fromVal: AnyObject) -> AnyObject? {
        if let urlString = fromVal as? String {
            return urlString
        } else if let url = fromVal as? NSURL {
            return url.absoluteString
        } else {
            return nil
        }
    }
}

public class ISO8601DateTransformer : GenomeTransformer {
    override public class func transformFromJsonValue(fromVal: AnyObject) -> AnyObject? {
        if let dateString = fromVal as? String {
            return NSDate.dateWithISO8601String(dateString)
        } else {
            return nil
        }
    }
    override public class func transformToJsonValue(fromVal: AnyObject) -> AnyObject? {
        if let date = fromVal as? NSDate {
            return date.iso8601String
        } else {
            return nil
        }
    }
}

public extension NSDate {
    class public func dateWithISO8601String(dateString: String) -> NSDate {
        return self.iso8601DateFormatter().dateFromString(dateString)!
    }
    
    public var iso8601String: String {
        return NSDate.iso8601DateFormatter().stringFromDate(self)
    }
    
    private class func iso8601DateFormatter() -> NSDateFormatter {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        df.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return df
    }
}
