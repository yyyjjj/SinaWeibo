//
//  UILabel+Extension.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/4.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
extension UILabel{
    convenience init(content : String ,textStyle : NSTextAlignment ,color : UIColor , size : CGFloat)
    {
        self.init()

        text = content

        textAlignment = textStyle

        textColor = color

        numberOfLines = 0

        font = UIFont.systemFont(ofSize: size)

    }
}
