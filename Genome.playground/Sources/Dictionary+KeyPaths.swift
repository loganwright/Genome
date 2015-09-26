//
//  Array+KeyPaths.swift
//  Genome
//
//  Created by Logan Wright on 7/2/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

public extension Dictionary {
    mutating func gnm_setValue(val: AnyObject, forKeyPath keyPath: String) {
        var keys = keyPath.gnm_keypathComponents()
        guard let first = keys.first as? Key else { print("Unable to use string as key on type: \(Key.self)"); return }
        keys.removeAtIndex(0)
        if keys.isEmpty, let settable = val as? Value {
            self[first] = settable
        } else {
            let rejoined = keys.joinWithSeparator(".")
            var subdict: [String : AnyObject] = [:]
            if let sub = self[first] as? [String : AnyObject] {
                subdict = sub
            }
            subdict.gnm_setValue(val, forKeyPath: rejoined)
            if let settable = subdict as? Value {
                self[first] = settable
            } else {
                print("Unable to set value: \(subdict) to dictionary of type: \(self.dynamicType)")
            }
        }
        
    }
    
    func gnm_valueForKeyPath<T>(keyPath: String) -> T? {
        var keys = keyPath.gnm_keypathComponents()
        guard let first = keys.first as? Key else { print("Unable to use string as key on type: \(Key.self)"); return nil }
        guard let value = self[first] as? AnyObject else { return nil }
        keys.removeAtIndex(0)
        if !keys.isEmpty, let subDict = value as? [String : AnyObject] {
            let rejoined = keys.joinWithSeparator(".")
            return subDict.gnm_valueForKeyPath(rejoined)
        }
        return value as? T
    }
}

private extension String {
    func gnm_keypathComponents() -> [String] {
        return characters
            .split { $0 == "." }
            .map { String($0) }
    }
}