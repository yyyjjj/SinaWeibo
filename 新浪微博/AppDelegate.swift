//
//  AppDelegate.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/1.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        SetUpAppearence()
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = defaultViewController
        
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: WBSwitchVCControllerNotification), object: nil, queue: nil) {
            [weak self] (notification) in
            self!.window?.rootViewController = MainViewController()
        }
        return true
    }
    deinit {
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: WBSwitchVCControllerNotification), object: nil)
    }
    //一般全局渲染的设置都放在Appdelegate,要在控件创建前设置,否则修改无效
    func SetUpAppearence() {
        
        UINavigationBar.appearance().tintColor = appearenceColor
        
        UITabBar.appearance().tintColor = appearenceColor
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
//MARK: -界面切换代码
extension AppDelegate
{
    
    var defaultViewController : UIViewController{
        if UserAccountViewModel.shared.userLoginStatus{
            return isNewVersion ? NewFeatureCollectionViewController() : WelcomeViewController()
        }
        return MainViewController()
    }
    
    
    var isNewVersion : Bool {
        
       let currentversion = Double( Bundle.main.infoDictionary!["CFBundleShortVersionString"] as!  String )!
        
        let oldversionkey = "sandboxVersionKey"

       let oldversion = UserDefaults.standard.double(forKey: oldversionkey)
        
        UserDefaults.standard.set(currentversion, forKey: oldversionkey)
        
        return oldversion < currentversion
    }
}
