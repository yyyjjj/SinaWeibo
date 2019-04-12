//
//  EmoticonsViewModel.swift
//  表情键盘
//
//  Created by 梁华建 on 2019/4/7.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class EmoticonsViewModel {
    ///单例
    static var shared = EmoticonsViewModel()
    
    ///包的名称
    var id : String?
    
    ///包的模型
    lazy var packages = [EmoticonPackage]()
    
    private init()
    {
        //0,添加最近分组
        packages.append(EmoticonPackage(dict:["group_name_cn":"最近" as AnyObject]))
        //1,加载emoticons.plist
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        //2,把plist转成字典
        let dict = NSDictionary.init(contentsOfFile: path) as! [String:AnyObject]
        //3,拿到packages下的key的数组
        let array = (dict["packages"] as! NSArray).value(forKey: "id")
        //4,加载每个包的content.plist
        (array as! [String]).forEach(){loadinfoplist(name: $0)}
        //print(packages)
    }
    
    func loadinfoplist(name:String)
    {
        //1,加载content.plist
        let path = Bundle.main.path(forResource: "content.plist", ofType: nil, inDirectory: "Emoticons.bundle/\(name)")!
        //2,plist转字典
        let dict = NSDictionary.init(contentsOfFile: path) as! [String:AnyObject]
        //3,拼接package模型
        packages.append(EmoticonPackage.init(dict: dict))
    }
}
