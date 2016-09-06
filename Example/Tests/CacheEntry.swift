//
//  CacheEntry.swift
//
//  Created by Rohit Talwar on 04/09/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import DataStoreKit

open class CacheEntry: ObjectCoder {
    
    var id:String?
    var data:Data?
    
    
    open static func identifierKey() -> String {
        return "id"
    }
    required public init(dictionary withDictionary:NSDictionary){
        self.id = withDictionary["id"] as? String
        self.data = withDictionary["data"] as? Data
    }
    open func toDictionary() -> [String:Any]{
        let dic:[String:Any] = [
            "data": self.data ?? Data(),
            "id": self.id ?? ""
        ];
        return dic;
    }
    
}
