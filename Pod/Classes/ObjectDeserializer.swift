//
//  ObjectDeserializer.swift
//  ConfNGiOS
//
//  Created by Rohit Talwar on 15/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation

public class ObjectDeserializer<T where T:ObjectCoder> {

    public init(){
        
    }
    public typealias DeserializeArrayCallback = (NSError?,NSArray?)->Void

    public typealias DeserializeObjectCallback = (NSError?,AnyObject?)->Void
    public func deSerializeArray(withItems:NSArray?)->NSArray{
        
        let items = (withItems != nil) ? (withItems!) : []
        
        let deserializedArray = NSMutableArray(capacity: items.count)
        
        for object in items {
            if object is NSDictionary{
                deserializedArray.addObject(self.deSerializeObject(object as? NSDictionary))
            }
            else if object is NSArray{
                deserializedArray.addObject(self.deSerializeArray(object as? NSArray))
            }
        }
        
        return (deserializedArray as NSArray)
        
    }
    
    public func deSerializeObject(object:NSDictionary?)->T{
    
        let dic = (object != nil) ? (object!) : []
        return T(dictionary: (dic as? NSDictionary) ?? [:])
    }
    
    
    public func deSerializeArrayAsync(withItems:NSArray?,callback: DeserializeArrayCallback?){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            let deserilizedArray = self.deSerializeArray(withItems);
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                callback?(nil,deserilizedArray)
                
            });
        });
        
    }
    
    public func deSerializeObjectAsync(object:NSDictionary?,callback:DeserializeObjectCallback?){
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            
            
            let deserializedObject = self.deSerializeObject(object)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                callback?(nil,deserializedObject)
                
                
            })
            
        });

    }
}