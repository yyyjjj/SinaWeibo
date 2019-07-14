//
//  UserDetailViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/11.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
private let margin = 10
class UserDetailViewController: UIViewController {
    
    var statusViewModel : StatusViewModel?
    {
        didSet
        {
            headView.statusViewModel = statusViewModel
            tableView.statusViewModel = statusViewModel
        }
    }
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (categoryView.selectedIndex == 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pagingView.frame = self.view.bounds
    }
    //MARK: - 初始化控件和布局视图
    func setUpUI() {
        
        //1.添加控件
        self.view.addSubview(headView)
        self.view.addSubview(tableView)
      
        //2.自定义布局
//        tableView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.view.snp.top)
//            make.left.equalTo(self.view.snp.left)
//            make.width.equalTo(screenWidth)
//            make.height.equalTo(screenHeight)
//        }
        
        //3.设置控件
        tableView.scrollDelegate = self
        ///初始化分类视图
        prepareCategoryView()
        ///初始化分类下各容器视图
        preparePagingView()
    }
    
    func prepareCategoryView() {
        categoryView.titles = titles
        categoryView.backgroundColor = UIColor.white
        categoryView.titleSelectedColor = .orange
        categoryView.titleColor = .black
        categoryView.isTitleColorGradientEnabled = true
        categoryView.isTitleLabelZoomEnabled = true
        categoryView.delegate = self
        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorLineViewColor = .orange
        lineView.indicatorLineWidth = 30
        categoryView.indicators = [lineView]
        let lineWidth = 1/UIScreen.main.scale
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.lightGray
        bottomLineView.frame = CGRect(x: 0, y: categoryView.bounds.height - lineWidth, width: categoryView.bounds.width, height: lineWidth)
        bottomLineView.autoresizingMask = .flexibleWidth
        categoryView.addSubview(bottomLineView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
  
    }
    func preparePagingView()  {
        pagingView.mainTableView.gestureDelegate = self 
        
        self.view.addSubview(pagingView)
        
        categoryView.contentScrollView = pagingView.listContainerView.collectionView
        
       //防止他在右滑过程中pop出navigation栈
        pagingView.listContainerView.collectionView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
    }
    
    //MARK: - 懒加载控件
    //占屏幕高度比例0.377
    weak var nestContentScrollView: UIScrollView?
    
    lazy var headView : UserHeadView = {
        
        let uhv = UserHeadView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight*0.377))
        
        return uhv
    }()
    
    lazy var tableView: UserStatusTableView = {
        let tv = UserStatusTableView.init(frame: CGRect.zero, style: .plain)
        tv.backgroundColor = .clear
        return tv
    }()
    ///分类的视图 高度为屏幕高的0.074
    lazy var categoryView = JXCategoryTitleView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight*0.074))
    ///分类名称数组
    lazy var titles = ["Profile","Weibo","Album"]
    
    lazy var pagingView = JXPagingView.init(delegate: self)
    
    var isNeedHeader = false
    
    var isNeedFooter = false
    
}
extension UserDetailViewController : JXCategoryViewDelegate
{
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didClickedItemContentScrollViewTransitionTo index: Int){
        //请务必实现该方法
        //因为底层触发列表加载是在代理方法：`- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath`回调里面
        //所以，如果当前有5个item，当前在第1个，用于点击了第5个。categoryView默认是通过设置contentOffset.x滚动到指定的位置，这个时候有个问题，就会触发中间2、3、4的cellForItemAtIndexPath方法。
        //如此一来就丧失了延迟加载的功能
        //所以，如果你想规避这样的情况发生，那么务必按照这里的方法处理滚动。
        self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        
        
        //如果你想相邻的两个item切换时，通过有动画滚动实现。未相邻的两个item直接切换，可以用下面这段代码
        /*
         let diffIndex = abs(categoryView.selectedIndex - index)
         if diffIndex > 1 {
         self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
         }else {
         self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
         }
         */
    }
}

extension UserDetailViewController : JXPagingViewDelegate
{
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return Int(headView.bounds.height)
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return Int(categoryView.bounds.size.height)
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return categoryView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        
        let tableview = UserStatusTableView()
        tableview.statusViewModel = self.statusViewModel
        return tableview
    }

}

extension UserDetailViewController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //禁止Nest嵌套效果的时候，上下和左右都可以滚动
        if otherGestureRecognizer.view == nestContentScrollView {
            return false
        }
        //禁止categoryView左右滑动的时候，上下和左右都可以滚动
        if otherGestureRecognizer == categoryView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder())
    }
    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
//        let thresholdDistance: CGFloat = 100
//        var percent = scrollView.contentOffset.y/thresholdDistance
//        percent = max(0, min(1, percent))
//        self.navigationController?.navigationBar.alpha = percent
    }
}


//MARK: - scrollView的代理
extension UserDetailViewController :ScrollViewDelegate
{
    func tableViewDidScroll(offSet: CGPoint) {
        //0.0 -> 1
        //        self.bgImageView.alpha = -offSet.y/(screenHeight*0.377 + 20)
        //        self.bgImageView.snp.updateConstraints { (make) in
        //            make.height.equalTo(-offSet.y)
        //        }
    }
    
}
