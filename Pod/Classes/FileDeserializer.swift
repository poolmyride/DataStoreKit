//
//  FileDeserializer.swift
//   
//
//  Created by Rohit Talwar on 11/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//



import Foundation

public class FileDeserializer<T where T:AnyObject,T:ObjectCoder> {
    
    
    private func isPList(_ fileName:String) -> Bool{
        return fileName.hasSuffix("plist")
    }
    
    private func getJsonArray(_ fileName:String) -> NSArray? {
        
        let url = Bundle.main.url(forResource: fileName, withExtension: "");

        var jsonarray:NSArray? = nil
        do {
            try jsonarray = JSONSerialization.jsonObject(with: Data(contentsOf: url!), options: []) as? NSArray
        } catch _ as NSError {
            
        }
        return jsonarray
    }
    
    private func getPlistArray(_ fileName:String) -> NSArray? {
        
        let url = Bundle.main.url(forResource: fileName, withExtension: "");
        
        let array:NSArray? = (url != nil) ? NSArray(contentsOf: url!)  : nil

        return array
    }
    
    public  func getObjectArrayFrom(fielName fileName:String,callback: (NSError?,NSArray?)->Void) {

        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async(execute: { () -> Void in
            
            let array = (self.isPList(fileName) ? self.getPlistArray(fileName) : self.getJsonArray(fileName)) ?? []
            let objectDeserializer = ObjectDeserializer<T>();
            let results:NSArray =  objectDeserializer.deSerializeArray(array)
            
            DispatchQueue.main.async(execute: { () -> Void in
                callback(nil,results)
                
            });
            
        });
    }
    
}
