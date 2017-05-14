//
//  FeedCellNode.swift
//  Maofan
//
//  Created by Catt Liu on 2017/5/12.
//  Copyright © 2017年 Catt Liu. All rights reserved.
//


import UIKit
import AsyncDisplayKit

let kLinkAttributeName = "mf_NodeLinkAttributeName"
let kAvatar: CGFloat = 48
let kPadding: CGFloat = 18
let kSpacing: CGFloat = 3
let kSpacingL: CGFloat = 9
let kCorner: CGFloat = 4

class FeedCellNode: ASCellNode {
    
    let avatarNode = ASNetworkImageNode()
    let nameNode = ASTextNode()
    let textNode = ASTextNode()
    let metaNode = ASTextNode()
    let photoNode = ASNetworkImageNode()
    var hasPhoto = false
    
    required init(with feed : Feed) {
        super.init()
        hasPhoto = feed.hasPhoto
        //
        avatarNode.url = feed.user.avatar
        avatarNode.style.preferredSize = CGSize(width: kAvatar, height: kAvatar)
        avatarNode.cornerRadius = kAvatar / 2
        avatarNode.clipsToBounds = true
        addSubnode(avatarNode)
        //
        nameNode.attributedText = NSAttributedString(string: feed.user.name, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)])
        addSubnode(nameNode)
        //
        metaNode.attributedText = NSAttributedString(string: feed.time, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: Style.metaColor])
        addSubnode(metaNode)
        //
        textNode.linkAttributeNames = [kLinkAttributeName]
        textNode.attributedText = feed.feedAttr
        textNode.isUserInteractionEnabled = true
        addSubnode(textNode)
        //
        photoNode.url = feed.photo
        photoNode.cornerRadius = kCorner
        photoNode.clipsToBounds = true
        addSubnode(photoNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let nameMeta = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .baselineLast, children: [nameNode, metaNode])
        nameMeta.style.width = ASDimensionMake("100%")
        let photo = ASRatioLayoutSpec(ratio: 0.6, child: photoNode)
        let text = ASStackLayoutSpec(direction: .vertical, spacing: kSpacing, justifyContent: .start, alignItems: .start, children: [nameMeta, textNode])
        text.style.width = ASDimensionMake("100%")
        let afterAvatar = ASStackLayoutSpec(direction: .vertical, spacing: kSpacingL, justifyContent: .start, alignItems: .start, children: hasPhoto ? [text, photo] : [text])
        afterAvatar.style.width = ASDimensionMake("100%")
        afterAvatar.style.flexShrink = 1
        let feed = ASStackLayoutSpec(direction: .horizontal, spacing: kSpacingL, justifyContent: .center, alignItems: .start, children: [avatarNode, afterAvatar])
        feed.style.width = ASDimensionMake("100%")
        let cell = ASInsetLayoutSpec(insets: UIEdgeInsets(top: kPadding, left: kPadding, bottom: kPadding, right: kPadding), child: feed)
        cell.style.width = ASDimensionMake("100%")
        return cell
    }
    
}
