//
//  JsonSerializer.swift
//  JsonSerializer
//
//  Created by Fuji Goro on 2014/09/18.
//  Copyright (c) 2014年 Fuji Goro. All rights reserved.
//

public protocol JsonSerializer {
    init()
    func serialize(_: Json) -> String
}

internal class DefaultJsonSerializer: JsonSerializer {
    
    required init() {}
    
    internal func serialize(json: Json) -> String {
        switch json {
        case .NullValue:
            return "null"
        case .BooleanValue(let b):
            return b ? "true" : "false"
        case .NumberValue(let n):
            return serializeNumber(n)
        case .StringValue(let s):
            return escapeAsJsonString(s)
        case .ArrayValue(let a):
            return serializeArray(a)
        case .ObjectValue(let o):
            return serializeObject(o)
        }
    }

    func serializeNumber(n: Double) -> String {
        if n == Double(Int64(n)) {
            return Int64(n).description
        } else {
            return n.description
        }
    }

    func serializeArray(array: [Json]) -> String {
        var string = "["
        string += array
            .map { $0.serialize(self) }
            .joinWithSeparator(",")
        return string + "]"
    }

    func serializeObject(object: [String : Json]) -> String {
        var string = "{"
        string += object
            .map { key, val in
                let escapedKey = escapeAsJsonString(key)
                let serializedVal = val.serialize(self)
                return "\(escapedKey):\(serializedVal)"
            }
            .joinWithSeparator(",")
        return string + "}"
    }

}

internal class PrettyJsonSerializer: DefaultJsonSerializer {
    private var indentLevel = 0

    required init() {
        super.init()
    }
    
    override internal func serializeArray(array: [Json]) -> String {
        indentLevel++
        defer {
            indentLevel--
        }
        
        let indentString = indent()
        
        var string = "[\n"
        string += array
            .map { val in
                let serialized = val.serialize(self)
                return indentString + serialized
            }
            .joinWithSeparator(",\n")
        return string + " ]"
    }

    override internal func serializeObject(object: [String : Json]) -> String {
        indentLevel++
        defer {
            indentLevel--
        }
        
        let indentString = indent()
        
        var string = "{\n"
        string += object
            .map { key, val in
                let escapedKey = escapeAsJsonString(key)
                let serializedValue = val.serialize(self)
                let serializedLine = "\(escapedKey): \(serializedValue)"
                return indentString + serializedLine
            }
            .joinWithSeparator(",\n")
        string += " }"
        
        return string
    }

    func indent() -> String {
        return Array(1...indentLevel)
            .map { _ in "  " }
            .joinWithSeparator("")
    }
}
