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
            
            topView.viewModel = viewModel
            contentLabel.text = viewModel?.status.text
            pictureView.viewModel = viewModel
            pictureView.snp.updateConstraints{ (make) in
                make.height.equalTo(pictureView.bounds.height)
                make.width.equalTo(pictureView.bounds.width)
//                let topofs = (viewModel?.thumbnails?.count)! > 0 ? StatusCellMargins : 0
//                make.top.equalTo(contentLabel.snp.bottom).offset(topofs)
            }
        }
    }
    
    func RowHeight(statusVM : StatusViewModel) -> CGFloat
    {
            self.viewModel = statusVM
            //强制更新
            contentView.layoutIfNeeded()
            return bottomView.frame.maxY
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        SetUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //防止别人使用Xib去创建
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var topView = StatusTopView()
    
    lazy var bottomView = StatusBottomView()
    
    lazy var pictureView = StatusPictureView()
    
    lazy var contentLabel = UILabel.init(content: "微博正文", size: 14, screenInset:StatusCellMargins)
    
}

extension StatusCell{
    @objc func SetUpUI(){
        
        pictureView.backgroundColor = UIColor.black
        //添加控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomView)
        contentView.addSubview(pictureView)
        bottomView.backgroundColor = UIColor.darkGray
        //布局
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(StatusCellIconWidth+2*StatusCellMargins)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(StatusCellMargins)
            make.left.equalTo(contentView.snp.left).offset(StatusCellMargins)
        }
        
//        pictureView.snp.makeConstraints { (make) in
//            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargins)
//            make.left.equalTo(contentLabel.snp.left)
//            make.height.equalTo(300)
//            make.width.equalTo(90)
//        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(pictureView.snp.bottom).offset(StatusCellMargins)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(44)
        }
    }
}
