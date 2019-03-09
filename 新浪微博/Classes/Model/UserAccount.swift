//
//  UserInfo.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/7.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
//用户初模型
class UserAccount: NSObject {
    var access_token: String?
    var expires_in : TimeInterval = 0
    var uid : String?
    //kvc字典快速初始化
    init(dict : [String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    func descriptAnswer(){
        let keys = ["access_token","expires_in","uid"]
        print(dictionaryWithValues(forKeys: keys).description)
    }
    ///防止找不到key，KVC出现崩溃
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    
    }
}
