//
//  ObjectCoder-Protocol.swift
//   
//
//  Created by Rohit Talwar on 15/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation


public protocol ObjectCoder:class{

    init(dictionary withDictionary:NSDictionary)
    func toDictionary() -> [AnyHashable:Any]
    
    
     static func identifierKey() -> String
    
}
