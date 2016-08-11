//
//  Conference.swift
//   
//
//  Created by Rohit Talwar on 09/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//


public class FileModel<T where T:ObjectCoder,T:AnyObject>: ModelProtocol {
    
    let fileName:String?
    
  
    public init(path:String){
        self.fileName = path
    }
    
    
    public func all(_ callback:ModelArrayCallback?){
        self.query(callback: callback)
    }
    
    
    public  func query(params:[String:AnyObject]? = nil, options:[String:AnyObject]? = nil, callback: ModelArrayCallback? ){
        
        let fd = FileDeserializer<T>()
        fd.getObjectArrayFrom(fielName: self.fileName!) { (error, conferences) -> Void in
            callback?(nil,conferences)
        }
        
        
    }
    
    public func get(id:CVarArg?,params:[String:AnyObject]?, callback: ModelObjectCallback? ){
    
        callback?(nil,nil)
    }
    
    public func put(id: CVarArg?, object: ObjectCoder, callback: ModelObjectCallback?) {
        
    }
    
    public func add(_ object: ObjectCoder, callback: ModelObjectCallback?) {
        
    }
    
    public func remove(id: CVarArg?, params:[String:AnyObject]?, callback: ModelObjectCallback?) {
        
    }

}
