//
//  AppNavigator.swift
//  RealmWrapperExample
//
//  Created by DongHeeKang on 20/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

final class AppNavigator {
    
    static let shared = AppNavigator()
    
    // MARK: - Internal methods
    
    func start(with window: UIWindow) {
        let controller = TableViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        window.rootViewController = navigationController
        window.backgroundColor = .white
        window.makeKeyAndVisible()
    }
    
}
