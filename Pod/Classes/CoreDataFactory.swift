//
//  CoreDataFactory.swift
//  ConfNGiOS
//
//  Created by Rohit Talwar on 11/08/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import CoreData
public class CoreDataFactory{
    
    var context:NSManagedObjectContext
    public init(dbName:String){
        let stack = CoreDataStack(dbName: dbName)
        self.context = stack.context
    }
    
     public func createStore<T:ObjectCoder>(entityName:String) -> CoreDataStore<T>{
        
        return CoreDataStore<T>(entityName: entityName, managedContext: self.context)
    }
}