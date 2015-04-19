//
//  GenomeTests.swift
//  GenomeTests
//
//  Created by Logan Wright on 4/18/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit
import XCTest
import Genome

class GenomeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // TODO: - Write more and better tests
    
    func testMapping() {
        let event = Genome.GHEvent.gm_mappedObjectWithJsonRepresentation(GITHUB_EVENT_EXAMPLE_JSON)
        XCTAssert(event.identifier == GITHUB_EVENT_ID, "event id mapping failed")
        XCTAssert(event.url?.absoluteString == GITHUB_EVENT_URL, "url mapping failed")
        XCTAssert(event.eventDescription == GITHUB_EVENT_DESCRIPTION, "description mapping failed")
        XCTAssert(event.commitId == GITHUB_EVENT_COMMIT_ID, "commit sha mapping failed")
        let created = NSDate.dateWithISO8601String(GITHUB_EVENT_CREATED_AT_DATE_STRING)
        XCTAssert(event.createdAt == created, "date mapping failed")
        
        let user = event.actor!
        XCTAssert(user.login == GITHUB_USER_LOGIN, "login mapping failed")
        XCTAssert(user.identifier == GITHUB_USER_ID, "user id mapping failed")
        XCTAssert(user.apiUrl?.absoluteString == GITHUB_USER_API_URL, "user api url mapping failed")
        XCTAssert(user.type == GITHUB_USER_TYPE, "type mapping failed")
        XCTAssert(user.admin == GITHUB_USER_ADMIN, "bool admin mapping failed")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
