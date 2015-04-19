//
//  ViewController.swift
//  Genome
//
//  Created by Logan Wright on 4/18/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit

let GITHUB_EVENT_EXAMPLE_JSON: [String : AnyObject] = [
    "id" : 1,
    "url" : "https://api.github.com/repos/octocat/Hello-World/issues/events/1",
    "actor" : [
        "login" : "octocat",
        "id" : 1,
        "avatar_url": "https://github.com/images/error/octocat_happy.gif",
        "gravatar_id": "",
        "url": "https://api.github.com/users/octocat",
        "html_url": "https://github.com/octocat",
        "followers_url": "https://api.github.com/users/octocat/followers",
        "following_url": "https://api.github.com/users/octocat/following{/other_user}",
        "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
        "organizations_url": "https://api.github.com/users/octocat/orgs",
        "repos_url": "https://api.github.com/users/octocat/repos",
        "events_url": "https://api.github.com/users/octocat/events{/privacy}",
        "received_events_url": "https://api.github.com/users/octocat/received_events",
        "type": "User",
        "site_admin": false
    ],
    "event" : "closed",
    "commit_id" : "6dcb09b5b57875f334f61aebed695e2e4193db5e",
    "created_at" : "2011-04-14T16:00:49Z"
]

class GHUser : NSObject, GenomeObject {
    
    var login: String?
    var identifier: NSInteger = 0
    var avatarUrl: NSURL?
    var gravatarUrl: NSURL?
    var apiUrl: NSURL?
    var htmlUrl: NSURL?
    var followersUrl: NSURL?
    var followingUrl: NSURL?
    var gistsUrl: NSURL?
    var starredUrl: NSURL?
    var subscriptionsUrl: NSURL?
    var organizationsUrl: NSURL?
    var reposUrl: NSURL?
    var eventsUrl: NSURL?
    var receivedEventsUrl: NSURL?
    var type: String?
    var admin: Bool = false
    
    class func mapping() -> [NSObject : AnyObject]! {
        var mapping: [String : String] = [:]
        mapping["login"] = "login"
        mapping["identifier"] = "id"
        mapping["avatarUrl"] = "avatar_url"
        mapping["gravatarUrl"] = "gravatar_url"
        mapping["apiUrl"] = "url"
        mapping["htmlUrl"] = "html_url"
        mapping["followersUrl"] = "followers_url"
        mapping["followingUrl"] = "following_url"
        mapping["gistsUrl"] = "gists_url"
        mapping["starredUrl"] = "starred_url"
        mapping["subscriptionsUrl"] = "subscriptions_url"
        mapping["organizationsUrl"] = "organizations_url"
        mapping["reposUrl"] = "repos_url"
        mapping["eventsUrl"] = "events_url"
        mapping["receivedEventsUrl"] = "received_events_url"
        mapping["type"] = "type"
        mapping["admin"] = "site_admin"
        return mapping
    }
}

class GHEvent : NSObject, GenomeObject {
 
    var identifier: NSInteger = 0
    var url: NSURL?
    var actor: GHUser?
    var eventDescription: String?
    var commitId: String?
    var createdAt: NSDate?
    
    class func mapping() -> [NSObject : AnyObject]! {
        var mapping: [String : String] = [:]
        mapping["identifier"] = "id"
        mapping["url"] = "url"
        mapping["actor@GHUser"] = "actor"
        mapping["eventDescription"] = "event"
        mapping["commitId"] = "commit_id"
        mapping[gm_propertyMap("createdAt", ISO8601DateTransformer.self)] = "created_at"
        return mapping
    }
    
}

class ISO8601DateTransformer : GenomeTransformer {
    override class func transformFromJsonValue(fromVal: AnyObject) -> AnyObject? {
        if let dateString = fromVal as? String {
            return NSDate.dateWithISO8601String(dateString)
        } else {
            return nil
        }
    }
    override class func transformToJSONValue(fromVal: AnyObject) -> AnyObject? {
        if let date = fromVal as? NSDate {
            return date.iso8601String
        } else {
            return nil
        }
    }
}

extension NSDate {
    class func dateWithISO8601String(dateString: String) -> NSDate {
        return self.iso8601DateFormatter().dateFromString(dateString)!
    }
    
    var iso8601String: String {
        return NSDate.iso8601DateFormatter().stringFromDate(self)
    }
    
    private class func iso8601DateFormatter() -> NSDateFormatter {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        df.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return df
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let event = GHEvent.gm_mappedObjectWithJsonRepresentation(GITHUB_EVENT_EXAMPLE_JSON)
        println(event.gm_mappableDescription())
        println(event.actor?.gm_mappableDescription())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

