//
//  NetWork-Protocol.swift
//   
//
//  Created by Rohit Talwar on 19/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation

public protocol NetworkInterface{
    
    func setHTTPHeaders(_ headers:[String:String])
    func GET(_ URLString: String!, parameters: Any!, callback: ((NSError?, Any?) -> Void)!)
    func POST(_ URLString: String!, parameters: Any!,callback: ((NSError?, Any?) -> Void)!)
    func PUT(_ URLString: String!, parameters: Any!,callback: ((NSError?, Any?) -> Void)!)
    
    func DELETE(_ URLString: String!, parameters: Any?,callback: ((NSError?, Any?) -> Void)!)

}
