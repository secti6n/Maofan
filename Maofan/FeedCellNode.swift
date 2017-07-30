//
//  FeedCellNode.swift
//  Maofan
//
//  Created by Catt Liu on 2017/5/12.
//  Copyright © 2017年 Catt Liu. All rights reserved.
//


import UIKit
import AsyncDisplayKit
import PINRemoteImage

let kLinkAttributeName = "mf_NodeLinkAttributeName"
let kAvatar: CGFloat = 48
let kCorner: CGFloat = 4

protocol FeedCellNodeDelegate: class {
    
    func reload(feed: Feed)
    
}

class FeedCellNode: ASCellNode {
    
    weak var delegate: FeedCellNodeDelegate?
    var feed: Feed!
    
    let avatarNode = ASNetworkImageNode()
    let nameNode = ASTextNode()
    let textNode = ASTextNode()
    let metaNode = ASTextNode()
    let photoNode = ASNetworkImageNode()
    var hasPhotoCache = false
    let lineNode = ASDisplayNode()
    
    required init(with feed : Feed) {
        super.init()
        self.feed = feed
        avatarNode.url = feed.user.avatar
        avatarNode.style.preferredSize = CGSize(width: kAvatar, height: kAvatar)
        avatarNode.cornerRadius = kCorner
        avatarNode.clipsToBounds = true
        addSubnode(avatarNode)
        //
        nameNode.attributedText = NSAttributedString(string: feed.user.name, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)])
        addSubnode(nameNode)
        //
        metaNode.attributedText = NSAttributedString(string: feed.feedTime, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light), NSAttributedStringKey.foregroundColor: Style.metaColor])
        addSubnode(metaNode)
        //
        textNode.linkAttributeNames = [kLinkAttributeName]
        textNode.attributedText = feed.feedAttr
        textNode.isUserInteractionEnabled = true
        addSubnode(textNode)
        //
        if let url = feed.photo {
            if let image = PINRemoteImageManager.shared().synchronousImageFromCache(with: url, processorKey: nil).image {
                self.hasPhotoCache = true
                photoNode.url = url
                photoNode.style.preferredSize = CGSize(width: image.size.width / 3, height: image.size.height / 3)
            } else {
                PINRemoteImageManager.shared().downloadImage(with: url, processorKey: nil, processor: nil, progressDownload: nil, completion: { (result) in
                    if nil != result.image {
                        self.delegate?.reload(feed: self.feed)
                    }
                })
            }
            photoNode.style.preferredSize = CGSize(width: 0, height: 0)
            photoNode.clipsToBounds = true
            addSubnode(photoNode)
        }
        //
        lineNode.backgroundColor = Style.borderColor
        lineNode.style.width = ASDimensionMake("100%")
        lineNode.style.height = ASDimensionMake(1 / UIScreen.main.scale)
        addSubnode(lineNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let nameMeta = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .baselineFirst, children: [nameNode, metaNode])
        nameMeta.style.width = ASDimensionMake("100%")
        let text = ASStackLayoutSpec(direction: .vertical, spacing: 3, justifyContent: .start, alignItems: .start, children: [nameMeta, textNode])
        text.style.width = ASDimensionMake("100%")
        let afterAvatar = ASStackLayoutSpec()
        afterAvatar.direction = .vertical
        afterAvatar.spacing = 12
        if hasPhotoCache {
            afterAvatar.children = [text, photoNode]
        } else {
            afterAvatar.children = [text]
        }
        afterAvatar.style.width = ASDimensionMake("100%")
        afterAvatar.style.flexShrink = 1
        let feed = ASStackLayoutSpec(direction: .horizontal, spacing: 9, justifyContent: .center, alignItems: .start, children: [avatarNode, afterAvatar])
        feed.style.width = ASDimensionMake("100%")
        let content = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12), child: feed)
        content.style.width = ASDimensionMake("100%")
        return content
    }
    
}
