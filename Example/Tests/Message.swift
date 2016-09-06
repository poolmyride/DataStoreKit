//
//  Message.swift
//   
//
//  Created by Rohit Talwar on 28/07/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import CoreData
import DataStoreKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Message:ObjectCoder {

    var id:String?
    var from_attendee:String?
    var to_attendee:String?
    var message:String?
    var type:String?
    var created_ts:Double?
    var date:Date?
    static let globalStorageId = "GMessageId"

    static func identifierKey() -> String {
        return "id"
    }
    

     required init(dictionary withDictionary:NSDictionary){
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-ddHH:mm:ss"
        self.id = withDictionary["id"] as? String
        self.from_attendee = withDictionary["from_attendee"] as? String
        self.to_attendee = withDictionary["to_attendee"] as? String
        self.message = withDictionary["message"] as? String
        let created_ts_str = withDictionary["created_ts"] as? Double
        self.created_ts = created_ts_str
        self.type = (withDictionary["type"] as? String) ?? "chat"
        let timeStamp = (created_ts_str) ?? Date().timeIntervalSince1970
        self.date = Date(timeIntervalSince1970: timeStamp )
        
        
    }
    
    func toDictionary() -> [String:Any] {
        let dic:[String:Any] = [
            "id" : (self.id ?? "") as String,
            "from_attendee" : (self.from_attendee ?? "") as String,
            "to_attendee" : (self.to_attendee ?? "") as String,
            "type": (self.type ?? "") as String,
            "message": (self.message ?? "") as String,
            "created_ts" : self.created_ts ?? Date().timeIntervalSince1970
        ]
        
        return dic
    }
    
    
   

    
    
}

func <=(lhs:Message , rhs:Message) -> Bool {
    return lhs.created_ts <= rhs.created_ts
}

func >=(lhs:Message, rhs:Message) -> Bool {
    return lhs.created_ts >= rhs.created_ts

}

func >(lhs:Message, rhs:Message) -> Bool {
    return lhs.created_ts > rhs.created_ts
}

