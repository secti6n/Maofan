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

let kLinkAttributeName = NSAttributedStringKey(rawValue: "mf_NodeLinkAttributeName")
let nicePhotoWidth = UIScreen.main.bounds.width - 2 * (18 + 48 + 9)

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
    private var photoSize: CGSize!
    let lineNode = ASDisplayNode()
    
    required init(with feed : Feed) {
        super.init()
        self.feed = feed
        avatarNode.url = feed.user.avatar
        avatarNode.style.preferredSize = CGSize(width: 48, height: 48)
        avatarNode.cornerRadius = 4
        avatarNode.clipsToBounds = true
        addSubnode(avatarNode)
        //
        nameNode.attributedText = NSAttributedString(string: feed.user.name, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium), .foregroundColor: Style.plainColor])
        addSubnode(nameNode)
        //
        metaNode.attributedText = NSAttributedString(string: feed.feedTime, attributes: [.font: UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.regular), .foregroundColor: Style.metaColor])
        addSubnode(metaNode)
        //
        textNode.linkAttributeNames = [kLinkAttributeName.rawValue]
        textNode.attributedText = feed.feedAttr
        textNode.isUserInteractionEnabled = true
        addSubnode(textNode)
        //
        if let url = feed.photo {
            if let image = PINRemoteImageManager.shared().synchronousImageFromCache(with: url, processorKey: nil).image {
                if image.size.width / 2 > nicePhotoWidth {
                    photoSize = CGSize(width: nicePhotoWidth, height: min(nicePhotoWidth * 2, nicePhotoWidth / image.size.width * image.size.height))
                } else if image.size.width < nicePhotoWidth {
                    photoSize = CGSize(width: nicePhotoWidth / 2, height: min(nicePhotoWidth * 2, nicePhotoWidth / 2 / image.size.width * image.size.height))
                } else {
                    photoSize = CGSize(width: image.size.width / 2, height: min(nicePhotoWidth * 2, image.size.height / 2))
                }
                photoNode.url = url
            } else {
                photoSize = CGSize(width: 72, height: 72)
                PINRemoteImageManager.shared().downloadImage(with: url, processorKey: nil, processor: nil, progressDownload: nil, completion: { (result) in
                    if let image = result.image {
                        self.photoNode.image = image
                        self.delegate?.reload(feed: self.feed)
                    }
                })
            }
            photoNode.style.preferredSize = CGSize(width: 0, height: 0)
            photoNode.backgroundColor = Style.borderColor
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
        let content = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [nameMeta, textNode])
        textNode.style.spacingBefore = 3
        if self.feed.hasPhoto {
            photoNode.style.preferredSize = photoSize
            content.children?.append(photoNode)
            photoNode.style.spacingBefore = 9
        }
        let afterAvatar = ASStackLayoutSpec(direction: .vertical, spacing: 18 - 1 / UIScreen.main.scale, justifyContent: .start, alignItems: .start, children: [ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18), child: content), lineNode])
        let body = ASStackLayoutSpec(direction: .horizontal, spacing: 9, justifyContent: .start, alignItems: .start, children: [avatarNode, afterAvatar])
        nameMeta.style.width = ASDimensionMake("100%")
        content.style.width = ASDimensionMake("100%")
        afterAvatar.style.width = ASDimensionMake("100%")
        afterAvatar.style.flexShrink = 1
        body.style.width = ASDimensionMake("100%")
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 18, left: 18, bottom: 0, right: 0), child: body)
    }
    
}
