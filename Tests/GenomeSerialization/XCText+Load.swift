//
//  XCText+Load.swift
//  Genome
//
//  Created by McQuilkin, Brandon on 5/21/16.
//
//

import XCTest
import Foundation

extension XCTestCase {
    
    func loadResource(fromBundle bundle: NSBundle, resource: String, type: String) -> String {
        
        if let dataPath = bundle.pathForResource(resource, ofType: type) {
            do {
                return try String(contentsOfFile: dataPath, encoding: NSUTF8StringEncoding)
            } catch let error as NSError {
                XCTFail("Unable to load \"\(resource).\(type)\"" + error.localizedDescription)
            } catch {
                XCTFail("Unable to load \"\(resource).\(type)\". Unknown error")
            }
        } else {
            XCTFail("Unable to load \"\(resource).\(type)\". The file does not exist.")
        }
        
        // Calm down compiler...
        return ""
    }
    
}
