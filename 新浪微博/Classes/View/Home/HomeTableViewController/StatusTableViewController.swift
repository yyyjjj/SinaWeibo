//
//  StatusTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/6/27.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SVProgressHUD
import QorumLogs

let OriginStatusCellID = "OriginStatusCellID"
let RetweeetedStatusCellID = "RetweeetedStatusCellID"

class StatusTableViewController: UIViewController {
    
    ///用与在网络错误的时候，防止用户多次刷新
    //    private var reloadSignal = 0
    
    //MARK: - 生命周期
    override func viewWillAppear(_ animated: Bool) {
        //键盘高度改变的通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTVCKeyBoardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //没有登录才去设置
        prepareTableView()
        
        LoadStatus()
        
        prepareReloadButton()
        
        //        prepareFPSLabel()
        //测试帧数
        //接受通知
        prepareNotification()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: - 控件初始化和布局
    func prepareNotification()
    {
        //接收微博中图片点击通知
        //通知单例为了给self发消息强引用self，self中也有通知才能一直监听该事件。
        //注意：block注册的通知不会被移除
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: WBPictureCellSelectNotification), object: nil, queue: nil) { [weak self] (notification) in
            
            guard let indexpath = notification.userInfo?[NSNotification.Name.init(rawValue: WBPictureCellIndexNotification)] as? IndexPath else{
                return
            }
            
            guard let urls = notification.userInfo?[NSNotification.Name.init(rawValue: WBPictureArrayNotification)] as? [URL] else{
                return
            }
            //PictureView的cell，PictureView遵循了PhotoBrowserPresentDelegate，协议的继承性
            guard let cell = notification.object as? PhotoBrowserPresentDelegate else{
                return
            }
            
            let vc = PhotoBrowserViewController(urls: urls, indexPath: indexpath)
            
            vc.modalPresentationStyle = .custom
            
            vc.transitioningDelegate = self?.photoTransitionDelegate
            
            //通过回传的PhotoView把其设置为代理对象
            self?.photoTransitionDelegate.setPhotoDelegate(indexPath: indexpath, presentDelegate: cell, dismissDelegate: vc)
            
            self?.present(vc, animated: true
                , completion: nil)
            
        }
        //接收微博中评论按钮点击通知
        NotificationCenter.default.addObserver(forName: .init(rawValue: WBCellCommentBottomClickedNotification), object: nil, queue: nil) {[weak self] (notification) in
            
            guard let commentCount = notification.userInfo?[WBCellCommentCountsNotification] as? Int else
            {
                return
            }
            
            guard let commentViewPositionToWindows = notification.userInfo?[CurrentCommentBottonPoint] as? CGPoint else
            {
                return
            }
            
            guard let statusTag = notification.userInfo?["StatusID"] as? Int else
            {
                return
            }
            //评论区没有人数
            if commentCount <= 0
            {
            //1.创建文本框
            self?.commentViewPosition = commentViewPositionToWindows
            
            self?.lastTextViewTag = statusTag
            ///如果在表中找到上次编辑的评论内容，那么就赋值
            self?.commentView.textView.text = self?.commentTable.keys.contains(statusTag) ?? false ? self?.commentTable[statusTag] : nil
            self?.lastTextViewTag = statusTag
            self?.viewAboveTableView.isHidden = false
            self?.commentView.textView.becomeFirstResponder()
            }else
            {//评论有人评论，进入对于当前微博的评论View
                self?.navigationController?.pushViewController(CommentViewController(), animated: true)
            }
            
        }
    }
    
    @objc func tapViewOutSideOfKeyBoard() {
        
        self.viewAboveTableView.isHidden = true
        
        self.commentView.textView.resignFirstResponder()
    }
    
    
    
    @objc func HomeTVCKeyBoardWillChange(_ notification : NSNotification)
    {
        //拿到键盘改变前后的高度,相对于window
        let rect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let curve = (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue
        //第一次打开键盘输入字母会再次进入这个方法，即使rect没有改变
        if rect != lastKeyBoardRect
        {
        lastKeyBoardRect = rect
        
        var contentOffset : CGPoint!
        
        if rect.origin.y == screenHeight
        {
            //键盘收回到屏幕下方
            contentOffset = CGPoint.init(x:0 , y: self.tableView.contentOffset.y-(commentViewPosition.y -  (screenHeight-rect.size.height-commentView.frame.height)))
            //更新文字
            commentTable[lastTextViewTag] = commentView.textView.text
        }else
        {
            //键盘弹出
            contentOffset = CGPoint.init(x:0 , y: self.tableView.contentOffset.y+(commentViewPosition.y -  (screenHeight-rect.size.height-commentView.frame.height)))
        }
        //滚动tableView到被textView遮挡
        self.tableView.setContentOffset(contentOffset, animated: true)
        
        UIView.animate(withDuration: duration) {
            self.commentView.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.viewAboveTableView.snp.bottom).offset(-rect.size.height)
            }
        }
        
        UIView.animate(withDuration: duration) {
        UIView.setAnimationCurve(UIView.AnimationCurve.init(rawValue: curve)!)
            self.view.layoutIfNeeded()
        }
        }
    }
    
    //func prepareFPSLabel(){
    //                let fpslabel = FPSLabel()
    //                //view.addSubview(fpslabel)
    //                //view.bringSubviewToFront(fpslabel)
    //
    //                UIApplication.shared.keyWindow?.addSubview(fpslabel)
    //                fpslabel.snp.makeConstraints { (make) in
    //                    make.center.equalTo(UIApplication.shared.keyWindow!.snp.center)
    //                    make.height.equalTo(30)
    //                    make.width.equalTo(60)
    //                }
    //    }
    ///准备ReloadButton
    func prepareReloadButton() {
        
        self.view.addSubview(reloadButton)
        
        reloadButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.view.snp.center)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        reloadButton.isHidden = true
        
        reloadButton.addTarget(self, action: #selector(clickReloadButton), for: .touchUpInside)
        
    }
    
    ///注册原创和转发微博cell
    ///设置预估高度
    ///取消tableView的分割线
    func prepareTableView()
    {
        //1.添加子控件
        self.view.addSubview(tableView)
        self.view.insertSubview(viewAboveTableView, aboveSubview: tableView)
        self.viewAboveTableView.addSubview(self.commentView)
        //2.设置布局
        viewAboveTableView.snp.makeConstraints { (make) in
            make.height.equalTo(screenHeight)
            make.bottom.equalTo(self.view.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
        
        self.commentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(viewAboveTableView.snp.bottom)
            make.width.equalTo(screenWidth)
            make.height.equalTo(130)
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(OriginStatusCell.self, forCellReuseIdentifier: OriginStatusCellID)
        
        tableView.register(RetweetedStatusCell.self, forCellReuseIdentifier: RetweeetedStatusCellID)
        
        tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = 400
        
        tableView.refreshControl = RefreshControl()
        
        //        refreshControl = UIRefreshControl()
        //        let redView = UIView.init(frame: CGRect(x: 0,y: 0,width: 50,height: 20))
        //        redView.backgroundColor = .red
        //        refreshControl?.addSubview(redView)
        //        refreshControl?.addTarget(self, action: #selector(LoadStatus), for: .valueChanged)
        //        UIControl.Event.touchDragExit
        
        
        viewAboveTableView.isHidden = true
        
        tableView.refreshControl?.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)
    }
    
    //MARK: - 功能函数
    ///加载微博数据，里面会进行本地缓存判断。
    @objc func LoadStatus(){
        tableView.refreshControl?.beginRefreshing()
        statuslistviewModel.LoadStatus(isPullUp: indicator.isAnimating)
        { (isSuccess) in
            
            self.indicator.stopAnimating()
            
            if isSuccess == false
            {
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试")
                self.reloadButton.isHidden = false
                return
            }
            
            self.addRefreshStatusLabel()
            
            self.reloadButton.isHidden = true
            
            self.tableView.reloadData()
            
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false
                , block: { (_) in
                    self.tableView.refreshControl?.endRefreshing()
            })
        }
        
    }
    ///TargetAction通知
    @objc func startRefreshing() {
        LoadStatus()
    }
    
    func addRefreshStatusLabel()  {
        
        guard let refreshCount = statuslistviewModel.pullDownStatusCount else {
            return
        }
        //QL1("刷新到\(refreshCount)条数据")
        self.refreshStatusLabel.text = refreshCount != 0 ? "刷新到\(refreshCount)条数据" : "没有刷新到数据"
        //我们来改变他的y轴距离去让他显示
        let labelY : CGFloat = 44
        
        let rect = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 44)
        
        self.refreshStatusLabel.frame = rect.offsetBy(dx: 0, dy: -2*labelY)
        
        self.navigationController?.navigationBar.insertSubview(self.refreshStatusLabel, at: 0)
        
        //我们在这里添加label在navibar上面还是下面
        UIView.animate(withDuration: 1.5, animations: {
            self.refreshStatusLabel.frame = rect.offsetBy(dx: 0, dy: labelY)
            //            self.refreshControl?.endRefreshing()
        }, completion: { _ in
            //让动画保持一秒
            DispatchQueue.main.asyncAfter(deadline: .now()
                + 1, execute: {
                    self.refreshStatusLabel.frame = CGRect.init(x: 0, y: -2*labelY, width: self.view.bounds.width, height: 44)
            })
        })
    }
    ///重新加载
    @objc func clickReloadButton(){
        LoadStatus()
    }
    //MARK: - 懒加载控件
    lazy var tableView : UITableView = UITableView.init()
    
    lazy var viewAboveTableView : UIView = {
        let view = UIView.init()
        view.addGestureRecognizer(self.tapGesture)
        view.backgroundColor = UIColor.init(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 0.3)
        
        return view
    }()
    
    var statuslistviewModel = StatusListViewModel()
    
    lazy var photoTransitionDelegate = PhotoBrowserTransitioningDelegate()
    ///刷新时的小转轮
    lazy var indicator : UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView()
        ind.style = .whiteLarge
        ind.color = .gray
        return ind
    }()
    ///网络错误时候的重新加载
    lazy var reloadButton : UIButton = {
        let button = UIButton()
        button.setTitle("重新加载", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    ///刷新的Label
    lazy var refreshStatusLabel : UILabel = {
        let label = UILabel.init(content: "", size: 14)
        label.textColor = .black
        label.backgroundColor = UIColor.orange
        return label
    }()
    ///键盘上的textView
    lazy var commentView : CommentKeyBoardView = {
        let tf = CommentKeyBoardView.init(frame: CGRect.init(x: 0, y: screenHeight, width: screenWidth, height: 0))
        tf.backgroundColor = backColor
        return tf
    }()
    ///键盘出现时的外部点击手势
    lazy var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapViewOutSideOfKeyBoard))
    ///评论View的位置
    var commentViewPosition = CGPoint.init(x: 0, y: 0)
    ///评论记录表，key为微博的id，下一次评论该微博可以找到之前编辑的内容
    var commentTable = [Int : String]()
    ///保存上一次的StatusID，用于更新评论表的内容
    var lastTextViewTag : Int = 0
    ///防止键盘弹出后打字再次改变高度
    var lastKeyBoardRect : CGRect = CGRect.init()
    
}

