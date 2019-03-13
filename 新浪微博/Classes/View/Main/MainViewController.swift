//
//  MainViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/3.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    // MARK: -按钮监听方法
    ///使用OC消息转发机制
    @objc private func ClickComposeButton(){
        print("T##items: Any...##Any")
    }
    
    // MARK: -视图生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChilds()

        addComposedButton()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //在window调用了makeKeyAndVisible才调用
        self.tabBar.bringSubviewToFront(composedButton)
    }
    
     // MARK: -懒加载tabBar中间加号按钮
    private lazy var composedButton : UIButton = UIButton.init(image: "tabbar_compose_icon_add", backImage: "tabbar_compose_button")
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - 添加控制器
extension MainViewController{
    private func addComposedButton(){
        
        self.tabBar.addSubview(composedButton)
        
        let count = children.count
        
        let w = (tabBar.bounds.size.width/CGFloat(count)) - 1
       //dx正数，形成中间的view就越小
        composedButton.frame = tabBar.bounds.insetBy(dx: 2*w, dy: 0)
        
        composedButton.addTarget(self, action: #selector(ClickComposeButton), for: .touchUpInside)
    }
    private func addChilds()  {
        
        addChild(childController: HomeTableViewController(), title: "首页", barImage:"tabbar_home", highLightImage: "tabbar_home_selected")
        
        addChild(childController: MassageTableViewController(), title: "消息", barImage:"tabbar_message_center", highLightImage: "tabbar_message_center_selected")
        
         addChild(childController: UIViewController(), title: nil, barImage:nil, highLightImage: nil)
        
        addChild(childController: DiscoverTableViewController(), title: "发现", barImage:"tabbar_discover", highLightImage: "tabbar_discover_selected")
        
        addChild(childController: ProfileTableViewController(), title: "我", barImage:"tabbar_profile", highLightImage: "tabbar_profile_selected")
        
    }
    private func addChild(childController : UIViewController,title : String?,barImage : String? ,highLightImage : String?) {
        
        guard let title = title,let barImage = barImage, let highLightImage = highLightImage else {
            addChild(childController)
            return
        }
        tabBar.tintColor = UIColor.orange
        //设置标题，由内至外
        childController.title = title
        
        childController.tabBarItem.image = UIImage.init(named: barImage)
        
        childController.tabBarItem.selectedImage = UIImage.init(named: highLightImage)
        
        let nav = UINavigationController.init(rootViewController: childController)
        
        addChild(nav)
    }
    
}
