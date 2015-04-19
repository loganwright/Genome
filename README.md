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
<a href="https://github.com/LoganWright/Genome#genome-object">Genome Object</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#basic-mapping">Basic Mapping</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#object-properties">Object Properties</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#object-arrays">Object Arrays</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#transforming-values">Transforming Values</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#specialized-mapping">Specialized Mapping</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#default-properties">Default Properties</a>
<br>
<a href="https://github.com/LoganWright/Genome#genome-transformer">Genome Transformer</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#from-json">From Json</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#to-json">To Json</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#response-context">Response Context</a>
<br>
<a href="https://github.com/LoganWright/Genome#genome-mapping">Genome Mapping</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#initialization">Initialization</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#with-representation">With Representation</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#response-context-1">Response Context</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#mapped-objects">Mapped Objects</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#individual-objects">Individual Objects</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#arrays">Arrays</a>
<br>
<a href="https://github.com/LoganWright/Genome#debugging">Debugging</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#mappable-description">Mappable Description</a>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/LoganWright/Genome#logging">Logging</a>

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

###Object Properties

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

###Object Arrays

It was mentioned above that properties defined as conforming to `GenomeObject` are inferred and mapped at runtime.  Unfortunately, it's not possible to infer what model that array will hold via objective-c runtime.  In these situations, you'll need to specify what class the array should be mapped to.  If you're worried about it, it is suggested to use the `gm_propertyMap` function specified above.

######ObjC

```ObjC
mapping[gm_propertyMap(@"array", [MyModel class])] = @"jsonArrayPath";
```

-- Or --

```ObjC
mapping[@"array@MyModel"] = @"jsonArrayPath";
```

######Swift

```Swift
mapping[gm_propertyMap("array", MyModel.self)] = "jsonArrayPath";
```

-- Or --

```Swift
mapping["array@MyModel"] = "jsonArrayPath";
```

###Transforming Values

Quite often when receiving Json there are values we'd like to transform.  Some common examples of this are converting an `ISO8601` string to an `NSDate`, or a Hex String to a `UIColor`.  In Genome, this is done by creating classes that conform to `GenomeTransformer`.  Let's go back to our event model to look at an example.  Here's a refresher of the raw json:

```
[
  {
    "id": 1,
    "url": "https://api.github.com/repos/octocat/Hello-World/issues/events/1",
    "actor": {
      // ... actor values
    },
    "event": "closed",
    "commit_id": "6dcb09b5b57875f334f61aebed695e2e4193db5e",
    "created_at": "2011-04-14T16:00:49Z"
  }
]
```

As we can see, `created_at` corresponds to an `ISO8601` date format.  It would be nice if we could make a transformer to convert these strings to an NSDate in a way that can easily be used across all of our models needing conversion.  Look at the <a href="https://github.com/LoganWright/Genome#genome-transformer">Genome Transformer</a> section below, or check the <a href="http://loganwright.github.io/Genome/Classes/GenomeTransformer/index.html#//apple_ref/occ/cl/GenomeTransformer">documentation</a>

###Specialized Mapping

If you need a different mapping depending on whether or not the operation is from or to json, you can override `mappingForOperation:` instead.  This allows greater flexibility in defining your mapping.

##Default Properties

If genome finds `nil` or `NSNull` for a given Json key path, you can use this to define a default value that should exist.  It is defined through the following syntax:

```
defaults["<#propertyName#>"] = "<#defaultValue#>"
```


#Genome Transformer

The transformer is a class designed to make transforming values from one type to another easy to implement without repeating a lot of code across our models.  We will demonstrate how to convert a date string to an `NSDate`; however, you can override this method anytime you find a situation where the mapping's current implementation is not practical.

> Note: No mapping operations will occur if a transformer is provided.  This means that whatever you return in a transformer will be set directly to the property (assuming non-null).  This means if your transformation is dependent on subsequent mappings, these will need to be called within the transformer.

##From Json

Let's look at an extremely basic implementation of a `GenomeTransformer`.

######ObjC

`ISO8601DateTransformer.h`

```ObjC
@interface ISO8601DateTransformer : GenomeTransformer
@end
```

`ISO8601DateTransformer.m`

```ObjC
@implementation ISO8601DateTransformer

+ (id)transformFromJsonValue:(id)fromVal {
  return [NSDate dateWithISO8601String:fromVal];
}

@end
```

######Swift

```Swift
class ISO8601DateTransformer : GenomeTransformer {
    override class func transformFromJsonValue(fromVal: AnyObject) -> AnyObject? {
        if let dateString = fromVal as? String {
            return NSDate.dateWithISO8601String(dateString)
        } else {
            return nil
        }
    }
}
```

This would now replace or `GHEvent` object so that it looks like this:

######ObjC

```ObjC
@implementation GHEvent

+ (NSDictionary *)mapping {
      // other mappings
      mapping[@"createdAt@ISO8601DateTransformer"] = @"created_at";
      return mapping;
}

@end
```

