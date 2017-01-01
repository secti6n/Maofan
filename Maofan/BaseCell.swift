//
//  BaseCell.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/31.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit
import YYText
import YYWebImage

class BaseCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView.backgroundColor = Style.backgroundColorTouch
        self.selectedBackgroundView = selectedBackgroundView
    }
    
}

