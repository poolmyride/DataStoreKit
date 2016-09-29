//
//  Model-Protocol.swift
//   
//
//  Created by Rohit Talwar on 11/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
public typealias ModelArrayCallback = (NSError?,Any?)->Void
public typealias ModelObjectCallback = (NSError?,Any?)->Void

public protocol ModelProtocol:class {
    
    func query(params:[String:Any]?, options:[String:Any]?, callback: ModelArrayCallback? )
    func all(_ callback:ModelArrayCallback?)
    func get(id:CVarArg?,params:[String:Any]?, callback: ModelObjectCallback? )
    func put(id:CVarArg?,object:ObjectCoder, callback: ModelObjectCallback? )
    func add(_ object:ObjectCoder, callback: ModelObjectCallback? )
    func remove(id:CVarArg?,params:[String:Any]?, callback: ModelObjectCallback? )

}
