//
//  UserDefaultStore.swift
//   
//
//  Created by Rohit Talwar on 04/08/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation

open class UserDefaultStore<T>:ModelProtocol where T:ObjectCoder{
    
    let defaultKey = "DefaultKey"
    
    
    public init(){
        
    }
    open func get(id:CVarArg?,params:[String:Any]?, callback: ModelObjectCallback? ){
        let identifier = id as? String ?? defaultKey
        
        let obj: [String:Any]?  = UserDefaults.standard.object(forKey: identifier) as? [String:Any]
        
        obj != nil ? callback?(nil,T(dictionary: obj!)) : callback?(NSError(domain: "Not found", code: 0, userInfo: nil),nil)
    }
    
    open func put(id:CVarArg?,object:ObjectCoder, callback: ModelObjectCallback? ){
        let dic = object.toDictionary()
        UserDefaults.standard.set(dic, forKey: (id as? String ?? defaultKey))
        callback?(nil,object)

    }

    open func add(_ object: ObjectCoder, callback: ModelObjectCallback?) {
        
    }
    
    open func query(params:[String:Any]?, options:[String:Any]?, callback: ModelArrayCallback? ){
        //DO nothing
    }
    open func all(_ callback:ModelArrayCallback?){
        //DO nothing
    }
   
    open func remove(id: CVarArg?, params:[String:Any]?, callback: ModelObjectCallback?) {
        let identifier = id as? String ?? defaultKey
        
        let obj: [String:Any]?  = UserDefaults.standard.object(forKey: identifier) as? [String:Any]
        
        UserDefaults.standard.removeObject(forKey: identifier)
        let error:NSError? = obj == nil ? NSError(domain: "Not found", code: 0, userInfo: nil) : nil
        let result:T? = obj == nil ? nil : T(dictionary: obj!)
        callback?(error, result)
        
    }
    
}
