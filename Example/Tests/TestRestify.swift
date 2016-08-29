//
//  TestRestify.swift
//   
//
//  Created by Rohit Talwar on 19/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import UIKit
import DataStoreKit
import XCTest

class TestRestify: XCTestCase {

    var restClient:Restify<MyObject>!
    class MyObject:ObjectCoder{
    
        var name:String?
        var age:NSNumber?
        
        required init(dictionary withDictionary:NSDictionary){
            self.name = (withDictionary["name"] as? String) ?? ""
            self.age = (withDictionary["age"] as? NSNumber ) ?? 0
        }
        func toDictionary() -> NSDictionary{
            return  [
            "name":self.name ?? "",
            "age":self.age ?? 0]
        }
        
        static func identifierKey() -> String {
            return ""
        }
        
    }
    class MockNetwork:NetworkInterface{
        
        func POST(_ URLString: String!, parameters: Any!,callback: ((NSError?, Any?) -> Void)!){
        
        }
        func PUT(_ URLString: String!, parameters: Any!, callback: ((NSError?, Any?) -> Void)!) {
            
        }
        func GET(_ URLString: String!, parameters: Any!, callback: ((NSError?, Any?) -> Void)!){
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                let pass = URLString.range(of: "pass", options: NSString.CompareOptions.caseInsensitive)
                
                    (pass != nil) ? callback(nil,["name":"rajat","age":5]) : callback(NSError(domain: "Network Error", code: 404, userInfo: nil) ,nil)
            })
          
        }
        
        func DELETE(_ URLString: String!, parameters: Any?, callback: ((NSError?, Any?) -> Void)!) {
            
        }
        func setHTTPHeaders(_ headers: [String : String]) {
            
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

    func testNetworkCallSuccess() {
        // This is an example of a functional test case.
        restClient = Restify<MyObject>(path: "pass", networkClient: MockNetwork())
        let expectation = self.expectation(description: "Test Restify")
        restClient.get(id: "12",params: nil) { (error, result) -> Void in
            
            XCTAssertTrue(result != nil, "Successfully Deserialized object on successful network call")
            XCTAssertTrue(result is MyObject, "Successfully Deserialized object on successful network call")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
    }
    
    func testNetworkCallFailure() {
        // This is an example of a functional test case.
        restClient = Restify<MyObject>(path: "fail", networkClient: MockNetwork())
        let expectation = self.expectation(description: "Test Restify")
        restClient.get(id: "12",params: nil) { (error, result) -> Void in
            
            XCTAssertTrue(result == nil, "Result must be nil")
            XCTAssertTrue(error != nil, "Restify must return error object in callback on network failure")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
    }

 

}
