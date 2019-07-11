//
//  user.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

/// - [查看接口返回key详情](https://open.weibo.com/wiki/2/users/show)
class User: NSObject {
    ///用户UID
    @objc var id : Int = 0
    ///用户昵称
    @objc var screen_name : String?
    ///用户头像地址
    @objc var profile_image_url : String?
    ///认证类型 -1：没有认证 0：认证用户 2，3，4：企业用户 220：达人
    @objc var verified_type : Int = 0
    ///会员等级 0-6
    @objc var mbrank : Int = 0
    
    @objc var description_c : String?
    
    @objc var followers_count : Int = 0
    
    @objc var friends_count : Int = 0
    
    @objc var status : Status?
    convenience init(dict:[String:AnyObject]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "status"
        {
            if let dict = value as? [String : AnyObject]
            {
            status = Status.init(dict: dict)
            }
            return 
        }
        if key == "description"
        {
            if let str = value as? String
            {
                description_c = str
            }
            return
        }
    super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
