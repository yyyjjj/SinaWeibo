//
//  MessageTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/6/16.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

//let TypeOnecellID = "TypeOnecellID"
//let TypeTwocellID = "TypeTwocellID"
class MessageTableViewController: UIViewController {
    enum CellID : String{
        case TypeOneCellID = "TypeOneCellID",TypeTwoCellID = "TypeTwoCellID"
    }
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        prepareRefreshControl()
    }
    //MARK: - 准备控件
    func prepareRefreshControl()
    {
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: startRefreshing)
        (tableView.mj_header as? MJRefreshStateHeader)?.lastUpdatedTimeLabel.isHidden = true
    }
    @objc func startRefreshing() {
        
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { (_) in
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func prepareTableView(){
        
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: self.view.frame.height - tabBarController!.tabBar.frame.height)

        self.tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.always
        //把多余的cell去掉
        self.tableView.tableHeaderView = topSearchBar
        self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight*0.08)
        topSearchBar.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 44)
        self.tableView.estimatedSectionFooterHeight = 0
        topSearchBar.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 46))
        self.tableView.backgroundColor = backColor
        self.tableView.rowHeight = screenHeight*0.115
        self.tableView.register(MessageTableViewCellTypeOne.self, forCellReuseIdentifier: CellID.TypeOneCellID.rawValue)
        self.tableView.register(MessageTableViewCellTypeTwo.self, forCellReuseIdentifier: CellID.TypeTwoCellID.rawValue)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
    }
   
    //MARK: - 懒加载属性
    lazy var topSearchBar : LHJSearchBar = {
        let sb = LHJSearchBar.init()
        sb.placeholder = "Search"
        sb.backgroundColor = backColor
        return sb
    }()
    
    lazy var tableView = UITableView.init(frame: CGRect.zero, style: .plain)
    
    
}

extension MessageTableViewController :UITableViewDataSource,UITableViewDelegate
{
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        switch indexPath.row {
        case 0...2:
            cell = tableView.dequeueReusableCell(withIdentifier:CellID.TypeOneCellID.rawValue , for: indexPath)
            (cell as! MessageTableViewCellTypeOne).row = indexPath.row
        default:
            cell = tableView.dequeueReusableCell(withIdentifier:CellID.TypeTwoCellID.rawValue , for: indexPath)
            (cell as! MessageTableViewCellTypeTwo).row = indexPath.row
        }
        return cell
    }
    
}
