//
//  Model-Protocol.swift
//  ConfNGiOS
//
//  Created by Rohit Talwar on 11/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
public typealias ModelArrayCallback = (NSError?,NSArray?)->Void
public typealias ModelObjectCallback = (NSError?,AnyObject?)->Void

public protocol ModelProtocol:class {
    
    func query(params params:[String:AnyObject]?, options:[String:AnyObject]?, callback: ModelArrayCallback? )
    func all(callback:ModelArrayCallback?)
    func get(id id:String?, callback: ModelObjectCallback? )
    func put(id id:String?,object:ObjectCoder, callback: ModelObjectCallback? )
    func add(object:ObjectCoder, callback: ModelObjectCallback? )

}