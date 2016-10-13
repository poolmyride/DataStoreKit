//
//  Restify.swift
//   
//
//  Created by Rohit Talwar on 15/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation


open class Restify<T>:ModelProtocol where T:ObjectCoder{
    
    let base_url:String;
    let ALL_PATH = "/all"
    var networkClient:NetworkInterface!

    
    public init(path:String,networkClient:NetworkInterface){
        base_url = path
        self.networkClient = networkClient

        
    }
    
    lazy var deserializer:ObjectDeserializer<T> = {
        var objD = ObjectDeserializer<T>()
        return objD
        
    }()
    
    fileprivate func _deserializeArray(_ objectArray : Any?,callback: ModelArrayCallback? ){
        self.deserializer.deSerializeArrayAsync(objectArray as? NSArray, callback: callback)
   
    }
    
    fileprivate func _deserializeObject(_ object : Any?,callback: ModelObjectCallback? ){
        
        self.deserializer.deSerializeObjectAsync(object as? [String:Any], callback: callback)
     
    }
    
     open func query(params:[String:Any]? = nil, options:[String:Any]? = nil, callback: ModelArrayCallback? ){
        let path  = base_url
        
        networkClient.GET(path, parameters: params) { (error, jsonObject) -> Void in
            
            (error == nil) ? self._deserializeArray(jsonObject as? NSArray, callback: callback) : callback?(error,jsonObject)
        }
        
        
    }
    
    open func all(_ callback:ModelArrayCallback?){
        let path  = base_url + ALL_PATH
        
        networkClient.GET(path, parameters: nil) { (error, jsonObject) -> Void in
            (error == nil) ? self._deserializeArray(jsonObject, callback: callback) : callback?(error,jsonObject)
        }
        
       
        
    }
    
    open func get(id:CVarArg?,params:[String:Any]?, callback: ModelObjectCallback? ){
    
        let resourceString = id != nil ? ("/" + (id as! String)) : ""
        let path  = base_url + resourceString
        
        networkClient.GET(path, parameters: params) { (error, jsonObject) -> Void in
            
            (error == nil) ? self._deserializeObject(jsonObject, callback: callback) : callback?(error,jsonObject)
        }
        

    }

    open func put(id: CVarArg?, object: ObjectCoder, callback: ModelObjectCallback?) {
        let resourceString = id != nil ? ("/" + (id as! String)) : ""
        let path  = base_url + resourceString
        let dic = object.toDictionary()
       
        networkClient.PUT(path, parameters: dic) { (error, object) -> Void in
            
            callback?(error,object)
        }
    }
    
    open func add(_ object: ObjectCoder, callback: ModelObjectCallback?) {
        let path = base_url
        let dic = object.toDictionary()
    
            networkClient.POST(path, parameters: dic) { (error, object) -> Void in
                
                callback?(error,object)
        }
    }
    
    open func remove(id: CVarArg?, params:[String:Any]?, callback: ModelObjectCallback?) {
        
        let resourceString = id != nil ? ("/" + (id as! String)) : ""
        let path  = base_url + resourceString
        let dic:[String:Any]? =  (params != nil) ? params : nil
        networkClient.DELETE(path, parameters: dic) { (error, object) -> Void in
            
            callback?(error,object)
        }
        
    }
    
}

