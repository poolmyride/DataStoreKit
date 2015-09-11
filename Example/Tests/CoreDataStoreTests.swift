//
//  TestCoreData.swift
//
//  Created by Rohit Talwar on 10/08/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import UIKit
import XCTest
import CoreData
import DataStoreKit
class CoreDataStoreTests: XCTestCase {
    
    var messageModel : CoreDataStore<Message>?
    var cacheModel : CoreDataStore<CacheEntry>?
    override func setUp() {
        super.setUp()
        self.messageModel = CoreDataStore<Message>(entityName: "Message", managedContext: TestCoreDataStack.sharedInstance.context)
        self.cacheModel = CoreDataStore<CacheEntry>(entityName: "CacheEntry", managedContext: TestCoreDataStack.sharedInstance.context)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        TestCoreDataStack.cleanDB("Message")
        super.tearDown()
    }
    
    
    func test1Save() {
        // This is an example of a functional test case.
        var dic = ["id" : "1234",
            "from_attendee" : "26",
            "to_attendee" : "28",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108258
        ]
        var expectation = self.expectationWithDescription("test save")
        
        var obj = Message(dictionary: dic)
        
        self.messageModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            
            self.messageModel!.get(id: "1234") { (error, obj) -> Void in
                XCTAssert(error == nil, "Pass")
                expectation.fulfill()
            }
            
        })
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
        
    }
    
    func test2Query() {
        // This is an example of a functional test case.
        
        var dic = ["id" : "1235",
            "from_attendee" : "26",
            "to_attendee" : "29",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108358
        ]
        
        var dic2 = ["id" : "1236",
            "from_attendee" : "26",
            "to_attendee" : "29",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108458
        ]
        var expectation = self.expectationWithDescription("test query")
        
        var obj = Message(dictionary: dic)
        var obj2 = Message(dictionary: dic2)
        self.messageModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            
            self.messageModel!.add(obj2, callback: { (error2, obj2) -> Void in
                XCTAssert(error == nil, "Pass")
                
                self.messageModel!.query(params: ["from_attendee":"26"], options: [:], callback: { (error, array) -> Void in
                    XCTAssertNil(error, "Pass")
                    
                    XCTAssert(array!.count == 2, "Pass")
                    expectation.fulfill()
                })
                
            })
            
        })
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
        
    }
    
    func test3Query() {
        // This is an example of a functional test case.
        
        var dic = ["id" : "1235",
            "from_attendee" : "26",
            "to_attendee" : "29",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108358
        ]
        
        var dic2 = ["id" : "1236",
            "from_attendee" : "26",
            "to_attendee" : "28",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108458
        ]
        var expectation = self.expectationWithDescription("test query")
        
        var obj = Message(dictionary: dic)
        var obj2 = Message(dictionary: dic2)
        self.messageModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            
            self.messageModel!.add(obj2, callback: { (error2, obj2) -> Void in
                XCTAssert(error == nil, "Pass")
                
                self.messageModel!.query(params: ["from_attendee":"26","to_attendee":"29"], options: [:], callback: { (error, array) -> Void in
                    XCTAssertNil(error, "Pass")
                    
                    XCTAssert(array!.count == 1, "Pass")
                    expectation.fulfill()
                })
                
            })
            
        })
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
        
    }
    
    
    func test4QueryWithOperand() {
        // This is an example of a functional test case.
        
        var dic = ["id" : "1235",
            "from_attendee" : "26",
            "to_attendee" : "29",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108558
        ]
        
        var dic2 = ["id" : "1236",
            "from_attendee" : "26",
            "to_attendee" : "29",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108658
        ]
        var expectation = self.expectationWithDescription("test query")
        
        var obj = Message(dictionary: dic)
        var obj2 = Message(dictionary: dic2)
        self.messageModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            
            self.messageModel!.add(obj2, callback: { (error2, obj2) -> Void in
                XCTAssert(error == nil, "Pass")
                
                self.messageModel!.query(params: ["created_ts >=":1437108600], options: [:], callback: { (error, array) -> Void in
                    XCTAssertNil(error, "Pass")
                    XCTAssert(array!.count == 1, "Pass")
                    
                    expectation.fulfill()
                })
                
            })
            
        })
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
        
    }
    
    func test5Put() {
        // This is an example of a functional test case.
        
        var dic = ["id" : "1235",
            "from_attendee" : "26",
            "to_attendee" : "29",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108558
        ]
        
        
        var expectation = self.expectationWithDescription("test query")
        
        var obj = Message(dictionary: dic)
        
        self.messageModel!.add(obj, callback: { (error, result) -> Void in
            
            XCTAssert(error == nil, "Pass")
            
            obj.message = "hello world"
            
                self.messageModel!.put(id: "1235", object: obj) { (error, resultPut) -> Void in
                    
                    var message = resultPut as? Message
                    XCTAssertNil(error, "Pass")
                    XCTAssert(message?.message == "hello world", "Pass")
                    
                    self.messageModel!.get(id: "1235", callback: { (errorGet, resultGet) -> Void in
                        var fetchedMessage = resultGet as? Message
                        XCTAssertNil(errorGet, "Pass")

                        XCTAssert(fetchedMessage?.message == "hello world", "Pass")
                        expectation.fulfill()

                    })
                }
            
            })
            
            self.waitForExpectationsWithTimeout(5.0, handler: nil)
        
    }
    
    func test5PutBindaryData() {
        // This is an example of a functional test case.
        var testID = "v1/proposals/123"
        var testString:NSString = "testString"
        var testData = testString.dataUsingEncoding(NSUTF8StringEncoding)
        // This is an example of a functional test case.
        var dic:NSDictionary = [
            "id" : testID,
            "data" : testData!
        ]
        var expectation = self.expectationWithDescription("test save")
        
        var obj = CacheEntry(dictionary: dic)
        
        self.cacheModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            
            self.cacheModel!.get(id: testID) { (error, obj) -> Void in
                XCTAssert(error == nil, "Pass")
                var cacheObj = obj as? CacheEntry
                var str = NSString(data: cacheObj?.data ?? NSData(), encoding: NSUTF8StringEncoding)
                XCTAssert(str == testString, "Pass")
                expectation.fulfill()
            }
            
        })
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
        
        
    }
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measureBlock() {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
