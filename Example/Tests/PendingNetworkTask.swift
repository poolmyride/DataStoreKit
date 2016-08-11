//
//  PendingNetworkTask.swift
//   
//
//  Created by Rohit Talwar on 29/01/16.
//  Copyright © 2016 Rajat Talwar. All rights reserved.
//

import Foundation
import DataStoreKit


class PendingNetworkTask:ObjectCoder {

    var body:NSDictionary?
    var method:String?
    var url:String?
    var created:TimeInterval?
    required init(dictionary withDictionary: NSDictionary) {
    
        self.body = withDictionary["body"] as? NSDictionary
        self.method = withDictionary["method"] as? String
        self.url = withDictionary["url"] as? String
        self.created = withDictionary["created"] as? Double
//        self.created_str = self.created != nil ? "\(self.created!)" : nil
        
    }
    
    func toDictionary() -> NSDictionary {
        
        let dic = NSMutableDictionary()
//        dic["method"]  = self.method ?? ""
//        dic["url"]  = self.url ?? ""
//        dic["created"]  = self.created ?? NSDate().timeIntervalSince1970
        
        self.body != nil ? dic["body"] = self.body! : ()
        self.method != nil ? dic["method"] = self.method! : ()
        self.url != nil ? dic["url"] = self.url! : ()
        self.created != nil ? dic["created"] = self.created! : ()
//        dic["created_str"] = self.created_str ?? ""
        return dic
    }
    
    static func identifierKey() -> String {
        return "created"
    }
}
