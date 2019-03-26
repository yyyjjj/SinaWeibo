//
//  HomeTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/3.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SVProgressHUD

private let StatusCellID = "StatusCellID"

class HomeTableViewController: VisitorTableViewController {
    
    var statusvm = StatusListViewModel.share
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //没有登录才去设置
        if !UserAccountViewModel.shared.userLoginStatus {
            visitorview?.SetUpInfo(imagename: nil, text:nil)
        }
        prepareforTableView()
        LoadStatus()
    }

    func LoadStatus(){
        StatusListViewModel.share.LoadStatus(){ (isSuccess) in
            if isSuccess == false
            {
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试")
                return
            }
            self.tableView.reloadData()
        }
    }
    ///注册cell
    func prepareforTableView()
    {
        tableView.register(StatusCell.self, forCellReuseIdentifier: StatusCellID)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
}
//MARK :-数据源方法
extension HomeTableViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusvm.StatusList?.count ?? 0
    }
}
//MARK :-代理方法
extension HomeTableViewController
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: StatusCellID, for: indexPath) as! StatusCell
        
        cell.viewModel = statusvm.StatusList?[indexPath.row]
        
        return cell
    }
}
