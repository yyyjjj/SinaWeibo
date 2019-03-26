//
//  StatusTopView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SnapKit

class StatusTopView: UIView {

    var viewModel : StatusViewModel?{
        didSet{
           nameLabel.text = viewModel?.status.user?.screen_name
            iconView.sd_setImage(with: viewModel?.profileURL, placeholderImage: viewModel?.defaultProfile, options: [], completed: nil)
            memberIconView.image = viewModel?.memberImage
            vipIconView.image = viewModel?.verifiedImage
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///用户头像
    private lazy var iconView : UIImageView = UIImageView.init(image: UIImage.init(named: "avatar_default"))
    ///用户名称
    private lazy var nameLabel : UILabel = UILabel.init(content: "梁华建", textStyle: .left, size: 14)
    ///会员图标 大
    private lazy var memberIconView : UIImageView = UIImageView.init(image:UIImage.init(named: "common_icon_membership_level1"))
    ///认证图标 小
    private lazy var vipIconView : UIImageView = UIImageView.init(image: UIImage.init(named: "avatar_vip"))
    ///时间标签
    private lazy var timeLabel : UILabel = UILabel.init(content: "现在", textStyle: .left, size:11)
    ///来源标签
    private lazy var sourceLabel : UILabel = UILabel.init(content: "来源", textStyle: .left, size: 11)
    
}

extension StatusTopView
{
   func setupUI(){
//    self.backgroundColor = UIColor.gray
    //1,添加子控件
    self.addSubview(iconView)
    self.addSubview(nameLabel)
    self.addSubview(memberIconView)
    self.addSubview(vipIconView)
    self.addSubview(timeLabel)
    self.addSubview(sourceLabel)
    //2,布局
    iconView.snp.makeConstraints { (make) in
        make.top.equalTo(self.snp.top).offset(StatusCellMargins)
        make.left.equalTo(self.snp.left).offset(StatusCellMargins)
        make.height.equalTo(StatusCellIconWidth)
        make.width.equalTo(StatusCellIconWidth)
    }
  
    nameLabel.snp.makeConstraints { (make) in
    make.left.equalTo(iconView.snp.right).offset(StatusCellMargins)
    make.top.equalTo(iconView.snp.top)
    }
    
    memberIconView.snp.makeConstraints { (make) in
    make.left.equalTo(nameLabel.snp.right).offset(StatusCellMargins)
    make.top.equalTo(iconView.snp.top)
    }
    
    vipIconView.snp.makeConstraints { (make) in
    make.centerX.equalTo(iconView.snp.right)
    make.centerY.equalTo(iconView.snp.bottom)
    }
    
    timeLabel.snp.makeConstraints { (make) in
    make.bottom.equalTo(iconView.snp.bottom)
    make.left.equalTo(iconView.snp.right).offset(StatusCellMargins)
    }
    
    sourceLabel.snp.makeConstraints { (make) in
    make.bottom.equalTo(iconView.snp.bottom)
    make.left.equalTo(timeLabel.snp.right).offset(StatusCellMargins)
    }
    }
}
