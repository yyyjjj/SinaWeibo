//
//  StatusBottomView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class StatusBottomView: UIView {
    ///转发按钮
    private lazy var retweetedButton = UIButton.init(text: "转发", textColor: UIColor.darkGray, backImage: "timeline_icon_retweet", textSize: 12,isBack:false);
    ///评论按钮
    private lazy var commentButton = UIButton.init(text: "评论", textColor: UIColor.darkGray, backImage: "timeline_icon_comment", textSize: 12,isBack:false);
    ///点赞按钮
    private lazy var likeButton = UIButton.init(text: "转发", textColor: UIColor.darkGray, backImage: "timeline_icon_unlike", textSize: 12,isBack:false);
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension StatusBottomView {
    func setupUI()
    {
        self.addSubview(retweetedButton)
        self.addSubview(commentButton)
        self.addSubview(likeButton)
        
        retweetedButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedButton.snp.top)
            make.left.equalTo(retweetedButton.snp.right)
            make.width.equalTo(retweetedButton.snp.width)
            make.height.equalTo(retweetedButton.snp.height)
        }
        
        likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(commentButton.snp.top)
            make.left.equalTo(commentButton.snp.right)
            make.width.equalTo(commentButton.snp.width)
            make.height.equalTo(commentButton.snp.height)
            make.right.equalTo(self.snp.right)
        }
        
        let line1 = sepLine()
        let line2 = sepLine()
        self.addSubview(line1)
        self.addSubview(line2)
        let w = 0.5
        let scale = 0.4
        line1.snp.makeConstraints { (make) in
            make.height.equalTo(retweetedButton.snp.height).multipliedBy(scale)
            make.width.equalTo(w)
            make.left.equalTo(retweetedButton.snp.right)
            make.centerY.equalTo(retweetedButton.snp.centerY)
            
        }
        line2.snp.makeConstraints { (make) in
            make.height.equalTo(commentButton.snp.height).multipliedBy(scale)
            make.width.equalTo(w)
            make.left.equalTo(commentButton.snp.right)
            make.centerY.equalTo(retweetedButton.snp.centerY)
        }
    }
    //分割线
    func sepLine() -> UIView{
        let line = UIView()
        line.backgroundColor = UIColor.gray
        return line
    }
}
