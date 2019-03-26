//
//  StatusCellTableViewCell.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
let StatusCellMargins : CGFloat = 12
let StatusCellIconWidth : CGFloat = 35
class StatusCell: UITableViewCell {
    
    var viewModel : StatusViewModel?
    {
        didSet
        {
            topview.viewModel = viewModel
            contentLabel.text = viewModel?.status.text
            SetUpUI()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //防止别人使用Xib去创建
        fatalError("init(coder:) has not been implemented")
    }
    lazy var topview = StatusTopView()
    
    lazy var bottomview = StatusBottomView()
    
    lazy var contentLabel = UILabel.init(content: "微博正文", textStyle: .left,size: 15)
    
  }

extension StatusCell{
    
    func SetUpUI(){
        
        //添加控件
        contentView.addSubview(topview)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomview)
//        bottomview.backgroundColor = UIColor.darkGray
        contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 2*StatusCellMargins
        //布局
        topview.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.topMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(StatusCellIconWidth+StatusCellMargins)
        }
        contentLabel.snp.makeConstraints { (make) in
        make.top.equalTo(topview.snp.bottom).offset(StatusCellMargins)
        make.left.equalTo(contentView.snp.left).offset(StatusCellMargins)
        
        }
        bottomview.snp.makeConstraints { (make) in
    make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargins)
        make.left.equalTo(contentView.snp.left)
        make.right.equalTo(contentView.snp.right)
        make.bottom.equalTo(contentView.snp.bottom).offset(-12)
        make.height.equalTo(44)
        }
    }
    
}
