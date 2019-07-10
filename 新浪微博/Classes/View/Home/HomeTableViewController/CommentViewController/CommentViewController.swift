//
//  CommentViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/1.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
internal enum CellID : String
{
   case OriginStatusCellID
   case RetweetedStatusCellID
   case CommentTableViewCellID
}
class CommentViewController: UIViewController {
    ///只被赋值一次，进来就有值
    var statusViewModel : StatusViewModel?
    
    var commentListViewModel = CommentListViewModel()
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        
        statusViewModel?.loadComments({[weak self] (viewModels) in
        
            self?.commentListViewModel.viewModels = viewModels
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    //MARK: - 初始化控件及模型
    func prepareTableView()
    {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 400
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CellID.CommentTableViewCellID.rawValue)
        tableView.register(OriginStatusCell.self, forCellReuseIdentifier: CellID.OriginStatusCellID.rawValue)
        tableView.register(RetweetedStatusCell.self, forCellReuseIdentifier:CellID.RetweetedStatusCellID.rawValue)
    }
    
    lazy var tableView : UITableView = {
        
        let tv = UITableView.init(frame: self.view.frame)
        
        return tv
        
    }()
    
}

extension CommentViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return statusViewModel?.rowHeight ?? 0
        default:
            return commentListViewModel.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell!
        
        switch indexPath.row {
        case 0:
            let vm = statusViewModel
            
            cell = tableView.dequeueReusableCell(withIdentifier:vm!.cellID , for: indexPath)
            (cell as! StatusCell).bottomViewDelegate = self
            (cell as! StatusCell).viewModel = vm
            
        default:
            cell = tableView.dequeueReusableCell(withIdentifier:CellID.CommentTableViewCellID.rawValue , for: indexPath)
            
            (cell as! CommentTableViewCell).commentListViewModel = commentListViewModel
            
            return cell;
        }
        return cell
    }
    
}

extension CommentViewController : StatusCellBottomViewDelegate
{
    func didClickCommentButton(pointToWindow: CGPoint, statusViewModel: StatusViewModel) {
        
    }
    
    
}
