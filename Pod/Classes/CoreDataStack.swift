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
    private var _context:NSManagedObjectContext?
    
    public init(dbName:String){
        self.dbName = dbName
    }
    
    public func context() throws -> NSManagedObjectContext {
        
        guard let refContext = _context else{
            _context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
            
            _context!.persistentStoreCoordinator = try self.persistentStoreCoordinator()
            return _context!
        }
        return refContext
        
    }
    
     func persistentStoreCoordinator() throws -> NSPersistentStoreCoordinator? {
        if (_persistentStoreCoordinator != nil){
            return _persistentStoreCoordinator
        }
        NSLog("Providing SQLite persistent store coordinator")
        
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.dbName+".sqlite")
        let options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]
        
        _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        try _persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL: url, options: options)
        
//        var ps: NSPersistentStore?
//        let myErr:NSError?
//        do {
//            ps = try _persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL: url, options: options)
//        } catch let err as NSError {
//            myErr = err;
//            NSLog("%@",err.description)
//            ps = nil
//        } catch {
////            fatalError()
//        }
//        
//        if (ps == nil) {
//            throw myErr!
////            abort()
//        }
        
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
        
        let contextRef = try? context()
        
        guard let ct = contextRef else {
            print("Context not initialized")
            return ;
        }
        
        if ct.hasChanges{
            do {
                try ct.save()
            } catch let error1 as NSError {
                error = error1
                print("Could not save:\(error),\(error?.userInfo)")
            }
        }
    }
    
    public func cleanTable(entityName:String){
        guard let ct = try? context() else{
            NSLog("Context Not Initialized")
            return
        }
        let fetchRequest = NSFetchRequest()
        let description = NSEntityDescription.entityForName(entityName, inManagedObjectContext: ct)
        fetchRequest.entity = description
        var results: [AnyObject]?
        do {
            results = try ct.executeFetchRequest(fetchRequest)
        } catch _ as NSError {
            
            results = nil
        }
        
        for manageObject in results! {
            ct.deleteObject(manageObject as! NSManagedObject)
        }
        
    }
    
}