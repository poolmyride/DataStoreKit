//
//  Restify.swift
//   
//
//  Created by Rohit Talwar on 15/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation


public class Restify<T where T:ObjectCoder>:ModelProtocol{
    
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
    
    private func _deserializeArray(_ objectArray : AnyObject?,callback: ModelArrayCallback? ){
        
        self.deserializer.deSerializeArrayAsync(objectArray as? NSArray, callback: callback)
   
    }
    
    private func _deserializeObject(_ object : AnyObject?,callback: ModelObjectCallback? ){
        
        self.deserializer.deSerializeObjectAsync(object as? NSDictionary, callback: callback)
     
    }
    
     public func query(params:[String:AnyObject]? = nil, options:[String:AnyObject]? = nil, callback: ModelArrayCallback? ){
        let path  = base_url
        
        networkClient.GET(urlString: path, parameters: params) { (error, jsonObject) -> Void in
            
            (error == nil) ? self._deserializeArray(jsonObject as? NSArray, callback: callback) : callback?(error,jsonObject)
        }
        
        
    }
    
    public func all(_ callback:ModelArrayCallback?){
        let path  = base_url + ALL_PATH
        
        networkClient.GET(urlString: path, parameters: nil) { (error, jsonObject) -> Void in
            (error == nil) ? self._deserializeArray(jsonObject, callback: callback) : callback?(error,jsonObject)
        }
        
       
        
    }
    
    public func get(id:CVarArg?,params:[String:AnyObject]?, callback: ModelObjectCallback? ){
    
        let resourceString = id != nil ? ("/" + (id as! String)) : ""
        let path  = base_url + resourceString
        
        networkClient.GET(urlString: path, parameters: params) { (error, jsonObject) -> Void in
            
            (error == nil) ? self._deserializeObject(jsonObject, callback: callback) : callback?(error,jsonObject)
        }
        

    }

    public func put(id: CVarArg?, object: ObjectCoder, callback: ModelObjectCallback?) {
        let resourceString = id != nil ? ("/" + (id as! String)) : ""
        let path  = base_url + resourceString
        let dic = object.toDictionary()
       
        networkClient.PUT(urlString: path, parameters: dic) { (error, object) -> Void in
            
            callback?(error,object)
        }
    }
    
    public func add(_ object: ObjectCoder, callback: ModelObjectCallback?) {
        let path = base_url
        let dic = object.toDictionary()
    
            networkClient.POST(urlString: path, parameters: dic) { (error, object) -> Void in
                
                callback?(error,object)
        }
    }
    
    public func remove(id: CVarArg?, params:[String:AnyObject]?, callback: ModelObjectCallback?) {
        
        let resourceString = id != nil ? ("/" + (id as! String)) : ""
        let path  = base_url + resourceString
        let dic:NSMutableDictionary? =  (params != nil) ? NSMutableDictionary(dictionary: params! ) : nil
        networkClient.DELETE(urlString: path, parameters: dic) { (error, object) -> Void in
            
            callback?(error,object)
        }
        
    }
    
}