######Swift

```Swift
class GHEvent : NSObject, GenomeObject {

    // ... other properties
    var createdAt: NSDate?

    class func mapping() -> [NSObject : AnyObject]! {
        var mapping: [String : String] = [:]
        // ... other mappings
        mapping["createdAt@ISO8601DateTransformer"] = "created_at"
        return mapping
    }

}
```

> Remember that if you're worried about name spacing, you could use the propertyMap function like so: `mapping[gm_propertyMap("createdAt", ISO8601DateTransformer.self)]`

####Warning

You'll notice that our transformers are declared with the same mapping syntax we use to specify types for an object property.  These are not to be used together, and a transformer always takes precedence.  It is assumed that if you need to call a transformer that will eventually result in a mapping, you will need to call the mapping operation manually within the transformer using: `gm_mappedObjectWithJsonRepresentation:` for objects and `gm_mapToGenomeObjectClass:` for arrays respectively.

##To Json

Sometimes we'll need to convert our object back to Json.  If that's the case, you'll also want to provide a reverse transformer by overriding `transformToJsonValue:`.  If we wanted to convert our `NSDate` back to an ISO8601 date string above, our full date string transformer would look like this:

######ObjC

```ObjC
@implementation ISO8601DateTransformer

+ (id)transformFromJsonValue:(id)fromVal {
  return [NSDate dateWithISO8601String:fromVal];
}

+ (id)transformToJsonValue:(id)fromVal {
  return [(NSDate *)fromVal iso8601String];
}

@end
```

######Swift

```Swift
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
```

##Response Context

For advanced or specialized transformer behavior, we provide an additional hook when parsing from json.  This takes the form of `transformFromJsonValue:inResponseContext:` and it passes in the greatest context initialized.  This means that when a property is being initialized, it can have access to the greater context.

#Genome Mapping

##Initialization

By default, genome will call `alloc] init];` on an object before mapping the Json to it.  In some situations, particularly when interfacing with core data, a more specific initialization is required.  In these situations, you can override `gm_newInstance`.

> Note: This will happen BEFORE the object is mapped.

####With Representation

Sometimes you might need access to the surrounding Json being used to initialize, if that's the case, you can override `gm_newInstanceForJsonRepresentation:`.

> Note:  Again, this will happen BEFORE the object is mapped and you should not override this method to do the entirety of the mapping.

####Response Context

If you're parsing a large Json response, sub-objects will receive the global response context for specialized behavior.  You can also access this response context during initialization.

> Note:  Again, this will happen BEFORE the object is mapped and you should not override this method to do the entirety of the mapping. Yes, I realize the redundancy, but sometimes people skip along and it's helpful to repeat oneself.

##Mapped Objects

To initialize an object with a Json Representation, you should use the following methods.

###Individual Objects

An individual object is mapped using `gm_mappedObjectWithJsonRepresentation:`.  You can call it like so once your model is properly declared:

######ObjC

```ObjC
GHEvent *event = [GHEvent gm_mappedObjectWithJsonRepresentation:eventJson];
```

######Swift

```Swift
let event = GHEvent.gm_mappedObjectWithJsonRepresentation(eventJson);
```

To convert these objects back to Json, you can use the following:

######ObjC

```ObjC
NSDictionary *eventJson = [event gm_jsonRepresentation];
```

######Swift

```Swift
let eventJson: [NSObject : AnyObject] = event.gm_jsonRepresentation()
```

###Arrays

For arrays, you should use the methods declared in `NSArray+GenomeMapping.h`. For mapping from Json, you should use `gm_mapToGenomeObjectClass` and pass the class to map each object to:

######ObjC

```ObjC
NSArray *events = [eventsJsonArray gm_mapToGenomeObjectClass:[GHEvent class]];
```

######Swift

```Swift
let events: [GHEvent] = eventsJsonArray.gm_mapToGenomeObjectClass(GHEvent.self) as? [GHEvent] ?? []
```

As with individual objects, arrays can be converted back to Json as well using `gm_mapToJSONRepresentation`:

######ObjC

```ObjC
NSArray *eventsJson = [events gm_mapToJSONRepresentation];
```

######Swift

```Swift
let eventsJsonArray: [AnyObject] = (events as NSArray).gm_mapToJSONRepresentation()
```

##Debugging

###Mappable Description

You can use `gm_mappableDescription` to help when debugging.  It prints our the current values for properties specified in `mapping`.  It is called like so:

######ObjC

```ObjC
[ob gm_mappableDescription];
```

######Swift

```Swift
ob.gm_mappableDescription()
```

###Logging

In `NSObject+GenomeMapping.m` set the flag on `static BOOL LOG = NO;` to `YES` in order to enable logging.



Feel free to browse the <a href="http://loganwright.github.io/Genome/#">Documentation</a> for more information.
