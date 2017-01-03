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
        avatar.frame.size = CGSize(width: Style.avatarSideLength, height: Style.avatarSideLength)
        name.frame.size.height = Style.avatarSideLength
        meta.frame.size.height = Style.avatarSideLength
        avatar.frame.origin.y = Style.whitespace
        name.frame.origin.y = Style.whitespace
        meta.frame.origin.y = Style.whitespace
        status.frame.origin.y = avatar.frame.maxY + Style.whitespace / 4
        photo.frame.size.height = Style.photoHeight
    }
    
    weak var feed: Feed? {
        didSet {
            guard let feed = feed else { return }
            feed.export(avatar: avatar)
            feed.export(name: name)
            feed.export(meta: meta)
            feed.export(status: status)
            feed.export(photo: photo)
            status.frame.size = feed.layout_status.textBoundingSize
            photo.frame.origin.y = status.frame.maxY + Style.whitespace / 2
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
