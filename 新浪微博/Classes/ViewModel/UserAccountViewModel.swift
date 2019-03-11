//
//  UserAccountViewModel.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/9.
//  Copyright © 2019 梁华建. All rights reserved.
//

import Foundation


/*
 *MVVM
 *UserAccountViewModel:
 *封装业务逻辑
 *封装网络请求
 */

class UserAccountViewModel {
    
    static let shared = UserAccountViewModel()
    
    var account : UserAccount?
    ///true:已经登录登录 false:重新登录
    var userLoginStatus : Bool {
        return account?.access_token != nil && !isExpired
    }
    
    private var accountPath : URL{
        let path = URL.init(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!)
        return path.appendingPathComponent("account.plist")
    }
    
    private var isExpired : Bool{
        print("account?.expires_date = \(String(describing: account?.expiresDate)) Date() = \(Date())")
        return account?.expiresDate?.compare(Date()) == .orderedDescending ? false : true
    }
    
    private init() {
        
        print(accountPath.absoluteString)
        
        do {
            let data = try Data.init(contentsOf: accountPath)
            do{
                account = try NSKeyedUnarchiver.unarchivedObject(ofClass: UserAccount.self, from: data)
                if isExpired{
                    print("access_token 过期啦")
                    account = nil
                }
            }
            catch{
                assert(true, "用户数据解档失败")
            }
        } catch {
            assert(true, "用户数据解档路径错误")
        }
        //过期的解档方法
        //account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
}

//MARK: -封装网络请求
extension UserAccountViewModel {
    func loadAccessToken( code:String , finished: @escaping (_ isSuccess : Bool)->()){
        AFNetworkTool.sharedTool.LoadTokenAccess(code: code) { (data, error) in
            if error != nil{
                return
            }
            //kvc方法
            //            guard let dict = data as? [String : Any] else{
            //                print("格式错误")
            //                return
            //            }
            //            let account = UserAccount.init(dict: dict)
            
            //codable方法
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let json = try! JSONSerialization.data(withJSONObject: data!, options: [])
            self.account = try! decoder.decode(UserAccount.self, from: json )
            self.loadUserInfo(access_token: (self.account?.access_token)!, uid: (self.account?.uid)!, finished: finished)
        }
        
    }
    
    private func loadUserInfo(access_token:String,uid:String,finished : @escaping (_ isSuccess : Bool)->())  {
        AFNetworkTool.sharedTool.LoadUserInfo(access:access_token, uid: uid){ (data, error) in
            if error != nil
            {
                finished(false)
                return
            }
            guard let dict = data as? [String : Any] else{
                print("格式错误")
                finished(false)
                return
            }
            guard let account = self.account else{
                print("用户未初始化")
                finished(false)
                return
            }
            
            account.screen_name = dict["screen_name"] as? String
            account.avatar_large = dict["avatar_large"] as? String
           //把数据写入沙盒
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: account, requiringSecureCoding: false)
                do{
                    try data.write(to: self.accountPath)
                    print(self.accountPath)
                }
                catch{
                    assert(true, "无法把account写入path")
                }
            }catch{
                assert(true, "无法生成归档数据")
            }
            finished(true)
        }
    }
}
