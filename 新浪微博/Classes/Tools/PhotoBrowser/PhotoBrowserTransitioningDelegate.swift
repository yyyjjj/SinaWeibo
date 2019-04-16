//
//  PhotoBrowserTransitioningDelegate.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/16.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
//MARK: - 获得图片位置的代理
protocol PhotoPositionDelegate : NSObjectProtocol{
    func PhotoBrowserPresentFromRect(indexPath : IndexPath) -> CGRect
    func PhotoBrowserPresentToRect(indexPath : IndexPath) -> CGRect
    func PhotoForAnimation(indexPath : IndexPath) -> UIImageView
}
//MARK: - 实现转场的代理
class PhotoBrowserTransitioningDelegate : NSObject, UIViewControllerTransitioningDelegate {
    
    //设置PhotoPositionDelegate的代理
    weak var PhotoRectDelegate : PhotoPositionDelegate?
    //当前点击item的index，用于计算图片位置
    var indexPath : IndexPath?
    
    func setPhotoRectDelegate(indexPath : IndexPath , delegate : PhotoPositionDelegate){
        self.PhotoRectDelegate = delegate
        self.indexPath = indexPath
    }
    
    var forPresented = false
    
    //返回完成present转场动画的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        forPresented = true
        return self
    }
    //返回完成dismiss转场动画的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        forPresented = false
        return self
    }
}
//MARK: - 实现转场动画
extension PhotoBrowserTransitioningDelegate: UIViewControllerAnimatedTransitioning {
    ///动画的时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    /// 转场动画
    ///
    /// - Parameter transitionContext: 展现对象的上下文
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //一，拿到跳转中from和to的控制器
        //MainVC
        transitionContext.viewController(forKey: .from)
        //PhotoBrowser
        transitionContext.viewController(forKey: .to)
        //二，拿到跳转中from和to的View
        transitionContext.view(forKey: .from)
        //MainVC的View
        forPresented ? AnimationForPresent(transitionContext: transitionContext) : AnimationForDismiss(transitionContext: transitionContext)
    }
    //present转场动画
    func AnimationForPresent( transitionContext: UIViewControllerContextTransitioning){
        let toView = transitionContext.view(forKey: .to)
        //PhotoBrowser里面的collectionView
        transitionContext.containerView.addSubview(toView!)
        toView?.alpha = 0
        UIView.animate(withDuration: 1.5, animations: {
            toView?.alpha = 1
        }) { (_) in
        //四，通知系统完成present，继续后面的操作
        transitionContext.completeTransition(true)

        }
       
    }
    //dismiss转场动画
    func AnimationForDismiss( transitionContext: UIViewControllerContextTransitioning){
        let fromView = transitionContext.view(forKey: .from)
        UIView.animate(withDuration: 1.5, animations: {
            fromView?.alpha = 0
           
        }) { (_) in
            fromView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
