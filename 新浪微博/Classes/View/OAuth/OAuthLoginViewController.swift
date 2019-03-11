//
//  OAuthLoginViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/6.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import WebKit
class OAuthLoginViewController: UIViewController {
    ///加载WebView界面
    lazy var webView = WKWebView()
    
    override func loadView() {
        view = webView
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action: #selector(Close))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "自动填充", style: .plain, target: self, action: #selector(AutoFill))
        webView.navigationDelegate = self
    }
    ///关闭页面
    @objc func Close(){
        dismiss(animated: true, completion: nil)
    }
    ///自动填充
    @objc func AutoFill(){
        let js = "document.getElementById('userId').value = '13113771561';document.getElementById('passwd').value = 'Jb153297'"
        webView.evaluateJavaScript(js)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWebView()
    }
    
    func setWebView() {
        
        webView.frame = UIScreen.main.bounds
        
        webView.load(URLRequest.init(url: AFNetworkTool.sharedTool.loadOAuth))
        
    }
    
}
// MARK: -WKNavigationDelegate方法 拦截webView跳转
extension OAuthLoginViewController : WKNavigationDelegate
{
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url else{
            print("GetCanceld")
            decisionHandler(.cancel)
            return
        }
        guard let host = url.host , host == "www.baidu.com" else{
            print("Still success")
            decisionHandler(.allow)
            return
        }
        guard let query = url.query , query.hasPrefix("code=") else{
            decisionHandler(.cancel)
            return
        }
        //授权码获取
        let code = query.substring(fromIndex: "code=".count)
        
        UserAccountViewModel.shared.loadAccessToken(code: code) { (isSuccess) in
            if isSuccess{
                print("account = \(UserAccountViewModel.shared.account?.avatar_large)")
            }else{
                print("没有加载到用户错误")
            }
        }
        
        decisionHandler(.cancel)
        
    }
}

