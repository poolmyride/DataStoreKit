//
//  QueryEngine.swift
//   
//
//  Created by Rohit Talwar on 11/08/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation
import CoreData
class QueryEngine {
    
    static func fetchRequestFromQuery(_ params:[String:Any]? = [:], options:[String:Any]? = [:]) ->NSFetchRequest<NSFetchRequestResult>{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        var predicates = [NSPredicate]()
        for (key,val) in params! {
            
            let range = key.rangeOfCharacter(from: CharacterSet(charactersIn: "<>="))
            
            if (range == nil ){
                var predicate:NSPredicate? = nil
                if(val is String){
                    predicate =  NSPredicate(format: "%K == %@",key, (val as? String) ?? "")
                }
                if(val is NSNumber ){
                    predicate =  NSPredicate(format: "%K == %@",key, val as! NSNumber)
                }
                
                
                predicates.append(predicate!)
            }else {
                
                let queryOperator = key.substring(from: range!.lowerBound)
                let keyName = key.substring(to: range!.lowerBound).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if (val is String){
                    let queryFormat = "%K \(queryOperator) %@"
                    predicates.append(NSPredicate(format: queryFormat,keyName, val as! String))
                    
                    
                }else if (val is NSNumber){
                    let queryFormat = "%K \(queryOperator) %f"
                    predicates.append(NSPredicate(format: queryFormat,keyName, (val as! NSNumber).doubleValue))
                    
                }
            }
            
        }
        
        if let limit: Any = options!["limit"] {
            fetchRequest.fetchLimit = (limit as? Int) ?? 50
        }
        
        /*sort:{
         "key1":{
         "ascending":true
         },
         "key2":{
         "ascending":false
         }
         }
         */
        if let sort: Any = options!["sort"] {
            
            let sortDic = sort as! [String:Any]
            var sortDescriptors  = [NSSortDescriptor]()
            for (key,val) in sortDic {
                let isAscending = (((val as? [String:Any]) ?? [String:Any]())["ascending"] as? Bool) == true
                let sortDescriptor = NSSortDescriptor(key: key as? String, ascending: isAscending)
                sortDescriptors.append(sortDescriptor)
            }
            
            fetchRequest.sortDescriptors = sortDescriptors
            
        }
        
        
        let compound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        fetchRequest.predicate = compound
        return fetchRequest
        
    }
}