//extension HomeTableViewController :

//MARK: - tableView代理方法
extension StatusTableViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        QL1("调用了numberOfRowsInSection")
        return statuslistviewModel.StatusList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = statuslistviewModel.StatusList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: vm.cellID, for: indexPath) as! StatusCell
        
        cell.selectionStyle = .none
        
        cell.viewModel = vm
        
        cell.bottomView.tag = vm.status.id
        
        cell.clickLabelDelegate = self
        
        cell.topView.clickdelegate = self
        
        if indexPath.row == statuslistviewModel.StatusList.count-1 && !indicator.isAnimating{
            indicator.startAnimating()
            LoadStatus()
        }
        
        //        QL1("调用了cellForRowAt")
        return cell
    }
    //MARK: - TODORowHeight
    //完成RowHeight的一次计算，由于我们设置了estimatedRowHeight，系统会根据每次能填满屏幕高度的cell去调用几次rowHeight，我们可以提前计算好所以rowHeight，而不是用户去滑动到下一页的时候再去计算。
    //思路：我们可以通过runloop判断当前的ScrollView是处于UITrackingRunLoopMode还是NSDefaultRunLoopMode，如果是第二个及空闲状态，用户什么也不点击也不加载网络，那么就去把剩下的cell高度全部计算出来。
    
    //情况一：设置了EstimateRowHeight
    //系统会根据填满界面Cell的数量，每个cell计算三次高度，其他的cell在用户滑动到再去调用
    //调用顺序：行数 -> 行高 -> cell -> 行高
    //优化思路：我们可以把每一个model封装出一个rowHeight属性，缓存高度，防止多次计算Cell的高度
    
    //情况二：没有设置EstimateRowHeight
    //系统一次计算所有的cell高度，并且每行计算3次，而且用户滑动的时候他仍然会计算高度,每个cell调用三次
    //系统会一次计算整个tableView的contentsize，假如cell的count是18，那么会计算18个cell的高度，这是因为UITableView继承于UIScrollView，为了增加用户滑动的时候的流畅性，会把所有需要的cell高度都提前计算好！
    
    //苹果建议：如果设置了TableView.rowHeight 就不要使用下面方法，两者互斥。
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //print("计算了rowHeight----第\(indexPath.row)行")
        //        QL1("调用了行高计算")
        //        if cell != nil && (cell as! StatusCell).bottomView.frame.maxY != statuslistviewModel.StatusList[indexPath.row].rowHeight
        //        {
        //            statuslistviewModel.StatusList[indexPath.row].rowHeight = (cell as! StatusCell).bottomView.frame.maxY
        //        }
        
        return statuslistviewModel.StatusList[indexPath.row].rowHeight
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return indicator
    }
    
}
//MAKR: - 正文蓝色Label点击代理
extension StatusTableViewController : ClickLabelDelegate
{
    func didClickURL(url: URL) {
        let webVC = HomeWebViewController.init(url: url)
        webVC.hidesBottomBarWhenPushed = true
        self.navigationController?.delegate = self; self.navigationController?.pushViewController(webVC, animated:true)
    }
    
}
extension StatusTableViewController : UINavigationControllerDelegate
{
    
}
extension StatusTableViewController : ClickUserIconProtocol
{
    func clickUserIcon(viewModel: StatusViewModel) {
        //        QL1("点击了\(viewModel.status.user!.screen_name)的头像")
    }
}
