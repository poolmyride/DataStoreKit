//
//  CoreDataStack.swift
//   
//
//  Created by Rohit Talwar on 08/08/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack{
    
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    var dbName:String = ""
    public init(dbName:String){
        self.dbName = dbName
    }
    
    public lazy var context:NSManagedObjectContext = {
        var context = NSManagedObjectContext()
        context.persistentStoreCoordinator = self.persistentStoreCoordinator()
        return context
        }()
    
     func persistentStoreCoordinator() -> NSPersistentStoreCoordinator? {
        if (_persistentStoreCoordinator != nil){
            return _persistentStoreCoordinator
        }
        NSLog("Providing SQLite persistent store coordinator")
        
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.dbName+".sqlite")
        let options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]
        
        _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        var ps: NSPersistentStore?
        do {
            ps = try _persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL: url, options: options)
        } catch _ as NSError {

            ps = nil
        } catch {
            fatalError()
        }
        
        if (ps == nil) {
            abort()
        }
        
        return _persistentStoreCoordinator
        }
    
    public lazy var model:NSManagedObjectModel = {
        let bndle = NSBundle.mainBundle()
        let modelURL = NSBundle.mainBundle().URLForResource(self.dbName, withExtension: "momd")!
       return  NSManagedObjectModel(contentsOfURL: modelURL)!
        
        }()
    
    static let sharedInstance:CoreDataStack = CoreDataStack(dbName: "NoDBNameProvided")

    var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
        }()

    
    public func saveContext(){
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
    
    public func cleanTable(entityName:String){
        let fetchRequest = NSFetchRequest()
        let description = NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.context)
        fetchRequest.entity = description
        var results: [AnyObject]?
        do {
            results = try self.context.executeFetchRequest(fetchRequest)
        } catch _ as NSError {
            
            results = nil
        }
        
        for manageObject in results! {
            self.context.deleteObject(manageObject as! NSManagedObject)
        }
        
    }
    
}