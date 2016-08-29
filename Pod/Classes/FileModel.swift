//
//  Conference.swift
//   
//
//  Created by Rohit Talwar on 09/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//


open class FileModel<T>: ModelProtocol where T:ObjectCoder,T:AnyObject {
    
    let fileName:String?
    
  
    public init(path:String){
        self.fileName = path
    }
    
    
    open func all(_ callback:ModelArrayCallback?){
        self.query(callback: callback)
    }
    
    
    open  func query(params:[String:Any]? = nil, options:[String:Any]? = nil, callback: ModelArrayCallback? ){
        
        let fd = FileDeserializer<T>()
        fd.getObjectArrayFrom(fielName: self.fileName!) { (error, conferences) -> Void in
            callback?(nil,conferences)
        }
        
        
    }
    
    open func get(id:CVarArg?,params:[String:Any]?, callback: ModelObjectCallback? ){
    
        callback?(nil,nil)
    }
    
    open func put(id: CVarArg?, object: ObjectCoder, callback: ModelObjectCallback?) {
        
    }
    
    open func add(_ object: ObjectCoder, callback: ModelObjectCallback?) {
        
    }
    
    open func remove(id: CVarArg?, params:[String:Any]?, callback: ModelObjectCallback?) {
        
    }

}
