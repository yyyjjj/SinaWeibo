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
    
    ///用户认证图标
    ///认证类型 -1：没有认证 0：认证用户 2，3，4：企业用户 220：达人
    var verifiedImage : UIImage? {
        switch status.user?.verified_type ?? -1 {
        case 0: return UIImage.init(named: "avatar_vip")
            break;
        case 2,3,4: return UIImage.init(named: "avatar_enterprise_vip")
            
        case 220: return UIImage.init(named: "avatar_grassroot")
            
        default:
            return nil
        }
    }
    
    init(status:Status) {
        self.status = status
    }
    
}
