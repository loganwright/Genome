
<p align="center">
  <img src="/Images/GenomeBanner.png" width=800></img>
</p>

<h2 align="center">Failure-Driven JSON Mapping in Swift</h2>

Genome has gone Swift!  If you're looking for the original, ObjC implementation, you can find it <a href="https://github.com/LoganWright/Genome/tree/0.1">here</a>!  If there is enough demand for maintenance, another branch may be created; however, any new developments will likely be done in Swift.

### Why

With great libraries like <a href="https://github.com/thoughtbot/Argo">Argo</a> and <a href="https://github.com/Hearst-DD/ObjectMapper">ObjectMapper</a>, why do we need another? Ultimately, I wanted to build it, and I wanted something a little different.  

The goal of this library is to satisfy the following constraints:

>\- Customizable Initialization

>\- Flexible Error Handling

>\- Failure Driven

>\- Automatic Nested Mapping

>\- Simple To Use

>\- Two-Way Serialization

>\- Transformable Values

>\- Type Safety

>\- Constants (`let`)

>\- Independent of Foundation Framework (Supports Linux)

>\- Struct Friendly

### Playground

The <a href="/GenomePlayground.playground">playground</a> provided by this project can be used to test the library.  It also provides more detail into how to use the library.  

### Failure Driven

With the introduction of Swift 2.0, we were given an entirely new error handling system, and a new keyword `try`.  In mapping json to models, there are, unfortunately, many points of failure.  By being very explicit about the failability of these operations, we can be confident that our code will run as expected, and gain clarity into error messages earlier in the process.  This means that we're going to have to write the word `try` quite a bit in the name of safety.

### Initial Setup

If you wish to install the library manually, you'll need to find the source files located in the playground's <a href="/Genome.playground/Sources">sources</a>  directory.

It is highly recommended that you install Genome through <a href="https://www.cocoapods.org">cocoapods.</a>  Here is a personal cocoapods reference just in case it may be of use: <a href="https://gist.github.com/LoganWright/5aa9b3deb71e9de628ba">Cocoapods Setup Guide</a>

```
pod 'Genome'
```

