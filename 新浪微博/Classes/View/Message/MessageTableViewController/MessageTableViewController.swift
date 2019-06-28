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
class MessageTableViewController: UITableViewController {
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
        self.refreshControl = RefreshControl.init()
        
        self.refreshControl?.backgroundColor = backColor
        refreshControl?.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)
    }
    @objc func startRefreshing() {
          refreshControl?.beginRefreshing()
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { (_) in
            self.refreshControl?.endRefreshing()
        }
    }
    
    func prepareTableView(){
        //把多余的cell去掉
        self.tableView.tableHeaderView = topSearchBar
        self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight*0.08)
        topSearchBar.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 44)
        
        topSearchBar.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableView.backgroundColor = backColor
        self.tableView.rowHeight = screenHeight*0.115
        self.tableView.register(MessageTableViewCellTypeOne.self, forCellReuseIdentifier: CellID.TypeOneCellID.rawValue)
        self.tableView.register(MessageTableViewCellTypeTwo.self, forCellReuseIdentifier: CellID.TypeTwoCellID.rawValue)
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
   
    //MARK: - 懒加载属性
    lazy var topSearchBar : LHJSearchBar = {
        let sb = LHJSearchBar.init()
        sb.placeholder = "Search"
        sb.backgroundColor = backColor
        return sb
    }()
    
    
}
