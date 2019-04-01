//
//  StatusViewModel.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    var status : Status
    ///用户头像URL
    var profileURL : URL {
        return URL(string: status.user?.profile_image_url! ?? "")!
    }
    ///用户默认头像
    var defaultProfile : UIImage {
        return UIImage.init(named: "avatar_default")!
    }
    ///用户会员图标
    var memberImage : UIImage?{
        let mbrank = status.user!.mbrank
        if mbrank > 0 && mbrank < 7 {
            return UIImage.init(named: "common_icon_membership_level\(mbrank)")
        }
        return nil
    }
    
    //用户认证图标
    ///认证类型 -1：没有认证 0：认证用户 2，3，4：企业用户 220：达人
    var verifiedImage : UIImage? {
        
        switch status.user?.verified_type ?? -1 {
            
        case 0: return UIImage.init(named: "avatar_vip")
        
        case 2,3,4: return UIImage.init(named: "avatar_enterprise_vip")
            
        case 220: return UIImage.init(named: "avatar_grassroot")
            
        default:
            return nil
        }
        
    }

    ///用户配图数组
    /// 原创微博：可以带图也可以不带图
    /// 转发微博：如果带图，原创微博一定没图
    var thumbnails : [URL]?
    
    ///转发微博的正文
    var retweetedStatusText : String?{
        
        guard let s = status.retweeted_status else {
            return nil
        }
        let name = (s.user?.screen_name ?? "")
        let text = (s.text ?? "")
        return "@" + name + ":" + text
    }
    
    var cellID : String {
        return status.retweeted_status != nil ? RetweeetedStatusCellID : OriginStatusCellID
    }
    
    //缓存行高
    lazy var rowHeight : CGFloat = {
        //print("计算了rowHeight")
        let cell : StatusCell
        if status.retweeted_status != nil{
            //转发cell
            cell = RetweetedStatusCell.init(style: .default, reuseIdentifier: RetweeetedStatusCellID)
        }else{
            //原创cell
            cell = RetweetedStatusCell.init(style: .default, reuseIdentifier: OriginStatusCellID)
        }
        //类对象 引用类型
        return cell.RowHeight(statusVM: self)
    }()
    
    init(status:Status) {
        self.status = status
        super.init()
        //我们通过判断被转发的微博是否带图去控制图片来源
        if let urls = status.retweeted_status?.pic_urls ?? status.pic_urls {
            thumbnails = [URL]()
            urls.forEach({
                thumbnails!.append(URL.init(string: $0["thumbnail_pic"]!)!)
            })
        }
    }
}
