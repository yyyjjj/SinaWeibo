//
//  AFNetworkTool.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/5.
//  Copyright © 2019 梁华建. All rights reserved.
//

import Foundation
import Alamofire

enum HttpRequestMethod {
    case GET
    case POST
}

//网络单例
class NetworkTool
{
    private static let AppKey = "3769036694"
    
    private static let AppSecret = "77edccfe16cda52369e833a7672033c3"
    
    private static let reDirectUrl = "https://www.baidu.com"
    
    typealias completion = (Any?,Error?)->Void
    
//    private static var tokenDict : [String:Any]?
//    {
//        guard let token = UserAccountViewModel.shared.accessToken else {
//            return nil
//        }
//        return ["access_token":token]
//    }
    
    static var sharedTool = NetworkTool()
    
    lazy var loadOAuth : URL = {
        let url = URL.init(string:  "https://api.weibo.com/oauth2/authorize?client_id=\(NetworkTool.AppKey)&redirect_uri=\(NetworkTool.reDirectUrl)")
       
        return url!
    }()
}

//MARK: - 获取用户信息
extension NetworkTool
{
    func LoadUserInfo(uid:String,success:@escaping completion)  {
        
//        guard var params = AFNetworkTool.tokenDict else{
//            success(nil, NSError(domain:"cn.itcast.error",code:-1001,userInfo:["message":"token 为空"]))
//            return
//        }
        var params = [String : Any]()
        
        let urlStrings = "https://api.weibo.com/2/users/show.json"
        
        params["uid"] = uid
        
        tokenRequest(RequestMethod: .get, URLString: urlStrings, parameters: params, progress: nil) { (result, error) -> (Void) in
            if error != nil{
                assert(true, "在通过access_token和uid获取用户数据的时候出现错误")
            }
            success(result, nil)
         }
        
    }
}

//MARK: - 发送微博
extension NetworkTool{
    
    /// 发布微博
    ///
    /// - Parameters:
    ///   - content: 发布微博的内容，要求图文混排
    ///   - finished: 完成的回调
    /// see:
    func postStatus(content : String,image: UIImage?,finished :@escaping completion)
    {
//        guard var params = AFNetworkTool.tokenDict else{
//            finished(nil, NSError(domain:"cn.itcast.error",code:-1001,userInfo:["message":"token 为空"]))
//            return
//        }
        var params = [String : Any]()
        
        params["status"] = content
        
        if image == nil {
            let url = "https://api.weibo.com/2/statuses/update"
            
            tokenRequest(RequestMethod: .post, URLString: url, parameters: params, progress: nil) { (response, error) in
                finished(response,error)
            }
        }else{
            let url = "https://api.weibo.com/2/statuses/upload"
            
            let data = image!.pngData()!
            //name注意是图片名称
            upload(URLString: url, data: data, name: "pic", parameters: params, progress: nil, finished: finished)
        }
        
    }
}

//MARK: - 获取用户关注的动态
extension NetworkTool{
    
    /// 加载微博数据
    /// - Parameter since_id:若指定此参数，下拉的话返回since_id大于原来数据最新的数据，默认是0
    /// - Parameter max_id:若指定此参数，上拉的话返回max_id小于等于原来数据最新的数据,默认是0
    /// - Parameter finished: 成功与否
    /// - [查看接口返回key详情](https://open.weibo.com/wiki/2/statuses/home_timeline)
    func LoadStatus(since_id : Int , max_id : Int,finished:@escaping completion){
//        guard var params = AFNetworkTool.tokenDict else{
//            finished(nil, NSError(domain:"cn.itcast.error",code:-1001,userInfo:["message":"token 为空"]))
//            return
//        }
        
        var params = [String : Any]()
        
        if since_id != 0 {
            params["since_id"] = since_id
        }
        else if
            max_id != 0{
            //防止获得一样的数据,微博提供的接口是返回小于或等于的数据
            params["max_id"] = max_id-1
        }
        
        let urlStrings = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        tokenRequest(RequestMethod: .get, URLString: urlStrings, parameters: params, progress: nil, finished: finished)
    }
    
}