You can also install Genome using [Carthage](https://github.com/Carthage/Carthage). Just add the line below to your `Cartfile`:

```
github "LoganWright/Genome"
```

And execute `carthage update` to download and compile the framework.

### Quick Start

Let's take the following hypothetical JSON

```Swift
[
    "name" : "Rover",
    "nickname" : "RoRo", // Optional Value
    "type" : "dog"
]
```

Here's how we might create the model for this


```Swift
enum PetType : String {
    case Dog = "dog"
    case Cat = "cat"
}

struct Pet {
      var name: String = ""
      var type: PetType!
      var nickname: String?
}
```

Now, let's look at how we might provide a mapping schema for our model.

```Swift
extension Pet : BasicMappable {
    mutating func sequence(map: Map) throws {
        try name <~> map["name"]
        try nickname <~> map["nickname"]
        try type <~> map["type"]
            .transformFromJson {
                return PetType(rawValue: $0)
            }
            .transformToJson {
                return $0.rawValue
            }
    }
}
```

There's a lot to look at in this, here's some of the key points:

### `sequence(map: Map) throws`

Mappable objects must implement this method.  This is how the objects can be mapped.  It is marked `mutating` because it will modify values.

`Note, if you're only mapping to JSON, nothing will be mutated.`

### `<~>`

This is the main operation used in this library.  The `~` symbolizes a connection, and the `<` and `>` respectively symbol a flow of value.  When declared as `<~>` it symbolizes that mapping can flow both ways.

You could also use the following:

| Operator | Directions | Example | Mutates |
|:---:|:---:|:---:|:---:|
|`<~>`| To and From Json | `try name <~> map["name"]` | ✓ |
|`~>`| To Json Only | `try clientId ~> map["client_id"]` | 𝘅 |
|`<~`| From Json Only | `try updatedAt <~ map["updated_at"]` | ✓ |

### `transform`

Genome provides various options for transforming values.  These are type-safe and will be checked by the compiler.

>Note: At the moment, transforms require absolute optionality conformance in some situations. ie, Optionals get Optionals, ImplicitlyUnwrappedOptionals get ImplicitlyUnwrappedOptionals, etc.

#### `transformFromJson`

Use this if you need to transform the json input to accomodate your type.  In our example above, we need to convert the raw json to our associated enum.  This can also be appended to mappings for the `<~` operator.

#### `transformToJson`

Use this if you need to transform the given value to something more suitable for JSON.  This can also be appended to mappings for the `~>` operator.

### `try`

Why is the `try` keyword on every line!  Every mapping operation is failable if not properly specified.  It's better to deal with these possibilities, head first.  

For example, if a value is non-optional, and there's no associated value in the json, the operation should throw an error that can be easily caught.

### `BasicMappable`

In order to support flexible customization, Genome provides various mapping options for protocols.  Your object can conform to any of the following.  Although each of these initializers is marked with `throws`, it is not necessary for your initializer to `throw` if it is guaranteed to succeed.  In that case, you can omit the `throws` keyword safely.

| Protocol | Required Initializer |
|:---|:---|
| BasicMappable | `init() throws` |
| StandardMappable | `init(map: Map) throws` |
| CustomMappable | `static func newInstance(map: Map) throws -> Self` |

These are all just convenience protocols, and ultimately all derive from `MappableObject`.  If you wish to define your own implementation, all of the other functionality will still apply.

### Instantiation

Now we can easily create an object safely:

```Swift
do {
    let rover = try Pet.mappedInstance(json_rover)
    print(rover)
} catch {
    print(error)
}
```

If all we care about is whether or not we were able to create an object, we can also do the following:

```Swift
let rover = try? Pet.mappedInstance(json_rover)
print(rover) // Rover is type: `Pet?`
```

### `mappedInstance(json: JSON)`

This is the function that should be used to initialize new mapped objects for a given json.

### More

Feel free to check out and interact with the <a href="/GenomePlayground.playground">playground</a> provided in this repo!

### Alamofire

Here's a quick example of using Genome alongside <a href="https://github.com/Alamofire/Alamofire">Alamofire</a> (3.0)

```Swift
import Alamofire
import Genome

struct NasaPhoto : BasicMappable {
    private(set) var title: String = ""
    private(set) var mediaType: String = ""
    private(set) var explanation: String = ""
    private(set) var concepts: [String] = []

    private(set) var imageUrl: NSURL!

    mutating func sequence(map: Map) throws {
        try title <~ map["title"]
        try mediaType <~ map ["media_type"]
        try explanation <~ map["explanation"]
        try concepts <~ map["concepts"]
        try imageUrl <~ map["url"]
            .transformFromJson {
                return NSURL(string: $0)
            }
    }
}

enum NasaResult<T> {
    case Success(T)
    case Failure(ErrorType)
}

struct Nasa {

    enum NasaError : ErrorType {
        case UnableToConvertJson
    }

    static func fetchPictureOfTheDay(completion: NasaResult<NasaPhoto> -> Void) {
        let url = "https://api.nasa.gov/planetary/apod?concept_tags=True&api_key=DEMO_KEY"
        Alamofire.request(.GET, url)
            .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    do {
                        let json = try toJson(value)
                        let photo = try NasaPhoto.mappedInstance(json)
                        completion(.Success(photo))
                    } catch {
                        completion(.Failure(error))
                    }
                case .Failure(let error):
                    completion(.Failure(error))
                }
        }
    }

    private static func toJson(value: AnyObject) throws -> JSON {
        if let json = value as? JSON {
            return json
        } else {
            throw NasaError.UnableToConvertJson
        }
    }

}
```

Now, when we want to use our `NasaPhoto` object, we can use it knowing that it will be safe.

```Swift
Nasa.fetchPictureOfTheDay { [weak self] result in
    switch result {
    case .Success(let photo):
        self?.navigationItem.title = photo.title
        self?.descriptionLabel.text = photo.explanation
        self?.imageView.sd_setImageWithURL(photo.imageUrl)
    case .Failure(let error):
        print("Error: \(error)")
    }
}
```

Enjoy :)

### Initialization Options

One of the key components of this library is the ability to customize your objects initialization paradigm.  You can choose which protocol you'd like to conform to, or define your own if you'd like to, depending on your initialization requirements.

The library provides three protocol options for you:

>NOTE: Although each of these protocols defines a throwable initializer, you are not required to conform to this if your initializer won't throw.  This means that the requirement `init() throws` can be satisfied by `init()`. This applies to all throwable requirements.

#### `BasicMappable`

This protocol has the requirement:

```Swift
init() throws
```

This often applies to very simple objects that don't have any customization in the initializer that requires access to the `Map` object.

Quick Sample:

```Swift
struct Book : BasicMappable {
    var title = ""
    var releaseYear = 0

    mutating func sequence(map: Map) throws {
        try title <~> map["title"]
        try releaseYear <~> map["release_year"]
            .transformFromJson { (input: String) in
                return Int(input)!
            }
            .transformToJson {
                return "\($0)"
            }
    }
}
```

#### `StandardMappable`

This protocol has the requirement:

```Swift
init(map: Map) throws
```

This applies to objects who may want to access the `Map` object during initialization.  This could be for a number of reasons, but most commonly it's to take advantage of `let` constant variables.

Here's how our `Book` object might look with `StandardMappable` conformance.

