
//
//  HomeWebViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/29.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import WebKit
class HomeWebViewController: UIViewController {
    //MARK: - 懒加载控件
    lazy var webView = WKWebView()
    
    var url : URL
    //MARK: - 初始化
    init(url:URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //系统在发现view为nil的时候会调用该方法
    override func loadView() {
        view = webView
        title = "网页"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest.init(url: url)
        )
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
