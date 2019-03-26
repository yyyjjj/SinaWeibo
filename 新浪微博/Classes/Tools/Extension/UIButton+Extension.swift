//
//  UIButton+Extension.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/4.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

extension UIButton
{
    ///方便构造函数：根据图片设置按钮大小
    convenience init(image : String,backImage : String){
        
        self.init()
        
        setImage(UIImage.init(named: image), for: .normal)
        
        setImage(UIImage.init(named: "\(image)_highlighted"), for: .selected)
        
        setImage(UIImage.init(named: backImage), for: .normal)
        
        setImage(UIImage.init(named: "\(backImage)_highlighted"), for: .selected)
        //根据背景图片条件调整按钮大小
        sizeToFit()
    }
    ///方便构造函数：设置文字及背景图片,该方法是对于自动布局使用的,否则请自行设置button的frame或sizeToFit
    convenience init(text : String? , textColor : UIColor? , backImage : String? ,highlight : String? = nil ,textSize : CGFloat = 14){
        //UIButton类的init会调用super.init()初始化UIView
        self.init()
        
        guard let text = text else {
            
            guard let backImage = backImage else {
                return
            }
            
            guard let highlight = highlight else {
                
                setImage(UIImage.init(named: backImage), for: .normal)
                
                return
            }
            
            setImage(UIImage.init(named: backImage), for: .normal)
            
            setImage(UIImage.init(named: highlight), for: .highlighted)
            
            return
        }
        
        setTitle(text, for: .normal)
        
        titleLabel?.font = UIFont.systemFont(ofSize: textSize)
        setImage(UIImage.init(named: backImage!), for: .normal)
        
        guard let highlight = highlight else {
            
            setTitleColor(textColor ?? UIColor.black , for: .normal)
            
            return
        }
        
        
       
        setImage(UIImage.init(named: highlight), for: .highlighted)
        
        setTitleColor(textColor ?? UIColor.black , for: .normal)
         sizeToFit()
    }
}

