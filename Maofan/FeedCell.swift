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
        
        avatar.frame.origin.x = Style.leftSpace
        avatar.frame.origin.y = Style.whitespace
        avatar.frame.size.width = Style.avatarSideLength
        avatar.frame.size.height = Style.avatarSideLength
        
        name.frame.origin.x = Style.leftSpace + Style.avatarSideLength + Style.avatarRightSpace
        name.frame.origin.y = Style.whitespace
        name.frame.size.width = Style.nameWidth
        name.frame.size.height = Style.avatarSideLength
        
        meta.frame.origin.x = Style.leftSpace + Style.avatarSideLength + Style.avatarRightSpace
        meta.frame.origin.y = Style.whitespace
        meta.frame.size.width = Style.nameWidth
        meta.frame.size.height = Style.avatarSideLength
        
        status.frame.origin.x = Style.leftSpace
        status.frame.origin.y = Style.avatarSideLength + Style.whitespace * (1 + 1 / 4)
        status.frame.size.width = Style.statusWidth
        
        photo.frame.size.height = Style.photoHeight
        
        avatar.layer.cornerRadius = Style.avatarSideLength / 2
        status.highlightTapAction = { (view, attrString, range, rect) in
            print("---------------get")
            let hightlight = attrString.attributedSubstring(from: range).attribute(YYTextHighlightAttributeName, at: 0, effectiveRange: nil)
            print((hightlight as! YYTextHighlight).userInfo!["urlString"] as! String)
        }
    }
    
    weak var feed: Feed? {
        didSet {
            guard let feed = feed else { return }
            feed.export(avatar: avatar)
            feed.export(name: name)
            feed.export(meta: meta)
            feed.export(status: status)
            feed.export(photo: photo)
            status.frame.size.height = feed.layout_status.textBoundingSize.height
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
