//
//  CoreDataStack.swift
//
//
//  Created by Rohit Talwar on 08/08/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import CoreData

open class CoreDataStack{
    
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    var dbName:String = ""
    private var _context:NSManagedObjectContext?
    
    public init(dbName:String){
        self.dbName = dbName
    }
    
    public func context() throws -> NSManagedObjectContext {
        
        guard let refContext = _context else{
            _context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
            
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
        
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.dbName+".sqlite")
        let options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]
        
        _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        try _persistentStoreCoordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName:nil, at: url, options: options)
        
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
        let bndle = Bundle.main
        let modelURL = Bundle.main.url(forResource: self.dbName, withExtension: "momd")!
        return  NSManagedObjectModel(contentsOf: modelURL)!
        
    }()
    
    static let sharedInstance:CoreDataStack = CoreDataStack(dbName: "NoDBNameProvided")
    
    var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
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
                print("Could not save:\(error),\(error?.localizedDescription)")
            }
        }
    }
    
    public func cleanTable(_ entityName:String){
        guard let ct = try? context() else{
            NSLog("Context Not Initialized")
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let description = NSEntityDescription.entity(forEntityName: entityName, in: ct)
        fetchRequest.entity = description
        var results: [Any]?
        do {
            results = try ct.fetch(fetchRequest)
        } catch _ as NSError {
            
            results = nil
        }
        
        for manageObject in results! {
            ct.delete(manageObject as! NSManagedObject)
        }
        
    }
    
}
