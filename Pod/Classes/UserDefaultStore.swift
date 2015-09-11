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
    public func get(#id:String?, callback: ModelObjectCallback? ){
        var identifier = id ?? defaultKey
        
        var obj: NSDictionary?  = NSUserDefaults.standardUserDefaults().objectForKey(identifier) as? NSDictionary
        
        obj != nil ? callback?(nil,T(dictionary: obj!)) : callback?(NSError(domain: "Not found", code: 0, userInfo: nil),nil)
    }
    
    public func put(#id:String?,object:ObjectCoder, callback: ModelObjectCallback? ){
        
        var dic = object.toDictionary()
        NSUserDefaults.standardUserDefaults().setObject(dic, forKey: (id ?? defaultKey))
        callback?(nil,object)

    }
    public func add(object: ObjectCoder, callback: ModelObjectCallback?) {
        
    }
    
    public func query(#params:[String:AnyObject]?, options:[String:AnyObject]?, callback: ModelArrayCallback? ){
        //DO nothing
    }
    public func all(callback:ModelArrayCallback?){
        //DO nothing
    }
    
    
}
