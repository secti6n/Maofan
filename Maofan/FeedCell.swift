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
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var photo: YYAnimatedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        photo.contentMode = .scaleAspectFit
        avatar.layer.cornerRadius = avatar.frame.width / 2
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.highlightTapAction = { (view, attrString, range, rect) in
            let hightlight = attrString.attributedSubstring(from: range).attribute(YYTextHighlightAttributeName, at: 0, effectiveRange: nil)
            print((hightlight as! YYTextHighlight).userInfo!["urlString"] as! String)
        }
    }
    
    weak var feed: Feed? {
        didSet {
            guard let feed = feed else { return }
            feed.exportLayoutTo(label: label)
            photo.yy_imageURL = feed.photo
            avatar.yy_imageURL = feed.user.avatar
            avatar.frame.origin.y = Style.whitespace
            label.frame.origin.y = Style.whitespace
            photo.frame.origin.y = Style.whitespace
        }
    }

}
