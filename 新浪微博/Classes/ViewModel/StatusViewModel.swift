//
//  StatusViewModel.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class StatusViewModel {

    static var share = StatusViewModel()
    var StatusList : [Status]?
}
//MARK :-封装网络获取发布的动态
extension StatusViewModel{
    func LoadStatus(finished:@escaping (_ isSuccess : Bool) -> Void)
   {
    AFNetworkTool.sharedTool.LoadStatus { (result, error) in
        if error != nil{
            finished(false)
            assert(true, "加载错误")
        }
        //拿到status下的字典
        guard let result = result as? [String:AnyObject], let statuses = result["statuses"] as? [[String:AnyObject]] else
        {
            assert(true, "数据格式错误")
            return
        }
        
        var List = [Status]()
        
        statuses.forEach({
            List.append(Status.init(dict: $0))
        })
        
        self.StatusList = List
        finished(true)
    }
    }
}
