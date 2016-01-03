//
//  JsonSerializer+Foundation.swift
//  JsonSerializer
//
//  Created by Fuji Goro on 2014/09/15.
//  Copyright (c) 2014 Fuji Goro. All rights reserved.
//

import class Foundation.NSData

extension Json {
    public static func deserialize(data: NSData) throws -> Json {
        let startPointer = UnsafePointer<UInt8>(data.bytes)
        let bufferPointer = UnsafeBufferPointer(start: startPointer, count: data.length)
        return try deserialize(bufferPointer)
    }
}
