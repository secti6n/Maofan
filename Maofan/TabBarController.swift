//
//  TabBarController.swift
//  Maofan
//
//  Created by Catt Liu on 2017/1/1.
//  Copyright © 2017年 Catt Liu. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        print("TabBarController viewDidAppear should only call 1 time.")
        tabBar.cleanBlurBar()
        delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 3 {
            return false
        }
        return true
    }
    
}
