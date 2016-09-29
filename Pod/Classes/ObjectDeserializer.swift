//
//  ObjectDeserializer.swift
//   
//
//  Created by Rohit Talwar on 15/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation

open class ObjectDeserializer<T> where T:ObjectCoder {

    public init(){
        
    }
    public typealias DeserializeArrayCallback = (NSError?,NSArray?)->Void

    public typealias DeserializeObjectCallback = (NSError?,Any?)->Void
    open func deSerializeArray(_ withItems:NSArray?)->NSArray{
        
        let items = (withItems != nil) ? (withItems!) : []
        
        let deserializedArray = NSMutableArray(capacity: items.count)
        
        for object in items {
            if object is NSDictionary{
                deserializedArray.add(self.deSerializeObject(object as? NSDictionary))
            }
            else if object is NSArray{
                deserializedArray.add(self.deSerializeArray(object as? NSArray))
            }
        }
        
        return (deserializedArray as NSArray)
        
    }
    
    open func deSerializeObject(_ object:NSDictionary?)->T{
    
        let dic = (object != nil) ? (object!) : [:]
        return T(dictionary: dic)
    }
    
    open func deSerializeArrayAsync(_ withItems:NSArray?,callback: DeserializeArrayCallback?){
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async(execute: { () -> Void in
            let deserilizedArray = self.deSerializeArray(withItems);
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                callback?(nil,deserilizedArray)
                
            });
        });
        
    }
    
    open func deSerializeObjectAsync(_ object:NSDictionary?,callback:DeserializeObjectCallback?){
    
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async(execute: { () -> Void in
            
            
            let deserializedObject = self.deSerializeObject(object)
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                callback?(nil,deserializedObject)
                
                
            })
            
        });

    }
}
