//
//  CoreDataStore.swift
//  ConfNGiOS
//
//  Created by Rohit Talwar on 15/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import CoreData


public class CoreDataStore<T where T:ObjectCoder>:ModelProtocol{
    
    let entityName:String;
    let ALL_PATH = "/all"
    var context:NSManagedObjectContext
    
    public init(entityName:String,managedContext:NSManagedObjectContext){
        self.entityName = entityName
        self.context = managedContext
        
        
    }
    
    lazy var deserializer:ObjectDeserializer<T> = {
        var objD = ObjectDeserializer<T>()
        return objD
        
        }()
    
    private func _deserializeArray(objectArray : AnyObject?,callback: ModelArrayCallback? ){
        
        var resultArray:[T] = [T]()
        var manageObjectArray = objectArray as! Array<NSManagedObject>
        
        for manageObject in manageObjectArray{
            var emptyObj = T(dictionary: [:])
            var emptyObjDic = emptyObj.toDictionary()
            var newObjDic = NSMutableDictionary(dictionary: emptyObjDic)
            for (key,val) in emptyObjDic{
                newObjDic[(key as! String)] = manageObject.valueForKey((key as! String))
            }
            resultArray.append(T(dictionary: newObjDic))
        }
        
        callback?(nil,resultArray)
        
    }
    
    private func _deserializeObject(object : AnyObject?,callback: ModelObjectCallback? ){
        
       var manageObject = object as! NSManagedObject
        var emptyObj = T(dictionary: [:])
        var emptyObjDic = emptyObj.toDictionary()
        var newObjDic = NSMutableDictionary(dictionary: emptyObjDic)
        for (key,val) in emptyObjDic{
            newObjDic[(key as! String)] = manageObject.valueForKey((key as! String))
        }
        callback?(nil,T(dictionary: newObjDic))
        
    }
    
    public func query(params:[String:AnyObject]? = [:], options:[String:AnyObject]? = [:], callback: ModelArrayCallback? ){
        

        let fetchRequest = QueryEngine.fetchRequestFromQuery(params: params, options: options)

        let description = NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.context)
        fetchRequest.entity = description
        
        var error:NSError?
        var results = context.executeFetchRequest(fetchRequest, error: &error)

        error == nil ? self._deserializeArray(results as! [NSManagedObject], callback: callback) : callback?(error,nil)

    }
    
    public func all(callback:ModelArrayCallback?){
//        var path  = base_url + ALL_PATH
//        
//        networkClient.GET(path, parameters: nil) { (error, jsonObject) -> Void in
//            (error == nil) ? self._deserializeArray(jsonObject, callback: callback) : callback(error,nil)
//        }
        
        
        
    }
    
    public func get(#id:String?, callback: ModelObjectCallback? ){
        var key = T.identifierKey()
        
        let fetchRequest = NSFetchRequest()
        let description = NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.context)
        fetchRequest.entity = description
        
        fetchRequest.predicate = NSPredicate(format: "%K == %@", key ,id!)
        
        var error:NSError?
        var results = context.executeFetchRequest(fetchRequest, error: &error)
        results = results as? [NSManagedObject]
        
        if(results!.count > 0){
            error == nil ? self._deserializeObject(results![0], callback: callback) : callback?(error,nil)
        }else{
            callback?(NSError(domain: "Not Found", code: 0, userInfo: nil),nil)
  
        }
        
    }
    
    public func put(#id: String?, object: ObjectCoder, callback: ModelObjectCallback?) {
        
        
        var key = T.identifierKey()
        
        let fetchRequest = NSFetchRequest()
        let description = NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.context)
        fetchRequest.entity = description
        
        fetchRequest.predicate = NSPredicate(format: "%K == %@", key ,id!)
        
        var error:NSError?
        var results:[NSManagedObject]? = context.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]

        if(results!.count > 0){
            var managedObject = results![0]
            var dic:NSDictionary = object.toDictionary()
            
            for (key,value) in dic {
                managedObject.setValue(value, forKey: key as! String)
            }
            
            var saveError: NSError?
            context.save(&saveError)
            callback?(saveError,(saveError == nil) ? object : nil)
        }else{
            self.add(object, callback: callback)
        }
    }
    
    public func add(object: ObjectCoder, callback: ModelObjectCallback?) {
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        let newObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        var dictionary = object.toDictionary()
        
        for (key,val) in dictionary {
            var keyString = (key as! String)
            newObj.setValue(val,forKey:keyString)
        }
        
        var error: NSError?
        context.save(&error)
        callback?(error,(error == nil) ? object : nil)
        
    }
    
}

