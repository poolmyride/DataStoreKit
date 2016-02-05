//
//  Conference.swift
//  ConfNGiOS
//
//  Created by Rohit Talwar on 09/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//


public class FileModel<T where T:ObjectCoder,T:AnyObject>: ModelProtocol {
    
    let fileName:String?
    
  
    public init(path:String){
        self.fileName = path
    }
    
    
    public func all(callback:ModelArrayCallback?){
        self.query(callback: callback)
    }
    
    
    public  func query(params params:[String:AnyObject]? = nil, options:[String:AnyObject]? = nil, callback: ModelArrayCallback? ){
        
        let fd = FileDeserializer<T>()
        fd.getObjectArrayFrom(fielName: self.fileName!) { (error, conferences) -> Void in
            callback?(nil,conferences)
        }
        
        
    }
    
    public func get(id id:CVarArgType?,params:[String:AnyObject]?, callback: ModelObjectCallback? ){
    
        callback?(nil,nil)
    }
    
    public func put(id id: CVarArgType?, object: ObjectCoder, callback: ModelObjectCallback?) {
        
    }
    
    public func add(object: ObjectCoder, callback: ModelObjectCallback?) {
        
    }
    
    public func remove(id id: CVarArgType?, params:[String:AnyObject]?, callback: ModelObjectCallback?) {
        
    }

}
