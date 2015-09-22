//
//  TestCoreDataStack.swift
//  ConfNGiOS
//
//  Created by Rohit Talwar on 10/08/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import CoreData


class TestCoreDataStack {

    
    lazy var context:NSManagedObjectContext = {
        var context = NSManagedObjectContext()
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
        }()
    
     lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        NSLog("Providing SQLite persistent store coordinator")
        
        var psc: NSPersistentStoreCoordinator? =
        NSPersistentStoreCoordinator(managedObjectModel:
            self.model)
        var error: NSError? = nil
        
        var ps: NSPersistentStore?
        do {
            ps = try psc!.addPersistentStoreWithType(
                        NSInMemoryStoreType, configuration: nil,
                        URL: nil, options: nil)
        } catch var error1 as NSError {
            error = error1
            ps = nil
        } catch {
            fatalError()
        }
        
        if (ps == nil) {
            abort()
        }
        
        return psc!
        }()
    
    lazy var model:NSManagedObjectModel = {
        let bndle = NSBundle(forClass: self.dynamicType)
        let modelURL = bndle.URLForResource("TestSample", withExtension: "momd")!
        return  NSManagedObjectModel(contentsOfURL: modelURL)!
        
        }()
    
    static let sharedInstance:TestCoreDataStack = TestCoreDataStack()
    
    var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
        }()
    
    
    init(){
        
        
    }
    
    static func cleanDB(entityName:String){
        let fetchRequest = NSFetchRequest()
        let description = NSEntityDescription.entityForName(entityName, inManagedObjectContext: TestCoreDataStack.sharedInstance.context)
        fetchRequest.entity = description
        var error:NSError?
        var results: [AnyObject]?
        do {
            results = try TestCoreDataStack.sharedInstance.context.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            results = nil
        }
        
        for manageObject in results! {
            TestCoreDataStack.sharedInstance.context.deleteObject(manageObject as! NSManagedObject)
        }
        
    }
    
    func saveContext(){
        var error:NSError? = nil
        if context.hasChanges{
            do {
                try context.save()
            } catch let error1 as NSError {
                error = error1
                print("Could not save:\(error),\(error?.userInfo)")
            }
        }
    }
 
}
