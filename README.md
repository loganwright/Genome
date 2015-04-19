#Genome

Welcome to Genome!  This library is meant to simplify the process of mapping JSON to models by providing a clean and flexible api that binds mapping to their models.

---

<!-- [![CI Status](http://img.shields.io/travis/hunk/SlideMenu3D.svg?style=flat)](https://travis-ci.org/hunk/SlideMenu3D) -->
[![Version](https://img.shields.io/cocoapods/v/Genome.svg?style=flat)](http://cocoapods.org/pods/Genome)
[![License](https://img.shields.io/cocoapods/l/Genome.svg?style=flat)](http://cocoapods.org/pods/Genome)
[![Platform](https://img.shields.io/cocoapods/p/Genome.svg?style=flat)](http://cocoapods.org/pods/Genome)

---

<a href="http://loganwright.github.io/Genome/#">Documentation</a>
<br>
<a href="https://github.com/LoganWright/Genome#initial-setup">Initial Setup</a>
<br>
<a href="https://github.com/LoganWright/Genome#getting-started">Getting Started</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#genome-object">Genome Object</a>

---

#Initial Setup

If you wish to install the library manually, make sure to include all of the files in `Source`.  However, I strongly recommend familiarizing yourself with cocoapods.

It is highly recommended that you install Genome through <a href="cocoapods.org">cocoapods.</a>  Here is a personal cocoapods reference just in case it may be of use in learning: <a href="https://gist.github.com/LoganWright/5aa9b3deb71e9de628ba">Cocoapods Setup Guide</a>

Podfile: `pod 'Genome'`
<br>Import: `#import <Genome/Genome.h>`

#Getting Started

Let's look at an example of some Json that we might want to model.  Here's what a response from the GitHub API looks like for a `GitHubEvent`.

```
[
  {
    "id": 1,
    "url": "https://api.github.com/repos/octocat/Hello-World/issues/events/1",
    "actor": {
      "login": "octocat",
      "id": 1,
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
    },
    "event": "closed",
    "commit_id": "6dcb09b5b57875f334f61aebed695e2e4193db5e",
    "created_at": "2011-04-14T16:00:49Z"
  }
]
```

Let's take a look at how we might model that in our project.

######ObjC

```ObjC
@interface GHEvent : NSObject

@property (copy, nonatomic) NSInteger identifier;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) GHUser *actor;
@property (copy, nonatomic) NSString *eventDescription;
@property (copy, nonatomic) NSString *commitId;
@property (strong, nonatomic) NSString *createdAt;

@end
```

######Swift

```Swift
class GHEvent : NSObject, GenomeObject {

    var identifier: NSInteger = 0
    var url: NSURL?
    var actor: GHUser?
    var eventDescription: String?
    var commitId: String?
    var createdAt: String?

}
```

The question is how do we get that json parsed into our models, well that's where we define a mapping like so:

######ObjC

```ObjC
@implementation GHEvent

+ (NSDictionary *)mapping {
      NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
      mapping[@"identifier"] = @"id";
      mapping[@"url"] = @"url";
      mapping[@"actor"] = @"actor";
      mapping[@"eventDescription"] = @"event";
      mapping[@"commitId"] = @"commit_id";
      mapping[@"createdAt"] = @"created_at";
      return mapping;
}

@end
```

######Swift

```Swift
class GHEvent : NSObject, GenomeObject {

    var identifier: NSInteger = 0
    var url: NSURL?
    var actor: GHUser?
    var eventDescription: String?
    var commitId: String?
    var createdAt: String?

    class func mapping() -> [NSObject : AnyObject]! {
        var mapping: [String : String] = [:]
        mapping["identifier"] = "id"
        mapping["url"] = "url"
        mapping["actor"] = "actor"
        mapping["eventDescription"] = "event"
        mapping["commitId"] = "commit_id"
        mapping["createdAt"] = "created_at"
        return mapping
    }

}
```

Now our object knows how to map itself.  For the example above, let's imagine that our `GHUser` object declared as `actor` is also a `GenomeObject`.  The system will automatically infer and map that object accordingly.  Read further or check out the documentation to learn how much more you can do!  For this example, let's create our mapped object:

######ObjC

```ObjC
GHEvent *event = [GHEvent gm_mappedObjectWithJsonRepresentation:githubEventJson];
```

######Swift

```Swift
let event = GHEvent.gm_mappedObjectWithJsonRepresentation(githubEventJson)
```

#Genome Object

The core functionality of this library is contained in the `mapping` method that is declared on classes wishing to conform to `GenomeObject`.  You can however implement a great deal of customizations as necessary for particular situations.  This will demonstrate some of that behavior

##Basic Mapping

The basic syntax of the mapping dictionary is as follows:

######ObjC

```ObjC
mapping[@"<#propertyKeyPath#>"] = @"<#associatedJsonKeyPath#>";
```

######Swift

```Swift
mapping["<#propertyKeyPath#>"] = "<#associatedJsonKeyPath#>"
```

If you're unfamiliar with keyPath syntax, you can read about Key-Value Coding <a href="https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/KeyValueCoding.html">here</a>.  At it's simplist, it can be thought of as:

```
mapping["propertyName"] = "associatedJsonKey"
```

However, by utilizing key paths, we can create more complex behavior.  For example, if we have a json response that looks like this:

```
[
  "name" : "Jimbo",
  "address" : [
    "country" : "us",
    "street" : "main",
    // ...
  ]
]
```

If we had a user and we only wanted their name and country, the model would look like this:

```Swift
class User : NSObject, GenomeObject {
  var name: String?
  var country: String?

  class func mapping() -> [NSObject : AnyObject]! {
      var mapping: [String : String] = [:]
      mapping["name"] = "name"
      mapping["country"] = "address.country"
      return mapping
  }
}
```

By specifying the countries json path as `address.country`, we fetch the value at that key path and our object would populate properly.

##Object Properties

It's not uncommon to receive nested Json like our GitHub example in Getting Started.  Let's refresh ourselves with the event model:

```Swift
class GHEvent : NSObject, GenomeObject {

    var identifier: NSInteger = 0
    var url: NSURL?
    var actor: GHUser?
    var eventDescription: String?
    var commitId: String?
    var createdAt: String?

    class func mapping() -> [NSObject : AnyObject]! {
        var mapping: [String : String] = [:]
        mapping["identifier"] = "id"
        mapping["url"] = "url"
        mapping["actor"] = "actor"
        mapping["eventDescription"] = "event"
        mapping["commitId"] = "commit_id"
        mapping["createdAt"] = "created_at"
        return mapping
    }

}
```

You'll notice above that the property `actor` is declared as a `GHUser` type.  We haven't seen it yet, but this class as well is a `GenomeObject`.  Here's its implementation:

```Swift
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
```

Because this object also conforms to `GenomeObject` protocol, it will be automatically inferred that the object should be mapped and it will be populated appropriately.  This is done through introspection at runtime, but you can also declare the class a property should be mapped to through the following syntax:

```
mapping[@"<#arrayPropertyName#>@<#ClassName#>"] = @"<#associatedJsonKeyPath#>";
```

This may speed up mapping slightly if you're looking to optimize the process.  If you'd like to use the built in helper, you can declare mapped properties like such:

######ObjC

```ObjC
mapping[gm_propertyMap("actor", [GHUser class])] = @"actor";
```

######Swift

```Swift
mapping[gm_propertyMap("actor", GHUser.self)] = @"actor";
```

> This mapping strips the name space in Swift in its current implementation.  This means that if multiple libraries within your project conform to GenomeObject AND have the same class name, there may be problems.  If you want to use classes in the different namespaces, make sure to ONLY declare mappings explicitly via the `gm_propertyMap()` function.  Otherwise the system can't infer the mapping.

##Genome Object Arrays

It was mentioned above that properties defined as conforming to `GenomeObject` are inferred and mapped at runtime.  Unfortunately, it's not possible to infer what model that array will hold via objective-c runtime.  In these situations, you'll need to specify what class the array should be mapped to.  It is suggested to use the `gm_propertyMap` function specified above.

######ObjC

```ObjC
mapping[gm_propertyMap(@"array", [MyModel class])] = @"jsonArrayPath";
```

######Swift

```Swift
mapping[gm_propertyMap(@"array", MyModel.self)] = "jsonArrayPath";
```
