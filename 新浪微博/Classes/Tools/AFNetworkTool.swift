//
//  AFNetworkTool.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/5.
//  Copyright © 2019 梁华建. All rights reserved.
//

import Foundation
import AFNetworking

enum HttpRequestMethod {
    case GET
    case POST
}

//网络单例
class AFNetworkTool : AFHTTPSessionManager
{
    private static let AppKey = "3769036694"
    
    private static let AppSecret = "77edccfe16cda52369e833a7672033c3"
    
    private static let reDirectUrl = "https://www.baidu.com"
    
    typealias completion = (Any?,Error?)->Void
    
    static var sharedTool : AFNetworkTool = {
        let tool = AFNetworkTool()
        return tool
    }()
    lazy var loadOAuth : URL = {
        let url = URL.init(string:  "https://api.weibo.com/oauth2/authorize?client_id=\(AFNetworkTool.AppKey)&redirect_uri=\(AFNetworkTool.reDirectUrl)")
       
        return url!
    }()
}
//MARK: -获取用户信息
extension AFNetworkTool
{
    func LoadUserInfo(access:String,uid:String,success:@escaping completion)  {
        
        let urlStrings = "https://api.weibo.com/2/users/show.json"
        
        let params = ["uid":uid,
                      "access_token":access
                      ]
        
        request(RequestMethod: .GET, URLString: urlStrings, parameters: params, progress: nil) { (result, error) -> (Void) in
            if error != nil{
                assert(true, "在通过access_token和uid获取用户数据的时候出现错误")
            }
            success(result, nil)
         }
        
        
    }
}

//MARK: -获取accesst_token
extension AFNetworkTool
{
    func LoadTokenAccess(code : String , success : @escaping completion)
    {

        let paras = ["client_id":AFNetworkTool.AppKey,
                     "client_secret":AFNetworkTool.AppSecret,
                     "grant_type":"authorization_code",
                     "code":code,
                     "redirect_uri":AFNetworkTool.reDirectUrl]
        
        request(RequestMethod: .POST, URLString: "https://api.weibo.com/oauth2/access_token", parameters: paras, progress: nil, finished: success)
    }
}


//MARK: -封装AFNetwork请求方法
extension AFNetworkTool{
    
    /// 网络请求
    ///
    /// - Parameters:
    ///   - RequestMethod: GET/POST
    ///   - URLString: 请求的URL地址
    ///   - parameters: POST的参数
    ///   - progress: 请求过程补抓
    ///   - success: 成功回调
    func request(RequestMethod : HttpRequestMethod,URLString : String, parameters :  Any? , progress :((Progress)->Void)? , finished : @escaping (completion)){
        //成功闭包
        let success = { (_ result: URLSessionDataTask?,_ responseobject: Any?) ->Void in
            finished(responseobject,nil)
        }
        //失败闭包
        let failture = { (_ result: URLSessionDataTask?,_ error: Error?) ->Void in
            finished(nil,error)
        }
        
        if RequestMethod == .GET
        {
            get(URLString, parameters: parameters,progress : progress,success: success, failure: failture)
        }
        else
        {
            post(URLString, parameters: parameters, progress: progress, success: success, failure: failture)
        }
    }
}

