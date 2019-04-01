//
//  OriginStatusCell.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/1.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
///原创微博
class OriginStatusCell: StatusCell {
    
    override var viewModel: StatusViewModel?
        {
        didSet
        {
            pictureView.snp.updateConstraints
                { (make) in
                    make.height.equalTo(pictureView.bounds.height)
                    make.width.equalTo(pictureView.bounds.width)
                    let topofs = (viewModel?.thumbnails?.count)! > 0 ? StatusCellMargins : 0
                    make.top.equalTo(contentLabel.snp.bottom).offset(topofs)
            }
        }
    }
    
    override func SetUpUI() {
        super.SetUpUI()
        ///添加图片布局
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargins)
            make.left.equalTo(contentLabel.snp.left)
            make.height.equalTo(300)
            make.width.equalTo(90)
        }
    }
}

