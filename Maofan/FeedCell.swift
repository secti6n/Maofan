//
//  FeedCell.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/20.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit
import YYText
import AsyncDisplayKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var label: YYLabel!
    @IBOutlet weak var photo: UIImageView!
    let photoNode = ASNetworkImageNode()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.highlightTapAction = { (view, attrString, range, rect) in
            let hightlight = attrString.attributedSubstring(from: range).attribute(YYTextHighlightAttributeName, at: 0, effectiveRange: nil)
            print((hightlight as! YYTextHighlight).userInfo!["urlString"] as! String)
        }
        photoNode.frame = CGRect(x: self.frame.width - 200, y: 0, width: 200, height: 200)
        self.addSubnode(photoNode)
        photoNode.contentMode = .scaleAspectFill
    }
    
    func config(feed: Feed) {
        feed.applyLayoutTo(label: label)
        photoNode.url = feed.photo
    }
    
    override func prepareForReuse() {
        photoNode.image = nil
        photoNode.animatedImage = nil
    }

}
