//
//  FeedCell.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/20.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit
import YYText
import YYWebImage

class FeedCell: BaseCell {
    
    @IBOutlet weak var label: YYLabel!
    @IBOutlet weak var photo: YYAnimatedImageView!
    static var whitespace: CGFloat = 20
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        photo.contentMode = .scaleAspectFit
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.highlightTapAction = { (view, attrString, range, rect) in
            let hightlight = attrString.attributedSubstring(from: range).attribute(YYTextHighlightAttributeName, at: 0, effectiveRange: nil)
            print((hightlight as! YYTextHighlight).userInfo!["urlString"] as! String)
        }
    }
    
    weak var feed: Feed? {
        didSet {
            if let feed = feed {
                feed.exportLayoutTo(label: label)
                photo.yy_imageURL = feed.photo
                label.frame.origin.y = FeedCell.whitespace
                photo.frame.origin.y = FeedCell.whitespace
                if feed.hasPhoto {
                    let diff = feed.feedTextHeight - 100
                    if diff > 0 {
                        photo.frame.origin.y += diff / 2
                    } else {
                        label.frame.origin.y -= diff / 2
                    }
                }
            }
        }
    }

}
