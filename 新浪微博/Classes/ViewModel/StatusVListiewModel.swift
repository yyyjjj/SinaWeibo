//
//  StatusViewModel.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SDWebImage
class StatusListViewModel
{
    ///StatusViewModel的数组
    var StatusList = [StatusViewModel]()
}
//MARK :-封装网络获取发布的动态
extension StatusListViewModel{
    func LoadStatus(finished:@escaping (_ isSuccess : Bool) -> Void)
    {
        AFNetworkTool.sharedTool.LoadStatus { (result, error) in
            if error != nil
            {
                finished(false)
                assert(true, "加载错误")
            }
            //1,拿到statuses键下的字典
            guard let result = result as? [String:AnyObject], let statuses = result["statuses"] as? [[String:AnyObject]] else
            {
                assert(true, "数据格式错误")
                return
            }
            
            var List = [StatusViewModel]()
            //2,拼接每一个status的图片URL
            statuses.forEach({
                List.append(StatusViewModel.init(status: Status.init(dict: $0) ))
            })
            //3,赋值StatusList
            self.StatusList = List + self.StatusList
            //4,我们要保证finish闭包要在缓存完单图后
            self.cacheSinglePic(StatusList: List,finished: finished)
        }
    }
}

//MARK: -单图缓存
extension StatusListViewModel{
    
    /// 单图缓存
    /// 目的：把单图提前缓存起来，得到其单图的比例
    /// - Parameter StatusList: 用户微博模型列表
    func cacheSinglePic(StatusList : [StatusViewModel],finished:@escaping (_ isSuccess : Bool) -> Void){
        
        //计算总单图的长度
        var dataLength = 0
        //建立单图缓存组，使用组保证了图片一次性缓存（同步任务的完成），缓存结束后再去进行布局
        let group = DispatchGroup.init()
        //print("开始缓存")
        StatusList.forEach {
        //拿到单张图片的微博，否则继续往下寻找
        if $0.thumbnails?.count == 1 {
        //进组
        group.enter()
//        print("开始缓存单图 : \($0.thumbnails![0].absoluteString)")
        //缓存
        SDWebImageManager.shared().loadImage(with: $0.thumbnails![0],
        options: [SDWebImageOptions.refreshCached,SDWebImageOptions.retryFailed],
        progress:nil,
        completed: { (image, _, _, _, _, _) in
            if let image = image ,
                let data = UIImage.pngData(image)(){
                dataLength += data.count
            }
            //出组
            group.leave()
                })
            }
        }
        group.notify(queue: DispatchQueue.main) {
            print("缓存完成")
            //print("数据长度\(dataLength/1024)")
            print("缓存图像的地址:\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!)")
            
            finished(true)
        }
    }
}
