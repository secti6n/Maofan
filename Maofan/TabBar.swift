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
        items?.forEach({ (item) -> () in
            let f = 6 - 1 / UIScreen.main.scale
            item.imageInsets = UIEdgeInsets(top: f, left: 0, bottom: -f, right: 0)
            item.selectedImage = item.image?.imageWithColor(Style.tintColor).withRenderingMode(.alwaysOriginal)
            item.image = item.image?.imageWithColor(Style.unSelect).withRenderingMode(.alwaysOriginal)
        })
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 60
        return sizeThatFits
    }

}
