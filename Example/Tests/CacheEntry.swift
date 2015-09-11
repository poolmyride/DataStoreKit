//
//  CacheEntry.swift
//
//  Created by Rohit Talwar on 04/09/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import DataStoreKit

public class CacheEntry: ObjectCoder {
    
    var id:String?
    var data:NSData?
    
    
    public static func identifierKey() -> String {
        return "id"
    }
    required public init(dictionary withDictionary:NSDictionary){
        self.id = withDictionary["id"] as? String
        self.data = withDictionary["data"] as? NSData
    }
    public func toDictionary() -> NSDictionary{
        var dic:NSDictionary = [
            "data": self.data ?? NSData(),
            "id": self.id ?? ""
        ];
        return dic;
    }
    
}
