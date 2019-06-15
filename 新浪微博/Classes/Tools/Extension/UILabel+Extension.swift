//
//  UILabel+Extension.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/4.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
extension UILabel{
    
    /// Label遍历构造函数
    ///
    /// - Parameters:
    ///   - content: 正文
    ///   - color: 文字颜色
    ///   - size: 字体大小
    ///   - screenInset: 设置文字距离屏幕两边的距离，没有设置的话就是居中显示
    convenience init(content : String  ,color : UIColor = UIColor.gray , size : CGFloat , screenInset : CGFloat = 0)
    {
        self.init()

        text = content
        
        if screenInset == 0
        {
            textAlignment = NSTextAlignment.center
        }
        else
        {
            preferredMaxLayoutWidth = UIScreen.main.bounds.width-2*screenInset
        }

        textColor = color

        numberOfLines = 0

        font = UIFont.systemFont(ofSize: size)

        sizeToFit()
        
    }
    
    convenience init( size : CGFloat , content : String , color : UIColor , alignment : NSTextAlignment , lines : Int , breakMode : NSLineBreakMode) {
        self.init()
        font = UIFont.systemFont(ofSize: size)
        text = content
        textColor = color
        textAlignment = alignment
        numberOfLines = lines
        lineBreakMode = breakMode
    }
}
