//
//  ProfileTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/3.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import QorumLogs

let profileCellId = "profileCellId"

class ProfileTableViewController: VisitorTableViewController {
    
    var userAccountViewModel = UserAccountViewModel.shared
    //MARK: - 生命周期
    override func viewDidLoad() {
    
        super.viewDidLoad()
        QL1(userAccountViewModel.accountPath)
        
        if !UserAccountViewModel.shared.userLoginStatus {
            visitorview?.SetUpInfo(imagename: "visitordiscover_image_profile", text: "登录后，你的微博，相册，个人资料会显示在这里，展示给别人。")
            
            return
        }
        
        setUpUI()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: profileCellId)
        
    }
    
    //MARK: - 懒加载属性
    lazy var refreshButton = UIButton.init(text: "更新用户", textColor: .blue, backImage: nil, isBack: false)
    lazy var logoutButton = UIButton.init(text: "退出", textColor: .red, backImage: nil, isBack: false)
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 100
        default:
            return 44
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: profileCellId)
        print(indexPath.row)
        if cell == nil{
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: profileCellId)
        }
        
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = userAccountViewModel.account?.screen_name
            cell?.imageView?.sd_setImage(with: userAccountViewModel.avatar_largeURL, completed: nil)
            cell?.imageView?.layer.cornerRadius = 50
            cell?.imageView?.clipsToBounds = true
            cell?.detailTextLabel?.textColor = .red
            cell?.accessoryType = .disclosureIndicator
        case 1:
            cell?.textLabel?.text = "所在地：   \(userAccountViewModel.account!.location!)"
            //        case 2:
//        cell.textLabel?.text = userAccountViewModel.account.
        default:
            return cell!
        }
        return cell!
    }
}

//MARK: - 布局视图
extension ProfileTableViewController {
    func setUpUI(){
        //0,控件设置
        refreshButton.titleLabel?.textAlignment = .center
        logoutButton.titleLabel?.textAlignment = .center
        //1,添加控件
//        UIApplication.shared.keyWindow?.addSubview(refreshButton)
//        UIApplication.shared.keyWindow?.addSubview(logoutButton)
        self.view.addSubview(refreshButton)
        self.view.addSubview(logoutButton)
        //2,添加约束
        refreshButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.view.snp.center)
        }
        logoutButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerY).offset(40)
            make.centerX.equalTo(self.view.snp.centerX)
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
    }
}
