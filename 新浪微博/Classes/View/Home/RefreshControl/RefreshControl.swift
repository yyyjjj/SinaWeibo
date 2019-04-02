//
//  RefreshControl.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/1.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

//MARK: -进行逻辑操作
class RefreshControl : UIRefreshControl {
    //反转零界点
    private let reverseOffSet : CGFloat = -60
    //MARK: -重写系统的Refresh方法
    override func endRefreshing() {
        super.endRefreshing()
        //停止动画
        refreshView.stopAnimation()
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        refreshView.startAnimation()
    }
    
    //MARK: -KVO监听下拉高度
    //控件始终在屏幕上面 x = 0 y初始值为0
    //下拉的时候Y值变小 上拉的时候Y值变大
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //当y大于0就没有监听的意义了
        if frame.origin.y > 0 {
            return
        }
        
        if isRefreshing{
            refreshView.startAnimation()
            return
        }
        
        if frame.origin.y < reverseOffSet && !refreshView.reverseFlag
        {
            print("反过来")
            refreshView.reverseFlag = true
        }
        else if frame.origin.y >= reverseOffSet && refreshView.reverseFlag
        {
            print("转回去")
            refreshView.reverseFlag = false
        }
//        print(frame)
    }
    
    //MARK: -初始化
    //保证xib和纯代码都能加载
    override init() {
        super.init()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    //MARK: -进行UI布局操作
    func setupUI(){
        //隐藏系统默认转轮
        tintColor = UIColor.clear
        
        self.addSubview(refreshView)
        //从xib指定视图布局，需要设定xib大小
        refreshView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(refreshView.bounds.size)
        }
        
        //监听frame的变化，来改变下拉刷新
        //把监听放到主队列去让其延迟监听，即刚刚开始的时候主线程在忙，先不执行主队列的任务，等下一次循环(用户开始滑动或加载网络数据)再去监听
        DispatchQueue.main.async {
            self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        }
    }
    
    deinit {
        //移除监听
        removeObserver(self, forKeyPath: "frame")
    }
    //MARK: -refreshView懒加载
    private lazy var refreshView = RefreshView.refreshView
}

//MARK: -RefreshView类定义
class RefreshView : UIView {
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var tip: UIImageView!
    
    @IBOutlet weak var loadingIconView: UIImageView!
    /// 播放加载动画
    func startAnimation()  {
        
        tipView.isHidden = true
        
        let key = "transform.rotation"
        //动画是否被添加
        if loadingIconView.layer.animation(forKey:key) != nil{
            return
        }
        
        print("加载动画播放")
        
        let anim = CABasicAnimation.init(keyPath: key)
        anim.toValue = 2*Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 20
        anim.isRemovedOnCompletion = false
        loadingIconView.layer.add(anim, forKey: key)
    }
    //MARK: -停止加载动画
    func stopAnimation() {
        
        tipView.isHidden = false
        
        loadingIconView.layer.removeAllAnimations()
        
    }
    
    var reverseFlag = false{
        didSet{
            TipRotate()
        }
    }
    
    static var refreshView : RefreshView = {
        let nib = UINib.init(nibName: "RefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! RefreshView
    }()
    //MARK :-反转动画
    func TipRotate()
    {
        var angel = CGFloat(Double.pi)
        //我们在angel加0.0001的话向左转要180.0001度，ios检测出走右边更近，就往右转
        //反过来就负数加了个正数，顺时针转下来更近
        angel += reverseFlag ? -0.0001 : 0.0001
        //IOS图像旋转 就近原则 + 顺时针优先
        UIView.animate(withDuration: 0.5) {
            self.tip.transform = self.tip.transform.rotated(by:angel)
        }
    }
}
