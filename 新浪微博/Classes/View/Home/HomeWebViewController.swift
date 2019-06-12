
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
    lazy var webView : WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self;
        return webView
    }()
    
    private var progressView : UIProgressView = {
        let proView = UIProgressView.init(frame: CGRect.init(x: 0, y: 44-2, width: UIScreen.main.bounds.width, height: 2))
        proView.trackTintColor = .white
        proView.progressTintColor = .orange
        return proView
    }()
    
    override func loadView() {
        view = webView
    }
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
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest.init(url: url))
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        self.navigationController?.navigationBar.addSubview(progressView)
        // Do any additional setup after loading the view.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let keyPath = keyPath else {
            return
        }
        
        if keyPath == "estimatedProgress"
        {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            progressView.isHidden = progressView.progress == 1
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    webView.removeObserver(self, forKeyPath:"estimatedProgress")
    }
    
    deinit {
        self.progressView.removeFromSuperview()
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

//webViewDelegate
extension HomeWebViewController : WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
          webView.evaluateJavaScript("document.title", completionHandler: { (data, error) in
//            print(data as! String)
//            if error != nil {
//                assert(true)
//            }
//            guard let data = data else{
//            return
//            }
           
            self.navigationItem.title = data as! String
        })
    }
}
