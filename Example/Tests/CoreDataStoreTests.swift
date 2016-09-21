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
    var animalModel : CoreDataStore<Animal>?
    var cacheModel : CoreDataStore<CacheEntry>?
    var coreDataStack :InMemoryDataStack?
    var pendingNetwork:CoreDataStore<PendingNetworkTask>?

    override func setUp() {
        super.setUp()
        self.coreDataStack = InMemoryDataStack(dbName: "TestSample")
        guard let ct = try? self.coreDataStack!.context() else {
            return ;
        }
        self.coreDataStack = InMemoryDataStack(dbName: "TestSample")
        self.animalModel = CoreDataStore<Animal>(entityName: "Animal", managedContext: ct)
        self.pendingNetwork = CoreDataStore<PendingNetworkTask>(entityName: "PendingNetworkTask", managedContext: ct)
        
        self.messageModel = CoreDataStore<Message>(entityName: "Message", managedContext: ct)
        
        self.cacheModel  = CoreDataStore<CacheEntry>(entityName: "CacheEntry", managedContext: ct)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.coreDataStack?.cleanTable("Message")
        self.coreDataStack?.cleanTable("Animal")

        super.tearDown()
    }
    
    
    func test1Save() {
        // This is an example of a functional test case.
        let dic = ["id" : "1234",
            "from_attendee" : "26",
            "to_attendee" : "28",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108258
        ] as [String : Any]
        let expectation = self.expectation(description: "test save")
        
        let obj = Message(dictionary: dic as NSDictionary)
        
        self.messageModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            
            self.messageModel!.get(id: "1234",params: nil) { (error, obj) -> Void in
                XCTAssert(error == nil, "Pass")
                expectation.fulfill()
            }
            
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func testSaveFewFields() {
        // This is an example of a functional test case.
        let dic = ["id" : "1234",
                   "created_ts" : 1437108258
            ] as [String : Any]
        let expectation = self.expectation(description: "test save")
        
        let obj = Message(dictionary: dic as NSDictionary)
        
        self.messageModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            
            self.messageModel!.get(id: "1234",params: nil) { (error, obj) -> Void in
                XCTAssert(error == nil, "Pass")
                expectation.fulfill()
            }
            
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func test11Save() {
        // This is an example of a functional test case.
        let dic = ["id" : "1234",
            "from_attendee" : "26",
            "to_attendee" : "28",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108258
        ] as [String : Any]
        let expectation = self.expectation(description: "test save")
        
        let obj = Message(dictionary: dic as NSDictionary)
        
        self.messageModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            
            self.messageModel!.remove(id: "1234", params: nil, callback: { (errRemove, removeResult) -> Void in
                
                XCTAssert(errRemove == nil, "Pass")
            
                self.messageModel!.get(id: "1234",params: nil) { (errorGet, objGet) -> Void in
                    XCTAssert(errorGet != nil, "Pass")
                    expectation.fulfill()
                }
            })
            
            
        })
        
        self.waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
    
    func test2Query() {
        // This is an example of a functional test case.
        
        let dic = ["id" : "1235",
            "from_attendee" : "26",
            "to_attendee" : "29",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108358
        ] as [String : Any]
        
        let dic2 = ["id" : "1236",
            "from_attendee" : "26",
            "to_attendee" : "29",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108458
        ] as [String : Any]
        let expectation = self.expectation(description: "test query")
        
        let obj = Message(dictionary: dic as NSDictionary)
        let obj2 = Message(dictionary: dic2 as NSDictionary)
        self.messageModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            
            self.messageModel!.add(obj2, callback: { (error2, obj2) -> Void in
                XCTAssert(error == nil, "Pass")
                
                self.messageModel!.query(params: ["from_attendee":"26"], options: [:], callback: { (error, array) -> Void in
                    XCTAssertNil(error, "Pass")
                    let arrayList = array as? [Message] ?? [Message]()
                    XCTAssert(arrayList.count == 2, "Pass")
                    expectation.fulfill()
                })
                
            })
            
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func test3Query() {
        // This is an example of a functional test case.
        
        let dic = ["id" : "1235",
            "from_attendee" : "26",
            "to_attendee" : "29",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108358
        ] as [String : Any]
        
        let dic2 = ["id" : "1236",
            "from_attendee" : "26",
            "to_attendee" : "28",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108458
        ] as [String : Any]
        let expectation = self.expectation(description: "test query")
        
        let obj = Message(dictionary: dic as NSDictionary)
        let obj2 = Message(dictionary: dic2 as NSDictionary)
        self.messageModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            
            self.messageModel!.add(obj2, callback: { (error2, obj2) -> Void in
                XCTAssert(error == nil, "Pass")
                
                self.messageModel!.query(params: ["from_attendee":"26","to_attendee":"29"], options: [:], callback: { (error, array) -> Void in
                    XCTAssertNil(error, "Pass")
                    
                    let arrayMessages = array as! [Message]
                    
                    XCTAssert(arrayMessages[0].from_attendee == "26", "Pass")
                    XCTAssert(arrayMessages[0].to_attendee == "29", "Pass")
                    XCTAssert(arrayMessages.count == 1, "Pass")
                    
                    expectation.fulfill()
                })
                
            })
            
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    
    func test4QueryWithOperand() {
        // This is an example of a functional test case.
        
        let dic = ["id" : "1235",
            "from_attendee" : "26",
            "to_attendee" : "29",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108558
        ] as [String : Any]
        
        let dic2 = ["id" : "1236",
            "from_attendee" : "26",
            "to_attendee" : "29",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108658
        ] as [String : Any]
        let expectation = self.expectation(description: "test query")
        
        let obj = Message(dictionary: dic as NSDictionary)
        let obj2 = Message(dictionary: dic2 as NSDictionary)
        self.messageModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            
            self.messageModel!.add(obj2, callback: { (error2, obj2) -> Void in
                XCTAssert(error == nil, "Pass")
                
                self.messageModel!.query(params: ["created_ts >=":1437108600], options: [:], callback: { (error, array) -> Void in
                    XCTAssertNil(error, "Pass")
                    let messageList = array as? [Message]
                    XCTAssert(messageList?.count == 1, "Pass")
                    
                    expectation.fulfill()
                })
                
            })
            
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func test5Put() {
        // This is an example of a functional test case.
        
        let dic = ["id" : "1235",
            "from_attendee" : "26",
            "to_attendee" : "29",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437108558
        ] as [String : Any]
        
        
        let expectation = self.expectation(description: "test query")
        
        let obj = Message(dictionary: dic as NSDictionary)
        
        self.messageModel!.add(obj, callback: { (error, result) -> Void in
            
            XCTAssert(error == nil, "Pass")
            
            obj.message = "hello world"
            
                self.messageModel!.put(id: "1235", object: obj) { (error, resultPut) -> Void in
                    
                    let message = resultPut as? Message
                    XCTAssertNil(error, "Pass")
                    XCTAssert(message?.message == "hello world", "Pass")
                    
                    self.messageModel!.get(id: "1235",params: nil, callback: { (errorGet, resultGet) -> Void in
                        let fetchedMessage = resultGet as? Message
                        XCTAssertNil(errorGet, "Pass")

                        XCTAssert(fetchedMessage?.message == "hello world", "Pass")
                        expectation.fulfill()

                    })
                }
            
            })
            
            self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func test5PutBindaryData() {
        // This is an example of a functional test case.
        let testID = "v1/proposals/123"
        let testString:NSString = "testString"
        let testData = testString.data(using: String.Encoding.utf8.rawValue)
        // This is an example of a functional test case.
        let dic:NSDictionary = [
            "id" : testID,
            "data" : testData!
        ]
        let expectation = self.expectation(description: "test save")
        
        let obj = CacheEntry(dictionary: dic)
        
        self.cacheModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            
            self.cacheModel!.get(id: testID,params: nil) { (error, obj) -> Void in
                XCTAssert(error == nil, "Pass")
                let cacheObj = obj as? CacheEntry
                let str = NSString(data: cacheObj?.data ?? Data(), encoding: String.Encoding.utf8.rawValue)
                XCTAssert(str == testString, "Pass")
                expectation.fulfill()
            }
            
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        
    }
    
    
    func test6FindByNumberValue() {
      
        let dic = ["id" : "1234",
            "from_attendee" : "26",
            "to_attendee" : "28",
            "type": "chat",
            "message": "hello",
            "created_ts" : 1437118258
        ] as [String : Any]
        let expectation = self.expectation(description: "test query")
        
        let obj = Message(dictionary: dic as NSDictionary)
        
        self.messageModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
           
            self.messageModel!.query(params: ["created_ts":1437118258], options: [:], callback: { (err:NSError?, result:Any?) -> Void in
                let results = result as? NSArray
                XCTAssert(results?.count == 1, "Passed")
                expectation.fulfill()
                
                
            })
            
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        
    }
    
    
    func test7GetByNumberValue() {
        
        let dic = ["animal" : "dog",
            "created" : NSNumber(value: 122233334)
            
        ] as [String : Any]
        let expectation = self.expectation(description: "test query by int")
        
        let obj = Animal(dictionary: dic as NSDictionary)
        
        self.animalModel!.add(obj, callback: { (error, obj) -> Void in
            print(obj)
            XCTAssert(error == nil, "Pass")
            let num = NSNumber(value: 122233334)
            self.animalModel?.get(id: num, params: [:], callback: { (err:NSError?, obj:Any?) -> Void in
                print(obj)
                let anim = obj as? Animal
                XCTAssert(err == nil, "Passed")
                XCTAssert(anim?.created == 122233334, "Passed")
                expectation.fulfill()
            })
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        
    }
    
    func test8RemoveByNumberValue() {
        
        let dic = ["animal" : "dog",
            "created" : 122233334
            
        ] as [String : Any]
        let expectation = self.expectation(description: "test query by int")
        
        let obj = Animal(dictionary: dic as NSDictionary)
        
        self.animalModel!.add(obj, callback: { (error, obj) -> Void in
            XCTAssert(error == nil, "Pass")
            let num = NSNumber(value: 122233334)
            self.animalModel?.remove(id: num, params: [:], callback: { (err:NSError?, result:Any?) -> Void in
                
                 
                XCTAssert(err == nil, "Passed")

                expectation.fulfill()

            })
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        
    }

    func test9Example() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let expectation = self.expectation(description: "add")
        
        let pendingNetworkObj = PendingNetworkTask(dictionary: [:])
        pendingNetworkObj.method = "POST"
        pendingNetworkObj.created = 12345678
        pendingNetworkObj.url = "url"
        pendingNetworkObj.body = ["a":"b"]
        self.pendingNetwork?.add(pendingNetworkObj, callback: { (err:NSError?, result:Any?) -> Void in
            
            
            self.pendingNetwork?.query(params: [:], options: [:], callback: { (queryErr:NSError?, queryResult:Any?) -> Void in

                let allPendingTasks = queryResult as! [PendingNetworkTask]
                let firstPendingTask:PendingNetworkTask = allPendingTasks[0]
                XCTAssertNil(err)
                XCTAssertNil(queryErr)
                XCTAssert(firstPendingTask.method == "POST", "pass")
                XCTAssert(firstPendingTask.url == "url", "pass")
                XCTAssert((firstPendingTask.body?["a"] as? String) == "b", "pass")

                expectation.fulfill()
            })
            
        })

        
               
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func test10Example() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let expectation = self.expectation(description: "put")
        
        let pendingNetworkObj = PendingNetworkTask(dictionary: [:])
        pendingNetworkObj.method = "POST"
        pendingNetworkObj.created = 12345678
        pendingNetworkObj.url = "url"
        pendingNetworkObj.body = ["a":"b"]
        self.pendingNetwork?.add(pendingNetworkObj, callback: { (err:NSError?, result:Any?) -> Void in
            
            self.pendingNetwork?.get(id: NSNumber(value: 12345678), params: [:], callback: { (errGet:NSError?, result:Any?) -> Void in
                
                let pendingTask = result as? PendingNetworkTask
                XCTAssertNil(errGet)
                XCTAssert(pendingTask?.created == 12345678, "pass")
                expectation.fulfill()

                
            })
            
            
            
        })
        
        
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measureBlock() {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
