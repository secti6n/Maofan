//
//  NavigationController.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/31.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit

class TabNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch tabBarItem.tag {
        case 1:
            viewControllers = [HomeViewController()]
        default:
            viewControllers = [TestViewController()]
        }
    }

}
