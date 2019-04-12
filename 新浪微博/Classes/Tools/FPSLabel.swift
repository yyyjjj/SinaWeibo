//
//  FPSLabel.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/6.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class FPSLabel: UILabel {

    private var link:CADisplayLink?
    
    private var lastTime:TimeInterval = 0.0;
    
    private var count:Int = 0;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        link = CADisplayLink.init(target: self, selector: #selector(FPSLabel.didTick(link:)))
        //commom会无论用户的app处于什么停止还是滑动都会进行fps打印
        link?.add(to: RunLoop.current, forMode: .common)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    @objc func didTick(link:CADisplayLink) {
        
        if lastTime == 0
        {
            lastTime = link.timestamp
            return
        }
        
        count += 1
        
        let delta = link.timestamp - lastTime
        
        if delta < 1{
            return
        }
        
        lastTime = link.timestamp
        
        let fps = Double(count)/delta
        
        count = 0
        
        text = String.init(format: "%02.0f帧", round(fps))
        
        print(text ?? "0")
    }
    
    /*
     Only override draw() if you perform custom drawing.
     An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
         Drawing code
    }
    */

}
