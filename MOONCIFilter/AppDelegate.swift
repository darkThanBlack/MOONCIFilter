//
//  AppDelegate.swift
//  MOONCIFilter
//
//  Created by 徐一丁 on 2023/6/21.
//

import UIKit
import DoraemonKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let mainVC = MainViewController()
        
        let nav = UINavigationController(rootViewController: mainVC)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        DoraemonManager.shareInstance().install(withPid: "73422655743e0c15bc7aff370d8485f5")
        
        return true
    }
}

