//
//  UserDefaultStoreTests.swift
//  DataStoreKit
//
//  Created by Rohit Talwar on 06/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import DataStoreKit
class UserDefaultStoreTests: XCTestCase {
    
    class Animal : ObjectCoder {
        
        var id:String?
        var name:String?
        
        required init(dictionary withDictionary: NSDictionary) {
            self.id = withDictionary["id"] as? String ?? ""
            self.name = withDictionary["id"] as? String ?? ""
        }
        
        func toDictionary() -> NSDictionary {
            return ["id":self.id ?? "","name":self.name ?? ""]
        }
        
        static func identifierKey() -> String {
            return "id"
        }
    }
    let testId = "testId"
    let animal = Animal(dictionary: ["id":"2","name":"Dog"])

    var model:UserDefaultStore<Animal>?
    override func setUp() {
        super.setUp()
        self.model = UserDefaultStore<Animal>()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPut() {

        self.model?.put(id: testId, object: animal, callback: { (err, obj) -> Void in
            
            XCTAssertNil(err,"Pass")
            
            self.model?.get(id: self.testId, params: nil, callback: { (err, result) -> Void in
                
                let anim = result as? Animal
                
                XCTAssertEqual(anim?.id, anim?.id, "Pass")
                XCTAssertEqual(anim?.name, anim?.name, "Pass")
            })
            
        })
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testDelete() {

        let expectation = self.expectationWithDescription("testDelete")
        self.model?.put(id: testId, object: animal, callback: { (err, obj) -> Void in
            
            XCTAssertNil(err,"Pass")
            
            self.model?.remove(id: self.testId, params: nil, callback: { (err, result) -> Void in
                
                let anim = result as? Animal
                XCTAssertEqual(anim?.id, anim?.id, "Pass")
                XCTAssertEqual(anim?.name, anim?.name, "Pass")
                
                self.model?.get(id: self.testId, params: nil, callback: { (err, result) -> Void in
                    
                    let anim = result as? Animal
                    XCTAssertNil(anim, "Pass")
                    
                    expectation.fulfill()

                })
                
            })
           
            
        })
        
        self.waitForExpectationsWithTimeout(5, handler: nil)
       
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
