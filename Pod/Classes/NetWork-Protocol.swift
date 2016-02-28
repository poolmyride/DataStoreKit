//
//  NetWork-Protocol.swift
//   
//
//  Created by Rohit Talwar on 19/06/15.
//  Copyright (c) 2015 Rajat Talwar. All rights reserved.
//

import Foundation

public protocol NetworkInterface{
    
    func setHTTPHeaders(headers:[String:String])
    func GET(URLString: String!, parameters: AnyObject!, callback: ((NSError?, AnyObject?) -> Void)!)
    func POST(URLString: String!, parameters: AnyObject!,callback: ((NSError?, AnyObject?) -> Void)!)
    func PUT(URLString: String!, parameters: AnyObject!,callback: ((NSError?, AnyObject?) -> Void)!)
    
    func DELETE(URLString: String!, parameters: AnyObject?,callback: ((NSError?, AnyObject?) -> Void)!)

}