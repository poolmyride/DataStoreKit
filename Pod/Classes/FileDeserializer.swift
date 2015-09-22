//
//  FileDeserializer.swift
//  ConfNGiOS
//
//  Created by Rohit Talwar on 11/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//



import Foundation

public class FileDeserializer<T where T:AnyObject,T:ObjectCoder> {
    
    
    public  func getObjectArrayFrom(fielName fileName:String,callback: (NSError?,NSArray?)->Void) {

        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            
            let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: "");
            
            let array:NSArray? = (url != nil) ? NSArray(contentsOfURL: url!)  : []
            
            let objectDeserializer = ObjectDeserializer<T>();
            let results:NSArray =  objectDeserializer.deSerializeArray(array!)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                callback(nil,results)
                
            });
            
        });
    }
    
}
