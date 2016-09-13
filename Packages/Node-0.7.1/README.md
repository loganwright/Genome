# Node

> a point at which lines or pathways intersect or branch; a central or connecting point.

![Swift](http://img.shields.io/badge/swift-v3.0--dev.08.18-brightgreen.svg)
[![Build Status](https://travis-ci.org/vapor/node.svg?branch=master)](https://travis-ci.org/vapor/node)
[![CircleCI](https://circleci.com/gh/vapor/node.svg?style=shield)](https://circleci.com/gh/vapor/node)
[![Code Coverage](https://codecov.io/gh/vapor/node/branch/master/graph/badge.svg)](https://codecov.io/gh/vapor/node)
[![Codebeat](https://codebeat.co/badges/a793ad97-47e3-40d9-82cf-2aafc516ef4e)](https://codebeat.co/projects/github-com-vapor-node)
[![Slack Status](http://vapor.team/badge.svg)](http://vapor.team)

The purpose of this package is to be an intermediary data layer that can allow transformation between unrelated formats. In this way any node convertible object can be converted to any other node convertible object and vice versa.

![](/Resources/ConvertiblePNG.png)

An example of this type of pattern below shows how we might create a `Model` from `JSON`, and then later serializing that `Model` to a `DatabaseFormat`. By using this pattern, we can seamlessly interchange `JSON` or `DatabaseFormat` as we see fit.

![](/Resources/ConcreteExamplePNG.png)

### 📋 Examples

Json to Int

```Swift
let id = try Int(with: json)
```

XML to Model

```Swift
let post = try Post(with: xml)
```

User from Json

```Swift
let user = try User(with: request, in: session)
```

Multi

```Swift
let user = try User(with: json)
let xml = try XML(with: user)
let response = try HTTPClient.get("http://legacyapi.why-xml", body: xml.serialize())
let profile = try Profile(with: response.json)
return try JSON(with: profile)
```

### ⛓ NodeConvertible

This type is used to define how a type is represented as `Node` and vice versa.

```Swift
public protocol NodeRepresentable {
    func makeNode() throws -> Node
}

public protocol NodeInitializable {
    init(with node: Node, in context: Context) throws
}

public protocol NodeConvertible: NodeInitializable, NodeRepresentable {}
```

Any type that conforms to this protocol can be converted into any other compatible type that also conforms.

> Note: `Context` above is an empty protocol that can be used for complex mapping. It is safe to ignore this if you're not using it internally

## 🌏 Environment

|Node|Xcode|Swift|
|:-:|:-:|:-:|
|0.5.x|8.0 Beta **6**|DEVELOPMENT-SNAPSHOT-2016-08-18-a|
|0.4.x|8.0 Beta **3**|DEVELOPMENT-SNAPSHOT-2016-07-25-a|
|0.3.x|8.0 Beta **3**|DEVELOPMENT-SNAPSHOT-2016-07-25-a|
|0.2.x|8.0 Beta **3**|DEVELOPMENT-SNAPSHOT-2016-07-25-a|
|0.1.x|8.0 Beta **2**|3.0-PREVIEW-2|

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to install Swift 3. 

## 💧 Community

We pride ourselves on providing a diverse and welcoming community. Join your fellow Vapor developers in [our slack](http://vapor.team) and take part in the conversation.

## 🔧 Compatibility

Node has been tested on OS X 10.11, Ubuntu 14.04, and Ubuntu 15.10.

## 👥 Authors

[Logan Wright](https://twitter.com/logmaestro)
