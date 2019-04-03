//
//  HomeTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/3.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SVProgressHUD

let OriginStatusCellID = "OriginStatusCellID"
let RetweeetedStatusCellID = "RetweeetedStatusCellID"
class HomeTableViewController: VisitorTableViewController {
    
    var statuslistviewModel = StatusListViewModel()
    
    lazy var indicator : UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView()
        ind.style = .whiteLarge
        ind.color = .gray
        return ind
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //没有登录才去设置
        if !UserAccountViewModel.shared.userLoginStatus {
            visitorview?.SetUpInfo(imagename: nil, text:nil)
        }
        prepareforTableView()
        LoadStatus()
        
    }
    
    ///注册原创和转发微博cell
    ///设置预估高度
    ///取消tableView的分割线
    func prepareforTableView()
    {
        tableView.register(OriginStatusCell.self, forCellReuseIdentifier: "OriginStatusCellID")
        tableView.register(RetweetedStatusCell.self, forCellReuseIdentifier: "RetweeetedStatusCellID")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 400
        refreshControl = RefreshControl()
//        let v = UIView()
//        v.backgroundColor = .red
//        v.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
//        refreshControl?.addSubview(v)
        refreshControl?.addTarget(self, action: #selector(LoadStatus), for: .valueChanged)
    }
    
    ///加载Status数据到ListViewModel并刷新tableView
    @objc func LoadStatus(){
        refreshControl?.beginRefreshing()
        statuslistviewModel.LoadStatus(isPullUp: indicator.isAnimating)
        { (isSuccess) in
            
            self.refreshControl?.endRefreshing()
            
            self.indicator.stopAnimating()
            
            if isSuccess == false
            {
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试")
                return
            }
            self.tableView.reloadData()
        }
    }
}
//MARK :-数据源方法
extension HomeTableViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statuslistviewModel.StatusList.count 
    }
}
//MARK :-代理方法
extension HomeTableViewController
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = statuslistviewModel.StatusList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: vm.cellID, for: indexPath) as! StatusCell
        cell.selectionStyle = .none
        
        cell.viewModel = vm
        
        if indexPath.row == statuslistviewModel.StatusList.count-1 && !indicator.isAnimating{
            indicator.startAnimating()
            LoadStatus()
        }
        return cell
    }
    //MARK: -TODORowHeight
    //完成RowHeight的一次计算，由于我们设置了estimatedRowHeight，系统会根据每次能填满屏幕高度的cell去调用几次rowHeight，我们可以提前计算好所以rowHeight，而不是用户去滑动到下一页的时候再去计算。
    //思路：我们可以通过runloop判断当前的ScrollView是处于UITrackingRunLoopMode还是NSDefaultRunLoopMode，如果是第二个及空闲状态，用户什么也不点击也不加载网络，那么就去把剩下的cell高度全部计算出来。
    
    //情况一：设置了EstimateRowHeight
    //系统会根据填满界面Cell的数量，每个cell计算三次高度，其他的cell在用户滑动到再去调用
    //调用顺序：行数 -> cell -> 行高
    //优化思路：我们可以把每一个model封装出一个rowHeight属性，缓存高度，防止多次计算Cell的高度
    
    
    //情况二：没有设置EstimateRowHeight
    //系统一次计算所有的cell高度，并且每行计算3次，而且用户滑动的时候他仍然会计算高度,每个cell调用三次
    //系统会一次计算整个tableView的contentsize，假如cell的count是18，那么会计算18个cell的高度，这是因为UITableView继承于UIScrollView，为了增加用户滑动的时候的流畅性，会把所有需要的cell高度都提前计算好！
    //苹果建议：如果设置了TableView.rowHeight 就不要使用下面方法，两者互斥。
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("计算了rowHeight----第\(indexPath.row)行")
        return statuslistviewModel.StatusList[indexPath.row].rowHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return indicator
    }
}
