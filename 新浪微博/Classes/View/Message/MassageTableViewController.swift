//
//  MassageTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/3.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
var currenPage = 1
private let titleCellID = "titleCellID"
let backColor = UIColor.init(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1)

class MassageTableViewController: VisitorTableViewController {
    //MARK: - 生命周期
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccountViewModel.shared.userLoginStatus {
            self.navigationItem.title = "消息"
            visitorview?.SetUpInfo(imagename: "visitordiscover_image_message", text: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知。")
            return
        }
       self.navigationItem.title = nil
        //添加数据
        setUp()
        preparePageViewController()
        prepareTitleCollectionView()
        setFirstViewController()
    }
    //MAKR: - 控件布局
    func setUp()
    {
        titles = ["Notice","Massage"]
        
//            let tbv = UITableViewController.init()
//            if i == 0{
//             tbv.view.backgroundColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1)
//            tbv.tableView.isHidden = true
//            }else {
//            tbv.tableView.backgroundColor = backColor
//            }
            controllers.append(NotifyTableViewController())
            controllers.append(MessageTableViewController())
    }
    
    func preparePageViewController()
    {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        pageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
make.bottom.equalTo(self.view.snp.bottom).offset(self.tabBarController!.tabBar.bounds.size.height)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
    }
    func prepareTitleCollectionView()
    {
        self.navigationController?.view.addSubview(titleCollectionView)
        titleCollectionView.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth*0.6)
    make.height.equalTo(self.navigationController!.navigationBar.bounds.size.height)
        make.top.equalTo(self.navigationController!.navigationBar.snp.top)
        make.centerX.equalTo(self.navigationController!.view.snp.centerX)
}
        titleCollectionView.delegate = self
        titleCollectionView.dataSource = self
        titleCollectionView.register(TitleCollectionCell.self, forCellWithReuseIdentifier: titleCellID)
//        titleCollectionView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .centeredHorizontally, animated: true)
    }
    func setFirstViewController(){
        self.pageViewController.setViewControllers([controllers.last!], direction: .forward, animated: true, completion: nil)
    }
    //MARK: - 懒加载属性
    ///pageViewController
    lazy var pageViewController: UIPageViewController = {
        let pgvc = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing:0])
        return pgvc
    }()
    ///头部标题数组
    lazy var titles = [String]()
    ///控制器数组
    lazy var controllers = [UIViewController]()
    ///头部collectionView
    lazy var titleCollectionView : UICollectionView = {
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: TitleFlowLayout())
        cv.backgroundColor = .clear
        return cv
    }()
    ///头部collectionView的item布局
    private class TitleFlowLayout : UICollectionViewFlowLayout
    {
        override func prepare() {
            super.prepare()
            itemSize = CGSize.init(width: screenWidth*0.3, height: 30)
            scrollDirection = .horizontal
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            collectionView?.allowsMultipleSelection = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}

//MARK: - titleCollectionView代理
extension MassageTableViewController : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCellID, for: indexPath) as! TitleCollectionCell
        if currenPage == indexPath.row
        {
            cell.title.textColor = .orange
        }else
        {
            cell.title.textColor = .black
        }
        switch indexPath.row {
        case 0:
            cell.title.text = "Notice"
//            cell.backgroundColor = .randomColor
        case 1:
            cell.title.text = "Message"
//            cell.backgroundColor = .randomColor
        default:
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row > currenPage
        {currenPage = indexPath.row
            pageViewController.setViewControllers([controllers[currenPage]], direction: .forward, animated: true) { (_) in
                self.titleCollectionView.reloadData()
            }
        }else
        {
            currenPage = indexPath.row
            pageViewController.setViewControllers([controllers[currenPage]], direction: .reverse, animated: true) { (_) in
                self.titleCollectionView.reloadData()
            }
        }
    }
}
var pending = 0
//MARK: - pageViewController代理
extension MassageTableViewController : UIPageViewControllerDelegate,UIPageViewControllerDataSource
{
    
    //往前滚
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var index = controllers.firstIndex(of: viewController),index != 0 else {
            return nil
        }
        index -= 1
        return controllers[index]
    }
    //往后滚
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = controllers.firstIndex(of: viewController),index < titles.count-1 else{
            return nil
        }
        index += 1
        
        return controllers[index]
    }
    
    //准备开始动画 更新currentPage
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        pending = controllers.index(of: pendingViewControllers.first!)!
    }
    //动画完成，提醒titleCollectionView更新
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //判断是否真的有滚动到下一个界面
        if pageViewController.viewControllers!.first!.isEqual(previousViewControllers.first)
        {
            return
        }
        
        currenPage = pending
        titleCollectionView.scrollToItem(at: IndexPath.init(row: currenPage, section: 0), at: .centeredHorizontally, animated: true)
        titleCollectionView.reloadData()
        
    }
}


//MARK: - 自定义titleCell
class TitleCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    func setUpUI()
    {
        self.contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView.snp.center)
            make.height.equalTo(self.contentView.snp.height)
            make.width.equalTo(self.contentView.snp.width)
        }
    }
    lazy var title = UILabel.init(size: 16, content: "", color: .black, alignment: .center, lines: 1, breakMode: .byTruncatingTail)
}
