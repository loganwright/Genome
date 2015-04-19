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
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#mapping">Mapping</a>

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

#Mapping

More coming in the morning
