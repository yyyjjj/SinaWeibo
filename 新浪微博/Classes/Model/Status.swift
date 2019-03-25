//
//  Status.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class Status: NSObject {
    //名字
    @objc var id : Int = 0;
    //正文
    @objc var text : String?
    //创建时间
    @objc var created_at : String?
    //来源
    @objc var source : String?
    
    @objc var user : User?
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user"
        {
            if let dict = value as? [String:AnyObject]
            {
                user = User(dict:dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
  
//    func encode(with aCoder: NSCoder) {
////        let propertyList = getPropertyNameList()
////
////        print(propertyList)
////
////        propertyList.forEach { (p_name) in
////            //print("\(p_name) + \(String(describing: value(forKey: p_name)))")
////            aCoder.encode(value(forKey: p_name), forKey: p_name)
////        }
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init()
//
////        let propertyList = getPropertyNameList()
////
////        print(propertyList)
////
////        propertyList.forEach { (p_name) in
////            let value = aDecoder.decodeObject(forKey: p_name)
////            //print("\(p_name) + \(String(describing: value))")
////            setValue(value, forKey: p_name)
//        }
    
    
//    func getPropertyNameList() -> [String] {
//
//        var count : UInt32 = 0
//
//        var names : [String] = []
//
//        let properties = class_copyPropertyList(type(of: self), &count)
//
//        guard let propertyList = properties else {
//            return []
//        }
//
//        for i in 0..<count{
//            let property = propertyList[Int(i)]
//
//            let char_b = property_getName(property)
//
//            if let key = String.init(cString: char_b, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as String?{
//                names.append(key)
//            }
//        }
//        return names
//    }
//
}
