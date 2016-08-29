//
//  CoreDataStore.swift
//   
//
//  Created by Rohit Talwar on 15/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import CoreData


open class CoreDataStore<T>:ModelProtocol where T:ObjectCoder{
    
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
    
    fileprivate func _deserializeArray(_ objectArray : Any?,callback: ModelArrayCallback? ){
        
        var resultArray:[T] = [T]()
        let manageObjectArray = objectArray as! Array<NSManagedObject>
        
        for manageObject in manageObjectArray{
            let attrByNames = manageObject.entity.attributesByName
            
            let newObjDic = NSMutableDictionary()
            for (key,_) in attrByNames{
                let value = manageObject.value(forKey: key)
                value != nil ? newObjDic[key] = value : ()
            }
            resultArray.append(T(dictionary: newObjDic))
        }
        
        callback?(nil,resultArray as Any?)
        
    }
    
    fileprivate func _deserializeObject(_ object : Any?,callback: ModelObjectCallback? ){
        
       let manageObject = object as! NSManagedObject
        let attrByNames = manageObject.entity.attributesByName

        let newObjDic = NSMutableDictionary()
        for (key,_) in attrByNames{
            let value = manageObject.value(forKey: key)
            value != nil ? newObjDic[key] = value : ()
        }
        callback?(nil,T(dictionary: newObjDic))
        
    }
    
    open func query(params:[String:Any]? = [:], options:[String:Any]? = [:], callback: ModelArrayCallback? ){
        

        let fetchRequest = QueryEngine.fetchRequestFromQuery(params, options: options)

        let description = NSEntityDescription.entity(forEntityName: entityName, in: self.context)
        fetchRequest.entity = description
        
        var error:NSError?
        var results: [Any]?
        do {
            results = try context.fetch(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            results = nil
        }

        error == nil ? self._deserializeArray(results as! [NSManagedObject] as Any?, callback: callback) : callback?(error,nil)

    }
    
    open func all(_ callback:ModelArrayCallback?){

    }
    
    open func get(id:CVarArg?,params:[String:Any]?, callback: ModelObjectCallback? ){
        let key = T.identifierKey()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let description = NSEntityDescription.entity(forEntityName: entityName, in: self.context)
        fetchRequest.entity = description
        fetchRequest.predicate = NSPredicate(format: "%K == %@", key ,id!)
        
        var error:NSError?
        var results: [Any]?
        do {
            results = try context.fetch(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            results = nil
        }
        results = results as? [NSManagedObject]
        
        if(results!.count > 0){
            error == nil ? self._deserializeObject(results![0], callback: callback) : callback?(error,nil)
        }else{
            callback?(NSError(domain: "Not Found", code: 0, userInfo: nil),nil)
  
        }
        
    }
    
    open func put(id: CVarArg?, object: ObjectCoder, callback: ModelObjectCallback?) {
        

        let key = T.identifierKey()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let description = NSEntityDescription.entity(forEntityName: entityName, in: self.context)
        fetchRequest.entity = description
        
        fetchRequest.predicate = NSPredicate(format: "%K == %@", key ,id!)
        
        var results: [AnyObject]?
        do {
            results = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
            results = nil
        }
        
        results = results as? [NSManagedObject]


        if(results!.count > 0){
            let managedObject = results![0]
            let dic:[String:Any] = object.toDictionary() as! [String : Any]

            for (key,value) in dic {
                managedObject.setValue(value, forKey: key)
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
    
    open func add(_ object: ObjectCoder, callback: ModelObjectCallback?) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let newObj = NSManagedObject(entity: entity!, insertInto: context)
        
        let dictionary = object.toDictionary()
         //newObj.setValue(dictionary["created"]!, forKey:"created")
        newObj.setPrimitiveValue(dictionary["created"]!, forKey: "created")
        //for (key,val) in dictionary {
          //  let keyString = (key)
            //newObj.setValue(val, forKey:keyString as! String)
        //}
        
        var error: NSError?
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
        }
        callback?(error,(error == nil) ? object : nil)
        
    }
    
    open func remove(id: CVarArg?, params:[String:Any]?, callback: ModelObjectCallback?) {
        
        let key = T.identifierKey()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let description = NSEntityDescription.entity(forEntityName: entityName, in: self.context)
        fetchRequest.entity = description
        
        fetchRequest.predicate = NSPredicate(format: "%K == %@", key ,id!)
        
        var results: [Any]?
        do {
            results = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
            results = nil
        }
        
        results = results as? [NSManagedObject] ?? []
        

        if(results!.count > 0){
           
        let managedObject = results![0]

           context.delete(managedObject as! NSManagedObject)

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

