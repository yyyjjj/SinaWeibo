//
//  CommentViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/1.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        
    }
    func prepareTableView()
    {
        self.view.addSubview(tableView)
    }
    ///TopTableView -> 
    lazy var tableView = UITableView()
}