```Swift
struct Book : StandardMappable {
    let title: String
    let releaseYear: Int

    init(map: Map) throws {
        try title = <~map["title"]
        try releaseYear = <~map["release_year"]
            .transformFromJson  { (input: String) -> Int in
                return Int(input)!
            }
    }

    func sequence(map: Map) throws {
        try title ~> map["title"]
        try releaseYear ~> map["release_year"]
            .transformToJson {
                return "\($0)"
            }
    }
}
```

>NOTE: Notice that above, `sequence(map: Map)` isn't marked `mutating`.  If we're only sequencing one way, it's not necessary to keep this marked `mutating`

#### `CustomMappable`

This protocol has the requirement:

```Swift
static func newInstance(map: Map) throws -> Self
```

This is good for objects that may need to check a database first to see if they still exist before we map a new one.  Let's stick with the `Book` example from above for clarity.  When we're creating an object, we'll see if one already exists in our database.

```Swift
struct Book : CustomMappable {
    var title: String = ""
    var releaseYear: Int = 0
    var id: String = ""

    static func newInstance(map: Map) throws -> Book {
        let id: String = try <~map["id"]
        return existingBookWithId(id) ?? Book()
    }

    mutating func sequence(map: Map) throws {
        try title <~> map["title"]
        try id <~> map["id"]
        try releaseYear <~> map["release_year"]
            .transformFromJson  { (input: String) -> Int in
                return Int(input)!
            }
            .transformToJson {
                return "\($0)"
            }
    }
}
```

#### Custom Implementation

Feel free to implement your own protocol by inheriting from `MappableObject` and defining the initializer.  Look at the implementations of the provided protocols for information on how to do this.

### Inheritance

For some types of architecture, you may want to utilize inheritance.  In these situations, you'll need to mark the initializer you're conforming to `required`.  For example, if our basic book from above was a class, we'd need to add the following:

```Swift
class Book : BasicMappable {
    var title = ""
    var releaseYear = 0

    required init() {}

    func sequence(map: Map) throws {
        try title <~> map["title"]
        try releaseYear <~> map["release_year"]
            .transformFromJson { (input: String) in
                return Int(input)!
            }
            .transformToJson {
                return "\($0)"
            }
    }
}
```

If you want classes, but aren't using inheritance, you can optionally mark a class `final`

### Setting Constants

Sometimes, for various reasons we don't want to pass a variable as an `inout`.  Because of limitations in the generic type system when using prefix operators, we need to be explicit when we're setting an optional value.

Note that these operators fall under the same failure driven development that the infix operators do, and the `try` keyword will still be required.  This looks a little funny at first, but is a much safer code base in the long run.

>NOTE: These operators should look familiar to the infix operators from earlier.  Remember that `~` still represents a connection, and `<` still symbolizes the flow of values.  We're just positioning them a bit differently.

#### `<~`

This operator is used for **non-optional** values.  You can use this for properties, or inline variables as desired:

```Swift
let someNumber: Int = try <~map["some_number"]
```

Or in an initializer:

```Swift
let someNumber: Int

init(map: Map) throws {
  someNumber = try <~map["some_number"]
}
```

>NOTE: Optional mappings will fail when using this operator.  See `<~?` for more on how it should be used.

#### `<~?`

The `?` extends our operator to symbolize the possibility that the value received can be `nil`.

This operator is used for **optional** values. At this time, Swift is unable to infer generic optionality through overloading the way it can with infix operators.  This means that we need to be explicit about our mapping when objects are optional.

```Swift
let possibleValue: String? = try <~?map["possible_value"]
```

Or in an initializer:

```Swift

let possibleValue: String?

init(map: Map) throws {
  possibleValue = try <~?map["possible_value"]
}
```

#### Transforming Settables

When attaching a transformer via these operators, use the `<~` prefix regardless of the optionality of the target.  In this case, optionality can be inferred through the provided transformation function.

##### Non-Optional

```Swift
let mappedString2: String = try <~map["key"]
    .transformFromJson { (input: String) -> String in
        return "Hello NonOptional \(input)"
    }
```

##### Optional

```Swift
let mappedString1: String? = try <~map["key"]
    .transformFromJson { (input: String?) -> String? in
        return "Hello \(input)"
    }
```

### Logging

All errors are passed through a logging system before being thrown.  This allows for helpful debugging and allows the potential to add remote logging to your project.

#### Adding Loggers

You can add any logger by conforming to `ErrorType -> Void`.  Here's a quick example of how we might implement this:

```Swift
func reportErrorToServer(error: ErrorType) {
    // ... handle the error here
}
```

Then, add it to the loggers:

```Swift
loggers.append(reportErrorToServer)
```

If you're using `Genome` through modules, it can be more clear to acknowledge the namespace:


```Swift
Genome.loggers.append(reportErrorToServer)
```

#### Turning Loggers Off

Just set `loggers` to an empty array and the system will no longer print to the console.

```Swift
loggers = []

// or namespaced

Genome.loggers = []
```
