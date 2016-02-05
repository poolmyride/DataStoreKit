//
//  UserDefaultStore.swift
//  ConfNGiOS
//
//  Created by Rohit Talwar on 04/08/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation

public class UserDefaultStore<T where T:ObjectCoder>:ModelProtocol{
    
    let defaultKey = "DefaultKey"
    
    
    public init(){
        
    }
    public func get(id id:CVarArgType?,params:[String:AnyObject]?, callback: ModelObjectCallback? ){
        let identifier = id as? String ?? defaultKey
        
        let obj: NSDictionary?  = NSUserDefaults.standardUserDefaults().objectForKey(identifier) as? NSDictionary
        
        obj != nil ? callback?(nil,T(dictionary: obj!)) : callback?(NSError(domain: "Not found", code: 0, userInfo: nil),nil)
    }
    
    public func put(id id:CVarArgType?,object:ObjectCoder, callback: ModelObjectCallback? ){
        
        let dic = object.toDictionary()
        NSUserDefaults.standardUserDefaults().setObject(dic, forKey: (id as? String ?? defaultKey))
        callback?(nil,object)

    }
    public func add(object: ObjectCoder, callback: ModelObjectCallback?) {
        
    }
    
    public func query(params params:[String:AnyObject]?, options:[String:AnyObject]?, callback: ModelArrayCallback? ){
        //DO nothing
    }
    public func all(callback:ModelArrayCallback?){
        //DO nothing
    }
   
    public func remove(id id: CVarArgType?, params:[String:AnyObject]?, callback: ModelObjectCallback?) {
        let identifier = id as? String ?? defaultKey
        
        let obj: NSDictionary?  = NSUserDefaults.standardUserDefaults().objectForKey(identifier) as? NSDictionary
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(identifier)
        let error:NSError? = obj == nil ? NSError(domain: "Not found", code: 0, userInfo: nil) : nil
        let result:T? = obj == nil ? nil : T(dictionary: obj!)
        callback?(error, result)
        
    }
    
    
}
