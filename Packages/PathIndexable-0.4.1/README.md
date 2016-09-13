# PathIndexable

![Swift](http://img.shields.io/badge/swift-v3.0--dev.08.18-brightgreen.svg)
[![Build Status](https://travis-ci.org/vapor/path-indexable.svg?branch=master)](https://travis-ci.org/vapor/path-indexable)
[![CircleCI](https://circleci.com/gh/vapor/path-indexable.svg?style=shield)](https://circleci.com/gh/vapor/path-indexable)
[![Code Coverage](https://codecov.io/gh/vapor/path-indexable/branch/master/graph/badge.svg)](https://codecov.io/gh/vapor/path-indexable)
[![Codebeat](https://codebeat.co/badges/a793ad97-47e3-40d9-82cf-2aafc516ef4e)](https://codebeat.co/projects/github-com-vapor-path-indexable)
[![Slack Status](http://vapor.team/badge.svg)](http://vapor.team)

The purpose of this package is to allow complex key path logic to be applied to multiple types of data structures.

This type is used to define a structure that can inherit complex subscripting.

```Swift
public protocol PathIndexable {
    /// If self is an array representation, return array
    var array: [Self]? { get }

    /// If self is an object representation, return object
    var object: [String: Self]? { get }

    /**
     Initialize a new object encapsulating an array of Self

     - parameter array: value to encapsulate
     */
    init(_ array: [Self])

    /**
     Initialize a new object encapsulating an object of type [String: Self]

     - parameter object: value to encapsulate
     */
    init(_ object: [String: Self])
}
```

Any type that conforms to this protocol inherits the following subscript functionality.

### Examples

Standard String

```Swift
let id = json["id"]
```

Standard Int

```Swift
let second = json[1]
```

Multiple Strings

ie:

```
let json = [
  "nested": [
    "key": "value"
  ]
]
```

```
let value = json["nested", "key"] // .string("value")
```

Multiple Ints

```
let json = [
  [0,1,2],
  [3,4,5]
]
```

```
let value = json[1, 2] // 5
```

Mixed

```
let json = [
  ["name" : "joe"]
  ["name" : "jane"]
]
```

```Swift
let value = json[0, "name"] // "joe"
```

Array Keys

```
let json = [
  ["name" : "joe"]
  ["name" : "jane"]
]
```

```Swift
let arrayOfNames = json["name"] // ["joe", "jane"]
```


## 🌏 Environment

|Polymorphic|Xcode|Swift|
|:-:|:-:|:-:|
|0.4.x|8.0 Beta **6**|DEVELOPMENT-SNAPSHOT-2016-08-18-a|
|0.3.x|8.0 Beta **3**|DEVELOPMENT-SNAPSHOT-2016-07-20-qutheory|
|0.2.x|7.3.x|DEVELOPMENT-SNAPSHOT-2016-05-03-a|
|0.1.x|7.3.x|DEVELOPMENT-SNAPSHOT-2016-05-03-a|

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.qutheory.io) for instructions on how to install Swift 3. 

## 💧 Community

We pride ourselves on providing a diverse and welcoming community. Join your fellow Vapor developers in [our slack](slack.qutheory.io) and take part in the conversation.

## 🔧 Compatibility

Node has been tested on OS X 10.11, Ubuntu 14.04, and Ubuntu 15.10.

## 👥 Authors

[Logan Wright](https://twitter.com/logmaestro)
