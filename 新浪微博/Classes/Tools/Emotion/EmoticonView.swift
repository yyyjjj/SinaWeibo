//
//  EmotionView.swift
//  表情键盘
//
//  Created by 梁华建 on 2019/4/6.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
let EmoticonCellID = "EmoticonCellID"
class EmoticonView: UIView {
 
    ///表情点击闭包
    private var didSelectEmoticonCallBack : (Emoticon) -> ()
    
    //MARK: - toolbar点击方法
    @objc func didClickToolBar(item:UIBarButtonItem)
    {
        let indexpath = IndexPath.init(item: 1, section: item.tag)
        collectionviews.scrollToItem(at: indexpath, at: .left, animated: true)
    }
    
    //MARK: - 懒加载控件
    lazy var collectionviews = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: EmoticonLayout())
    lazy var toolbar = UIToolbar()
    
    //MARK: - 控件初始化
    init(didSelectEmoticon:@escaping (Emoticon) -> ()) {
        
        didSelectEmoticonCallBack = didSelectEmoticon
        
        var size = CGRect.init()
        
        size.size.height = 226
        
        super.init(frame: size)
        
        self.backgroundColor = .red
        
        setupUI()
        //打开就滚到默认表情页
        let indexpath = IndexPath.init(item: 0, section: 1)
        
//        DispatchQueue.main.async
//        {
            self.collectionviews.scrollToItem(at: indexpath, at: .left, animated: true)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///表情包
    lazy var packages = EmoticonsViewModel.shared.packages
    
}
//MARK: - 布局视图
extension EmoticonView{
    
    func setupUI(){
        //1,添加控件
        addSubview(toolbar)
        addSubview(collectionviews)
        
        //2,自动布局
        collectionviews.snp.makeConstraints { (make) in
            //由于我们是至于inputview中，会自动匹配成键盘对应的宽度
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(toolbar.snp.top)
        }
        
        toolbar.snp.makeConstraints { (make) in
            //由于我们是至于inputview中，会自动匹配成键盘对应的宽度
            make.height.equalTo(44)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        //3,设置toolbar和kcollectionView的UI
        prepareToolbar()
        
        prepareCollectionView()
    }
    ///ToolBar的布局
    func prepareToolbar()  {
        
        var items = [UIBarButtonItem]()
        
        var tag = 0
        
        packages.forEach {
            items.append(UIBarButtonItem.init(title: $0.group_name_cn, style: .plain, target: self, action: #selector(didClickToolBar(item:))))
            items.last?.tag = tag
            
            tag += 1
            items.append(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: self, action: nil))
        }
        
        items.removeLast()
        
        toolbar.items = items
    }
    ///CollectionView的布局
    func prepareCollectionView() {
        collectionviews.dataSource = self
        collectionviews.delegate = self
        collectionviews.register(EmoticonCell.self, forCellWithReuseIdentifier: EmoticonCellID)
    }
    //MARK: - Collection的layout类
    ///自定义UICollectionViewFlowLayout，去完成CollectionView里面布局
    private class EmoticonLayout : UICollectionViewFlowLayout{
        //该方法会在第一次完成CollectionView布局的时候调用,自发的
        //官方建议我们重写该方法去完成item的布局。
        override func prepare() {
            super.prepare()
            let row : CGFloat = 3
            let col : CGFloat = 7
            let w = (collectionView!.bounds.width / col)
            itemSize = CGSize.init(width: w, height: w)
            let margin = (collectionView!.bounds.height - row*w) * 0.499
            sectionInset = UIEdgeInsets.init(top: margin, left: 0, bottom: margin, right: 0)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
            collectionView?.backgroundColor = .gray
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}
//MARK: - CollectionCell的dataSource和delegate方法
extension EmoticonView : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCellID, for: indexPath) as! EmoticonCell
        
//        cell.backgroundColor = .white
        cell.emoticon = packages[indexPath.section].emoticons[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //我们点击了该表情，要传值出去给外部
        didSelectEmoticonCallBack(packages[indexPath.section].emoticons[indexPath.row])
        //print("indexpath = \(indexPath)")
    }
}

//MARK: - Emoticon的自定义Cell
class EmoticonCell : UICollectionViewCell {
    
    var emoticon : Emoticon?{
        didSet
        {
            emoticonButton.setImage(UIImage.init(contentsOfFile: emoticon!.imagePath), for:.normal )
            //print(emoticon!.imagePath)
            
            emoticonButton.setTitle(emoticon?.emoji, for: .normal)
            
            emoticonButton.isUserInteractionEnabled = false //为什么不使用判断语句呢，如果使用了，我们就会复用其他的cell，而不进行判断我们就会把cell里面的text设为nil，把有值的设为没值，emoji是个optional属性
            //if emoticon?.emoji != nil{
            //}
            if emoticon!.isRemoved
            {
                emoticonButton.setImage(UIImage.init(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    //表情里的button
    var emoticonButton = UIButton()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupUI()
        //fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
        addSubview(emoticonButton)
        
        emoticonButton.setTitleColor(.black, for: .normal)
        
        emoticonButton.backgroundColor = .white
        
        let inset = CGRect.insetBy(self.bounds)
        
        //按钮上下左右间距是4,往中间挤
        emoticonButton.frame = inset(4, 4)
        
        emoticonButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
