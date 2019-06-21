//
//  LHJSearchBar.swift
//  UISearchBar子类封装-自定义高度
//
//  Created by 梁华建 on 2019/6/16.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class LHJSearchBar: UISearchBar {
    var contentInset : UIEdgeInsets? {
        didSet{
            self.setNeedsDisplay()
        }
    }
    //进来了三次
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in self.subviews{
            
          for v in view.subviews
          {
        //这里有UISearchBarBackground和UISearchBarTextField
            //拿到文本框
            if v.isKind(of: UITextField.self)
            {
            //发现外部已经给i其赋值
             if let textFieldContentInset = contentInset
             {
                v.frame = CGRect.init(x: textFieldContentInset.left, y: textFieldContentInset.top, width: self.bounds.width - textFieldContentInset.left - textFieldContentInset.right, height: self.bounds.height-textFieldContentInset.top-textFieldContentInset.bottom)
            }else
             {
                //设置默认边距
                let top: CGFloat = (self.bounds.height - 28.0) / 2.0
                let bottom: CGFloat = top
                let left: CGFloat = 8.0
                let right: CGFloat = left
                contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
            }
            }
          }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
