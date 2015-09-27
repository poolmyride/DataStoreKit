//
//  TestCoreDataFactory.swift
//  ConfNGiOS
//
//  Created by Rohit Talwar on 11/08/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import CoreData
public class InMemoryDataFactory{
    
    static var managedContexts:[String:NSManagedObjectContext] = [:]
    var context:NSManagedObjectContext
    public init(dbName:String){
        let stack = InMemoryDataStack(dbName: "TestSample")
        self.context = stack.context
    }
    
    class public func createStore<T:ObjectCoder>(dbName:String,entityName:String) -> CoreDataStore<T>{
        
        let context = managedContexts[dbName]
        return CoreDataStore<T>(entityName: entityName, managedContext: context!)
    }
}