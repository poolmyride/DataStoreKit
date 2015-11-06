//
//  Restify.swift
//  ConfNGiOS
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
    
    private func _deserializeArray(objectArray : AnyObject?,callback: ModelArrayCallback? ){
        
        self.deserializer.deSerializeArrayAsync(objectArray as? NSArray, callback: callback)
   
    }
    
    private func _deserializeObject(object : AnyObject?,callback: ModelObjectCallback? ){
        
        self.deserializer.deSerializeObjectAsync(object as? NSDictionary, callback: callback)
     
    }
    
     public func query(params params:[String:AnyObject]? = nil, options:[String:AnyObject]? = nil, callback: ModelArrayCallback? ){
        let path  = base_url
        
        networkClient.GET(path, parameters: params) { (error, jsonObject) -> Void in
            
            (error == nil) ? self._deserializeArray(jsonObject as? NSArray, callback: callback) : callback?(error,nil)
        }
        
        
    }
    
    public func all(callback:ModelArrayCallback?){
        let path  = base_url + ALL_PATH
        
        networkClient.GET(path, parameters: nil) { (error, jsonObject) -> Void in
            (error == nil) ? self._deserializeArray(jsonObject, callback: callback) : callback?(error,nil)
        }
        
       
        
    }
    
    public func get(id id:String?,params:[String:AnyObject]?, callback: ModelObjectCallback? ){
    
        let path  = base_url + "/" + id!
        
        networkClient.GET(path, parameters: params) { (error, jsonObject) -> Void in
            
            (error == nil) ? self._deserializeObject(jsonObject, callback: callback) : callback?(error,nil)
        }
        

    }

    public func put(id id: String?, object: ObjectCoder, callback: ModelObjectCallback?) {
        let path  = base_url + "/" + id!
        let dic = NSMutableDictionary(dictionary: object.toDictionary())
        let access_token = NSUserDefaults.standardUserDefaults().objectForKey("app_access_token") as? String ?? ""
        dic["access_token"] = access_token.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        networkClient.PUT(path, parameters: dic) { (error, object) -> Void in
            
            callback?(error,object)
        }
    }
    
    public func add(object: ObjectCoder, callback: ModelObjectCallback?) {
        let path = base_url
        let dic = NSMutableDictionary(dictionary: object.toDictionary())
        let access_token = NSUserDefaults.standardUserDefaults().objectForKey("app_access_token") as? String ?? ""
        dic["access_token"] = access_token.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            networkClient.POST(path, parameters: dic) { (error, object) -> Void in
                
                callback?(error,object)
        }
    }
    
    public func remove(id id: String?, object: ObjectCoder?, callback: ModelObjectCallback?) {
        
        let path  = base_url + "/" + id!
        let dic:NSMutableDictionary? =  (object != nil) ? NSMutableDictionary(dictionary: object!.toDictionary()) : nil
        let access_token = NSUserDefaults.standardUserDefaults().objectForKey("app_access_token") as? String ?? ""
        dic?["access_token"] = access_token.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        networkClient.DELETE(path, parameters: dic) { (error, object) -> Void in
            
            callback?(error,object)
        }
        
    }
    
}

