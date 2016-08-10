//
//  CoreDataStore.swift
//   
//
//  Created by Rohit Talwar on 15/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import CoreData


public class CoreDataStore<T where T:ObjectCoder>:ModelProtocol{
    
    private let _entityName:String;
    let ALL_PATH = "/all"
    var context:NSManagedObjectContext
    
    public init(entityName:String,managedContext:NSManagedObjectContext){
        self._entityName = entityName
        self.context = managedContext
        
        
    }
    
    lazy var deserializer:ObjectDeserializer<T> = {
        var objD = ObjectDeserializer<T>()
        return objD
        
        }()
    
    private func _deserializeArray(objectArray : AnyObject?,callback: ModelArrayCallback? ){
        
        var resultArray:[T] = [T]()
        let manageObjectArray = objectArray as! Array<NSManagedObject>
        
        for manageObject in manageObjectArray{
            let attrByNames = manageObject.entity.attributesByName
            
            let newObjDic = NSMutableDictionary()
            for (key,_) in attrByNames{
                let value = manageObject.valueForKey(key)
                value != nil ? newObjDic[key] = value : ()
            }
            resultArray.append(T(dictionary: newObjDic))
        }
        
        callback?(nil,resultArray)
        
    }
    
    private func _deserializeObject(object : AnyObject?,callback: ModelObjectCallback? ){
        
       let manageObject = object as! NSManagedObject
        let attrByNames = manageObject.entity.attributesByName

        let newObjDic = NSMutableDictionary()
        for (key,_) in attrByNames{
            let value = manageObject.valueForKey(key)
            value != nil ? newObjDic[key] = value : ()
        }
        callback?(nil,T(dictionary: newObjDic))
        
    }
    
    public func query(params params:[String:AnyObject]? = [:], options:[String:AnyObject]? = [:], callback: ModelArrayCallback? ){
        

        let fetchRequest = QueryEngine.fetchRequestFromQuery(params, options: options)

        let description = NSEntityDescription.entityForName(self._entityName, inManagedObjectContext: self.context)
        fetchRequest.entity = description
        
        var error:NSError?
        var results: [AnyObject]?
        do {
            results = try context.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            results = nil
        }

        error == nil && results != nil ? self._deserializeArray(results as! [NSManagedObject], callback: callback) : callback?(error,nil)

    }
    
    public func all(callback:ModelArrayCallback?){

    }
    
    public func get(id id:CVarArgType?,params:[String:AnyObject]?, callback: ModelObjectCallback? ){
        let key = T.identifierKey()
        
        let fetchRequest = NSFetchRequest()
        let description = NSEntityDescription.entityForName(self._entityName, inManagedObjectContext: self.context)
        fetchRequest.entity = description
        fetchRequest.predicate = NSPredicate(format: "%K == %@", key ,id!)
        
        var error:NSError?
        var results: [AnyObject]?
        do {
            results = try context.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            results = nil
        }
        results = results as? [NSManagedObject]
        
        if(results?.count > 0){
            error == nil ? self._deserializeObject(results![0], callback: callback) : callback?(error,nil)
        }else{
            callback?(NSError(domain: "Not Found", code: 0, userInfo: nil),nil)
  
        }
        
    }
    
    public func put(id id: CVarArgType?, object: ObjectCoder, callback: ModelObjectCallback?) {
        

        let key = T.identifierKey()
        
        let fetchRequest = NSFetchRequest()
        let description = NSEntityDescription.entityForName(self._entityName, inManagedObjectContext: self.context)
        fetchRequest.entity = description
        
        fetchRequest.predicate = NSPredicate(format: "%K == %@", key ,id!)
        
        var results: [AnyObject]?
        do {
            results = try context.executeFetchRequest(fetchRequest)
        } catch let error as NSError {
            print(error)
            results = nil
        }
        
        results = results as? [NSManagedObject]


        if(results?.count > 0){
            let managedObject = results![0]
            let dic:NSDictionary = object.toDictionary()

            for (key,value) in dic {
                managedObject.setValue(value, forKey: key as! String)
            }
            
            var saveError: NSError?
            do {
                try context.save()
            } catch let error as NSError {
                saveError = error
            }
            callback?(saveError,(saveError == nil) ? object : nil)
        }else{
            self.add(object, callback: callback)
        }
    }
    
    public func add(object: ObjectCoder, callback: ModelObjectCallback?) {
        let entity = NSEntityDescription.entityForName(self._entityName, inManagedObjectContext: context)
        let newObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        let dictionary = object.toDictionary()
        
        for (key,val) in dictionary {
            let keyString = (key as! String)
            newObj.setValue(val,forKey:keyString)
        }
        
        var error: NSError?
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
        }
        callback?(error,(error == nil) ? object : nil)
        
    }
    
    public func remove(id id: CVarArgType?, params:[String:AnyObject]?, callback: ModelObjectCallback?) {
        
       
        let key = T.identifierKey()
        
        let fetchRequest = NSFetchRequest()
        let description = NSEntityDescription.entityForName(self._entityName, inManagedObjectContext: self.context)
        fetchRequest.entity = description
        
        fetchRequest.predicate = NSPredicate(format: "%K == %@", key ,id!)
        
        var results: [AnyObject]?
        do {
            results = try context.executeFetchRequest(fetchRequest)
        } catch let error as NSError {
            print(error)
            results = nil
        }
        
        results = results as? [NSManagedObject] ?? []
        

        if(results?.count > 0){
           
        let managedObject = results![0]

           context.deleteObject(managedObject as! NSManagedObject)

            var error: NSError?
            do {
                try context.save()
            } catch let error1 as NSError {
                error = error1
            }
          print(error)
            self._deserializeObject(results![0], callback: { (err, desObj) -> Void in
                callback?(error, error == nil ? desObj : nil)
            })

        }else {
            callback?(NSError(domain: "Not found", code: 0, userInfo: nil), nil);
        }
        
        
    }
}

