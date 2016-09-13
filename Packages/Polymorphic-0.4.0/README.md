# Polymorphic

![Swift](http://img.shields.io/badge/swift-v3.0--dev.08.18-brightgreen.svg)
[![Build Status](https://travis-ci.org/vapor/polymorphic.svg?branch=master)](https://travis-ci.org/vapor/polymorphic)
[![CircleCI](https://circleci.com/gh/vapor/polymorphic.svg?style=shield)](https://circleci.com/gh/vapor/polymorphic)
[![Code Coverage](https://codecov.io/gh/vapor/polymorphic/branch/master/graph/badge.svg)](https://codecov.io/gh/vapor/polymorphic)
[![Codebeat](https://codebeat.co/badges/a793ad97-47e3-40d9-82cf-2aafc516ef4e)](https://codebeat.co/projects/github-com-vapor-polymorphic)
[![Slack Status](http://vapor.team/badge.svg)](http://vapor.team)

Syntax for easily accessing values from generic data.

## Example

```swift
let genericData = "123"

let int = genericData.int ?? 0 // Type `Int`, value 123
```

Or a more complex example

```swift
let genericData = "1, 2, 3"

let array = genericData.array ?? [] // Type `[Polymoprhic]`, value ["1", "2", "3"]

for item in array {
	let int = item.int ?? 0 // Will cast all items to `Int`s
}
```

## Use

Include the following in your package to use Polymorphic.

```swift
.Package(url: "https://github.com/qutheory/polymorphic.git", majorVersion: x, minor: x)
```

## 🌏 Environment

|Polymorphic|Xcode|Swift|
|:-:|:-:|:-:|
|0.4.x|8.0 Beta **6**|DEVELOPMENT-SNAPSHOT-2016-08-18-a|
|0.3.x|8.0 Beta **3**|DEVELOPMENT-SNAPSHOT-2016-07-20-qutheory|
|0.2.x|7.3.x|DEVELOPMENT-SNAPSHOT-2016-06-06-a|
|0.1.x|7.3.x|DEVELOPMENT-SNAPSHOT-2016-06-06-a|

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to install Swift 3. 

## 💧 Community

We pride ourselves on providing a diverse and welcoming community. Join your fellow Vapor developers in [our slack](http://vapor.team) and take part in the conversation.

## 🔧 Compatibility

Node has been tested on OS X 10.11, Ubuntu 14.04, and Ubuntu 15.10.

## 👥 Authors

[Logan Wright](https://twitter.com/logmaestro)