//MARK: - 获取accesst_token
extension NetworkTool
{
    func LoadTokenAccess(code : String , success : @escaping completion)
    {

        var paras = ["client_id":NetworkTool.AppKey,
                     "client_secret":NetworkTool.AppSecret,
                     "grant_type":"authorization_code",
                     "code":code,
                     "redirect_uri":NetworkTool.reDirectUrl]
        
        request(RequestMethod: .post, URLString: "https://api.weibo.com/oauth2/access_token", parameters: paras, progress: nil, finished: success)
    }
}


//MARK: - 封装AFNetwork请求方法
extension NetworkTool{
    
    func appendToken(parameters :inout [String:Any]?) -> Bool {
        guard let token = UserAccountViewModel.shared.accessToken else {
            
            return false
        }
        
        if parameters == nil
        {
            parameters = [String : Any]()
        }
        
        parameters!["access_token"] = token
        
        return true
    }
    
    /// token网络请求
    ///
    /// - Parameters:
    ///   - RequestMethod: GET/POST
    ///   - URLString: 请求的URL地址
    ///   - parameters: POST的参数
    ///   - progress: 请求过程补抓
    ///   - success: 成功回调
    func tokenRequest(RequestMethod : HTTPMethod,URLString : String, parameters : [String : Any]? , progress :((Progress)->Void)? , finished : @escaping (completion)){
        
        var para = parameters
        
        if !appendToken(parameters: &para){
            finished(nil,NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message":"token为空"]))
        }
        request(RequestMethod: RequestMethod, URLString: URLString, parameters: para, progress: progress, finished: finished)
    }
    
    
    /// 网络请求
    ///
    /// - Parameters:
    ///   - RequestMethod: GET/POST
    ///   - URLString: 请求的URL地址
    ///   - parameters: POST的参数
    ///   - progress: 请求过程补抓
    ///   - success: 成功回调
    func request(RequestMethod : HTTPMethod,URLString : String, parameters :  [ String : Any]? , progress :((Progress)->Void)? , finished : @escaping (completion)){
        
        Alamofire.request(URLString, method: RequestMethod, parameters: parameters).responseJSON { (response) in
            
            if response.error != nil{
               finished(nil,response.error!)
                return
            }
            if response.result.isFailure{
                finished(nil,response.error!)
                return
            }
            //获得序列化数据(字典数组)
//            guard let result = response.result as? [String : Any] else
//            {
//                finished(nil,response.error)
//                return
//            }
//            print(response.result)
            finished(response.result.value,response.error)
            
        }
        
//        成功闭包
//        let success = { (_ result: URLSessionDataTask?,_ responseobject: Any?) ->Void in
//            finished(responseobject,nil)
//        }
//        //失败闭包
//        let failture = { (_ result: URLSessionDataTask?,_ error: Error?) ->Void in
//            finished(nil,error)
//        }
//
//        if RequestMethod == .GET
//        {
//            get(URLString, parameters: parameters,progress : progress,success: success, failure: failture)
//        }
//        else
//        {
//            post(URLString, parameters: parameters, progress: progress, success: success, failure: failture)
//        }
    }
    
    func upload(URLString : String, data: Data ,name : String, parameters : [ String : Any]? , progress :((Progress)->Void)? , finished : @escaping (completion))
    {
         var para = parameters
        
        if !appendToken(parameters: &para)
        {
            finished(nil,NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message":"token为空"]))
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            //告诉服务器二进制流类型
            multipartFormData.append(data, withName: "xxx", mimeType: "application/octet-stream")
            //我们还需要拼接para到url上 如下
            if let parameters = parameters{
                for (k,v) in parameters
                {
                    let str = v as! String
                    let strData = str.data(using: .utf8)!
                    multipartFormData.append(strData, withName: k)
                }
            }
            
        }, to: URLString) {  encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
            }
        }
//        post(URLString, parameters: para, constructingBodyWith: { (formData) in
//            //name服务器定义的字段名字，有点像access_token那种
//            //filename:http协议定义的属性
//            //application/octer-stream:告诉服务器这是一个字节流二进制，不知道准确类型
//            formData.appendPart(withFileData: data, name: name, fileName: "aaa", mimeType: "application/octer-stream")
//        }, progress: progress, success: { (_, result) in
//            finished(result,nil)
//        }) { (_, error) in
//            print("error")
//            finished(nil,error)
//
//        }
    
}

