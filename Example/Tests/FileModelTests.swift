//
//  FileModelTests.swift
//  DataStoreKit
//
//  Created by Rohit Talwar on 19/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import DataStoreKit
class FileModelTests: XCTestCase {

    class Animal:ObjectCoder{
        var name:String?
        var type:String?
        required init(dictionary withDictionary: NSDictionary) {
            self.name = withDictionary["name"] as? String
            self.type = withDictionary["type"] as? String
        }
        func toDictionary() -> NSDictionary {
            return [:]
        }
        
        static func identifierKey() -> String {
            return "name"
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testJsonQuery() {
        
        let model = FileModel<Animal>(path: "animals.json")
        let expectation = self.expectation(description: "testJsonQuery")
        model.query { (err, results) -> Void in
            
            let animals  = results as? [Animal]
            
            XCTAssert(animals?.count == 2,"Pass")
            XCTAssert(animals?[0].name == "dog")
            XCTAssertNotNil(animals)
            expectation.fulfill()
            
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPlistQuery() {
        
        let model = FileModel<Animal>(path: "animals.plist")
        let expectation = self.expectation(description: "testPlistQuery")
        model.query { (err, results) -> Void in
            
            let animals  = results as? [Animal]
            
            XCTAssert(animals?.count == 2,"Pass")
            XCTAssert(animals?[0].name == "dog")
            XCTAssertNotNil(animals)
            expectation.fulfill()
            
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }


}
