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

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var name: YYLabel!
    @IBOutlet weak var story: YYLabel!
    @IBOutlet weak var photo: YYAnimatedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        story.displaysAsynchronously = true
        story.ignoreCommonProperties = true
        story.highlightTapAction = { (view, attrString, range, rect) in
            let hightlight = attrString.attributedSubstring(from: range).attribute(YYTextHighlightAttributeName, at: 0, effectiveRange: nil)
            print((hightlight as! YYTextHighlight).userInfo!["urlString"] as! String)
        }
    }
    
    func config(feed: Feed) {
        feed.exportLayoutTo(label: story)
        let url = feed.photo
        photo.yy_imageURL = url
        name.text = feed.name
    }

}
