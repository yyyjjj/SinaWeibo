//
//  StatusPictureView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/26.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SDWebImage
let pictureMargins : CGFloat = 8
let CollectionViewCellID = "CollectionViewCellID"

class StatusPictureView: UICollectionView {
    var viewModel : StatusViewModel?
    {
        didSet{
            sizeToFit()
            //如果不reloadData cell会被重用，不会去调用dataSource方法
            reloadData()
        }
    }
    ///sizeToFits内部会调用
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return caculateSize()
    }
    
    init()
    {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = pictureMargins
        layout.minimumInteritemSpacing = pictureMargins
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        //设置自己为数据源，比较小的自定义视图
        dataSource = self
        register(PictrueViewCell.self, forCellWithReuseIdentifier: CollectionViewCellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK :- 计算总图片宽高
extension StatusPictureView
{
    ///通过图片数量 计算大小
    func caculateSize() ->CGSize
    {
        let column : CGFloat = 3
        
        let count = viewModel?.thumbnails?.count ?? 0
        //print("viewModel?.thumbnails?.count = \(viewModel?.thumbnails?.count)")
        if count == 0 {return CGSize.zero}
        
        let itemwidth = ((UIScreen.main.bounds.size.width - 2 * StatusCellMargins)-2*pictureMargins)/3
        //拿到collectionItem 把他们都设置成正方形
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize.init(width: itemwidth, height: itemwidth)
        
        //1,一张图片的时候特殊处理
        if count == 1 {
            var size = CGSize.init(width: 150, height: 120)
            //key是URL的绝对地址 使用MD5加密
            if let url = viewModel?.thumbnails?.first?.absoluteString {
                if let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: url)
                {
                size = image.size
                }
            }
            //过窄图片
            size.width = size.width < 40 ? 40 : size.width
            //过宽图片
            if size.width > 300{
                let w : CGFloat = 300
                let h = size.height * w / size.width
                size = CGSize(width: w, height: h)
            }
            layout.itemSize = size
            
            return size
        }
        
        let row = CGFloat((count - 1)/Int(column) + 1)
        
        //2,4张图片的时候显示上下各两个pic
        if count == 4 {
            let w = itemwidth*2+pictureMargins
            return CGSize.init(width: w, height: w)
        }
        
        //3,其他count
        
        let h = row * itemwidth + (row-1)*pictureMargins
        
        let w = column * itemwidth + (column-1)*pictureMargins
        
        //        print("H = \(h) ----------------------------------- W = \(w)")
        
        return CGSize.init(width: w, height: h)
        
    }
}

extension StatusPictureView :UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnails?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:CollectionViewCellID , for: indexPath) as! PictrueViewCell
        
        cell.imageURL = viewModel!.thumbnails![indexPath.item]
        //cell.backgroundColor = UIColor.red
        return cell
        
    }
    
}

///MARK :-图片cell
private class PictrueViewCell: UICollectionViewCell {
    var imageURL : URL?{
        didSet{
            iconView.sd_setImage(with: imageURL!, placeholderImage: nil, options: [SDWebImageOptions.retryFailed    //超过15s就记录防止再次访问
                ,SDWebImageOptions.refreshCached  //防止URL不变数据源变了，及时更新
                ], completed: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(iconView)
        //cell会改变
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp.edges)
        }
    }
    //懒加载要指明类型，否则其他地方调用不清楚其属性
    private lazy var iconView : UIImageView = {
        
        let iv =  UIImageView()
        //多出来的裁减掉，留中间
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
}
