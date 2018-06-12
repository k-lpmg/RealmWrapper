//
//  AppDelegate.swift
//  RealmWrapperExample
//
//  Created by DongHeeKang on 2018. 6. 10..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        let controller = TableViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        window.rootViewController = navigationController
        self.window = window
        
        return true
    }

}

