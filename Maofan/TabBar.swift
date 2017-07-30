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
        unselectedItemTintColor = Style.unSelect
        tintColor = Style.tintColor
        items?.forEach({ (item) -> () in
            item.title = nil
            let f = 6 - 1 / UIScreen.main.scale
            item.imageInsets = UIEdgeInsets(top: f, left: 0, bottom: -f, right: 0)
        })
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 44
        return sizeThatFits
    }
    
}
