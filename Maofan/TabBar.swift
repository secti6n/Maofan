//
//  TabBar.swift
//  Maofan
//
//  Created by Catt Liu on 2017/1/1.
//  Copyright © 2017年 Catt Liu. All rights reserved.
//

import UIKit

class TabBar: UITabBar {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }

}
