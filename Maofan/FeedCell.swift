//
//  FeedCell.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/20.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit
import YYText

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var label: YYLabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.highlightTapAction = { (view, attrString, range, rect) in
            let hightlight = attrString.attributedSubstring(from: range).attribute(YYTextHighlightAttributeName, at: 0, effectiveRange: nil)
            print((hightlight as! YYTextHighlight).userInfo!["urlString"] as! String)
        }
    }
    
    func config(feed: Feed) {
        feed.applyLayoutTo(label: label)
        let url = feed.photo
//        photo.sd_setImage(with: url)
        photo.pin_setImage(from: url)
    }

}
