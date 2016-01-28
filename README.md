# DataStoreKit

[![CI Status](http://img.shields.io/travis/Rajat Talwar/DataStoreKit.svg?style=flat)](https://travis-ci.org/Rajat Talwar/DataStoreKit)
[![Version](https://img.shields.io/cocoapods/v/DataStoreKit.svg?style=flat)](http://cocoapods.org/pods/DataStoreKit)
[![License](https://img.shields.io/cocoapods/l/DataStoreKit.svg?style=flat)](http://cocoapods.org/pods/DataStoreKit)
[![Platform](https://img.shields.io/cocoapods/p/DataStoreKit.svg?style=flat)](http://cocoapods.org/pods/DataStoreKit)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Create your model class - Message.swift as shown in example below

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
    
    required init(dictionary withDictionary:NSDictionary){
        self.id = withDictionary["id"] as? String
        self.from = withDictionary["from"] as? String
        self.to = withDictionary["to"] as? String
        self.message = withDictionary["message"] as? String
        var created_ts_str = withDictionary["created_ts"] as? Double
        self.created_ts = created_ts_str
    }
    
    func toDictionary() -> NSDictionary {
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
# Create A Rest Model
```Swift

        let messsageUrl = "http://api.mysite.com/messages"
        let model = Restify<Message>(path: messsageUrl, networkClient: MyNetworkClient()) // see note below to know about MyNetworkClient


```
> **MyNetworkClient** is a class implementing **NetworkInterface** (implementing **GET,PUT,POST,DELETE**) so that you can use any networking library of your choice

# Create A CoreData Model
> Make sure you have an xcdatamodel file named MyApp.xcdatamodeld in your project and has an entity "Message" defined with fields according to your Message.swift class(read above)

```Swift

      static let coreDataStack = CoreDataStack(dbName: "MyApp")
      let model = CoreDataStore<Message>(entityName: "Message", managedContext: CoreDataFactory.coreDataStack.context)

```
### your xcdatamodel should look something like this
![logo](http://i.imgur.com/qNSIcTK.png?1)

## Concept

DataStoreKit works on two high level protocols 

#### ModelProtocol

ModelProtocol protocol is implemented by all the DataStores i.e. the CoreDataStore, Restify, UserDefaultStore etc.This provides a consistent api to access your data.

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

This  protocol enforces a consistent api to convert your Swift objects to and from NSDictionary representations.The NSDictionary representations are used for network transfer or storage on disk(CoreData)

```Swift

public protocol ObjectCoder:class{

    init(dictionary withDictionary:NSDictionary)
    func toDictionary() -> NSDictionary
    static func identifierKey() -> String
    
}
``` 

## Requirements
ios 8.0 and above

## Installation

DataStoreKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DataStoreKit"
```

## Author

Rajat Talwar, cuterajat26@gmail.com

## License

DataStoreKit is available under the MIT license. See the LICENSE file for more info.
