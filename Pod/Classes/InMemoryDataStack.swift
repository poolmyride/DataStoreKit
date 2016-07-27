//
//  TestCoreDataStack.swift
//   
//
//  Created by Rohit Talwar on 10/08/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import CoreData

public class InMemoryDataStack: CoreDataStack {

    
      override func persistentStoreCoordinator() throws -> NSPersistentStoreCoordinator? {
        NSLog("Providing Mock SQLite persistent store coordinator")
        if (self._persistentStoreCoordinator != nil){
            return self._persistentStoreCoordinator
        }
        let psc: NSPersistentStoreCoordinator? =
        NSPersistentStoreCoordinator(managedObjectModel:
            super.model)

        try psc!.addPersistentStoreWithType(
                                NSInMemoryStoreType, configuration: nil,
                                URL: nil, options: nil)
        
//        var ps: NSPersistentStore?
//        do {
//            ps = try psc!.addPersistentStoreWithType(
//                        NSInMemoryStoreType, configuration: nil,
//                        URL: nil, options: nil)
//        } catch _ as NSError {
//            ps = nil
//        } catch {
//            fatalError()
//        }
//        
//        if (ps == nil) {
//            abort()
//        }
        
        return psc!
        }
    
    
    
  
}
