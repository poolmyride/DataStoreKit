//
//  Animal.swift
//   
//
//  Created by Rohit Talwar on 28/07/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import CoreData
import DataStoreKit

class Animal: ObjectCoder {
    
    var created:Double?
    var name:String?
   
    
    static func identifierKey() -> String {
        return "created"
    }
    
    
    required init(dictionary withDictionary:[String:Any]){
        self.name = withDictionary["name"] as? String
        self.created = withDictionary["created"] as? Double

    }
    
    func toDictionary() -> [String:Any] {
        var dic = [String:Any]()
        self.name != nil ? dic["name"] = self.name! : ()
        self.created != nil ? dic["created"] = self.created! : ()
        return dic
    }
    
    
}


