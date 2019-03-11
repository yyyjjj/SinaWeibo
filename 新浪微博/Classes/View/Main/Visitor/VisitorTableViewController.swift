//
//  VisitorTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/4.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class VisitorTableViewController: UITableViewController {
    
    // MARK: -用户登录状态
    private var loginStatus = UserAccountViewModel.shared.userLoginStatus
    //懒加载会被子类调用而产生不必要的view
    var visitorview : VisitorView? = VisitorView()
    
    override func loadView() {
        //loadView -》load TableView
        loginStatus == true ? super.loadView() : SetUpUI()
        
        visitorview?.delegate = self
        
    }
    
    func SetUpUI(){
        
        view = visitorview
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册", style: .plain, target: self, action: #selector(ClickRegisteButton))
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem.init(title: "登录", style: .plain, target: self, action: #selector(ClickLoginButton))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        print(visitorview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
extension VisitorTableViewController : VisitorViewDelegate{
    @objc func ClickRegisteButton() {
        print("注册")
    }
    
    @objc func ClickLoginButton() {
        print("登录")
        let VC =  OAuthLoginViewController()
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
}
