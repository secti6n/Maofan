//
//  TabBarController.swift
//  Maofan
//
//  Created by Catt Liu on 2017/1/1.
//  Copyright © 2017年 Catt Liu. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var isCleanBlurBar = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isCleanBlurBar {
            tabBar.cleanBlurBar()
            isCleanBlurBar = true
        }
    }

}
