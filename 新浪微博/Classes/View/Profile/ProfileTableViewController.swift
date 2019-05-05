//
//  ProfileTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/3.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import QorumLogs
class ProfileTableViewController: VisitorTableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserAccountViewModel.shared.userLoginStatus {
            visitorview?.SetUpInfo(imagename: "visitordiscover_image_profile", text: "登录后，你的微博，相册，个人资料会显示在这里，展示给别人。")
            return
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setUpUI()
    }
    
    //MARK: - 懒加载属性
    lazy var refreshButton = UIButton.init(text: "更新用户", textColor: .blue, backImage: nil, isBack: false)
    lazy var logoutButton = UIButton.init(text: "退出", textColor: .red, backImage: nil, isBack: false)

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

//MARK: - 布局视图
extension ProfileTableViewController {
    func setUpUI(){
        //0,控件设置
        refreshButton.titleLabel?.textAlignment = .center
        logoutButton.titleLabel?.textAlignment = .center
        //1,添加控件
        UIApplication.shared.keyWindow?.addSubview(refreshButton)
        UIApplication.shared.keyWindow?.addSubview(logoutButton)
        
        //2,添加约束
        refreshButton.snp.makeConstraints { (make) in
            make.center.equalTo(UIApplication.shared.keyWindow!.snp.center)
        }
        logoutButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(UIApplication.shared.keyWindow!.snp.centerY).offset(40)
            make.centerX.equalTo(UIApplication.shared.keyWindow!.snp.centerX)
        }
        
        //3,设置按钮监听
        refreshButton.addTarget(self, action: #selector(refresh) , for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    //MARK: - 按钮监听方法
    ///刷新用户数据
    @objc func refresh(){
        guard let uid = UserAccountViewModel.shared.account?.uid else {
            return
        }
        UserAccountViewModel.shared.loadUserInfo(uid:uid) { (status) in
            if status{
                QL1("用户更改信息后刷新数据成功")
            }
        }
    }
    ///退出登陆
    @objc func logout(){
        //UserAccountViewModel.
//        FileManager.default.file
//        if FileManager.default.fileExists(atPath: UserAccountViewModel.shared.accountPath.absoluteString)
//        {
//
        
            do{
                //1,删除用户数据
                try FileManager.default.removeItem(at: UserAccountViewModel.shared.accountPath)
                QL1("清除用户数据成功")
                //2,更新UserAccountViewModel.shared
                UserAccountViewModel.upDateUserAccount()
                
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBSwitchVCControllerNotification), object: nil)
            }catch
            {
                QL4("清除用户数据失败\(error)")
            }
//        }
        
    }
}
