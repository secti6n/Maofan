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
    
    @IBOutlet weak var status: YYLabel!
    @IBOutlet weak var name: YYLabel!
    @IBOutlet weak var meta: YYLabel!
    @IBOutlet weak var avatar: YYAnimatedImageView!
    @IBOutlet weak var photo: YYAnimatedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Style.backgroundColor
        avatar.layer.cornerRadius = avatar.frame.width / 2
        status.highlightTapAction = { (view, attrString, range, rect) in
            print("---------------get")
            let hightlight = attrString.attributedSubstring(from: range).attribute(YYTextHighlightAttributeName, at: 0, effectiveRange: nil)
            print((hightlight as! YYTextHighlight).userInfo!["urlString"] as! String)
        }
        avatar.frame.origin.y = Style.whitespace
        status.frame.origin.y = Style.whitespace * (2 - 1 / 3)
        name.frame.origin.y = Style.whitespace
    }
    
    weak var feed: Feed? {
        didSet {
            guard let feed = feed else { return }
            feed.export(name: name)
            feed.export(status: status)
            feed.export(meta: meta)
            feed.export(photo: photo)
            feed.export(avatar: avatar)
        }
    }
    
    var isLabelAsync = true {
        didSet {
            meta.displaysAsynchronously = isLabelAsync
            name.displaysAsynchronously = isLabelAsync
            name.ignoreCommonProperties = isLabelAsync
            status.displaysAsynchronously = isLabelAsync
            status.ignoreCommonProperties = isLabelAsync
        }
    }

}
