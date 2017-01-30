# DataStoreKit

[![CI Status](http://img.shields.io/travis/Rajat Talwar/DataStoreKit.svg?style=flat)](https://travis-ci.org/Rajat Talwar/DataStoreKit)
[![Version](https://img.shields.io/cocoapods/v/DataStoreKit.svg?style=flat)](http://cocoapods.org/pods/DataStoreKit)
[![License](https://img.shields.io/cocoapods/l/DataStoreKit.svg?style=flat)](http://cocoapods.org/pods/DataStoreKit)
[![Platform](https://img.shields.io/cocoapods/p/DataStoreKit.svg?style=flat)](http://cocoapods.org/pods/DataStoreKit)

This is a simple dependency to convert all the data obtained over network calls, be it on server or on local storage to Objects of Classes.

## Requirements
iOS 10.0 and above

## Installation

DataStoreKit is available through [CocoaPods](http://cocoapods.org). To install
it, specify it in your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'DataStoreKit'
end
```

Then, run the following command:

```ruby
$ pod install
```

## Concept And Architecture

DataStoreKit works on two high level protocols

#### ModelProtocol

This protocol enforces a Storage class to have all the basic functions to be implemented. Such as QUERY, GET, PUT, REMOVE, ADD (means POST), ALL

```Swift


public protocol ModelProtocol:class {
    
    func query(params params:[String:AnyObject]?, options:[String:AnyObject]?, callback: ModelArrayCallback? )
    func all(callback:ModelArrayCallback?)
    func get(id id:String?,params:[String:AnyObject]?, callback: ModelObjectCallback? )
    func put(id id:String?,object:ObjectCoder, callback: ModelObjectCallback? )
    func add(object:ObjectCoder, callback: ModelObjectCallback? )
    func remove(id id:String?,params:[String:AnyObject]?, callback: ModelObjectCallback? )

}
``` 

```Swift
public typealias ModelArrayCallback = (NSError?,NSArray?)->Void
public typealias ModelObjectCallback = (NSError?,AnyObject?)->Void
```

#### ObjectCoder

This  protocol enforces a consistent api to convert your Swift objects to and from [String:Any] representations.The [String:Any] representations are used for network transfer or storage on disk(CoreData)

```Swift

public protocol ObjectCoder:class{

    init(dictionary withDictionary:[String:Any])
    func toDictionary() -> [String:Any]
    static func identifierKey() -> String
    
}
``` 

DataStoreKit helps with two types of Network calls

#### Server API Calls 

To make server calls, first you require a Class implementing ObjectCorder protocol. For example look at the following Message Class

```Swift
import Foundation
import DataStoreKit
class Message:ObjectCoder {
    var id:String?
    var from_user_key:String?
    var to_user_key:String?
    var message:String?
    var created_ts:Double? //created timestamp in Double
    
    static func identifierKey() -> String {
        return "id"
    }
    
    required init(dictionary withDictionary:[String:Any]){
        self.id = withDictionary["id"] as? String
        self.from = withDictionary["from"] as? String
        self.to = withDictionary["to"] as? String
        self.message = withDictionary["message"] as? String
        var created_ts_str = withDictionary["created_ts"] as? Double
        self.created_ts = created_ts_str
    }
    
    func toDictionary() -> [String:Any] {
        var dic = [
            "id" : self.id ?? "",
            "from" : self.from ?? "",
            "to" : self.to ?? "" ,
            "message": self.message ?? "" ,
            "created_ts" : self.created_ts ?? NSDate().timeIntervalSince1970
        ]
        return dic
    }
}
```

Now you need is a Restify Model that can perform network calls on Message class. You can implement this in a Factory class so that you can easily make network calls on Message from anywhere in your project easily. 

```Swift
        class ModelFactory {

       	class func message() -> Restify<Message> {
        	let messsageUrl = "http://api.mysite.com/messages"
        	let model = Restify<Message>(path: messsageUrl, networkClient: MyNetworkClient()) // 	see note below to know about MyNetworkClient
        	}
}
```
> **MyNetworkClient** is a class implementing **ModelProtocol** (implementing **GET,PUT,POST,DELETE**) so that you can use any networking library of your choice

Now, you are ready to make calls to your server and fetch data. You can now perform following requests to your server:- 

```Swift
	   let paramsDic: [String:Any]? = [“from”: “1234567890”, “to”:”0987654321”]
	   ModelFactory.messages().query(params: paramsDic, options: nil, callback: { (error:NSError?, results:Any?) in
         // Do with results     
       })
```


The result of above network call will be array of objects of Message class that contains messages with **from as 1234567890** and **to as 0987654321**

Above code is for QUERYING Data between two users. Similarly you can use GET, PUT, ADD, REMOVE. 

#### Local Storage Calls 

With DataStoreKit, you can store the Message class objects in local storage and you can make all REST calls on local storage also.

> Make sure you have an xcdatamodel file named MyApp.xcdatamodeld in your project and has an entity "Message" defined with fields according to your Message.swift class(read above)

### Your xcdatamodel should look something like this
![logo](http://i.imgur.com/qNSIcTK.png?1)

Now, As we made ModelFactory for Network calls, we can also create a Factory for calls on local storage.

```Swift

import Foundation
import DataStoreKit

class CoreDataFactory:NSObject {
    
    class func model<T:ObjectCoder>(withName name:String,_: T.Type) -> ModelProtocol{
        do {
            let context = try CoreDataFactory.coreDataStack.context()
            return CoreDataStore<T>(entityName: name, managedContext: context)
            
        } catch let error as NSError {
            let memoryContext = try! CoreDataFactory.inMemoryDataStack.context()
            return CoreDataStore<T>(entityName: name, managedContext: memoryContext)
        }
    }

    class func message() -> ModelProtocol {
        return CoreDataFactory.model(withName: "MessageNew",MessageNew.self)
    }
   
}
```

Now, you are ready to make calls to your local storage and fetch data. You can now perform following requests to your local storage:- 

```Swift
	   let paramsDic: [String:Any]? = [“from”: “1234567890”, “to”:”0987654321”]
	   CoreDataFactory.message().query(params: paramsDic, options: [:], callback: { (error:NSError?, results:Any?) in	
            // Do with results 
       })
```

## Author

Rajat Talwar, cuterajat26@gmail.com

## License

DataStoreKit is available under the MIT license. See the LICENSE file for more info.