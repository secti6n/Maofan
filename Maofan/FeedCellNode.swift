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
let nicePhotoWidth = UIScreen.main.bounds.width - 2 * (16 + 48 + 8)

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
    let photoContainerNode = ASDisplayNode()
    let photoNode = ASNetworkImageNode()
    private var photoSize: CGSize?
    
    override func didExitVisibleState() {
        metaNode.attributedText = NSAttributedString(string: feed.feedTime, attributes: [.font: UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular), .foregroundColor: Style.metaColor])
    }
    
    required init(with feed : Feed) {
        super.init()
        backgroundColor = .white
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
        metaNode.attributedText = NSAttributedString(string: feed.feedTime, attributes: [.font: UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular), .foregroundColor: Style.metaColor])
        addSubnode(metaNode)
        //
        textNode.linkAttributeNames = [kLinkAttributeName.rawValue]
        textNode.attributedText = feed.feedAttr
        textNode.isUserInteractionEnabled = true
        addSubnode(textNode)
        //
        photoContainerNode.clipsToBounds = true
        addSubnode(photoContainerNode)
        photoContainerNode.addSubnode(photoNode)
        if let url = feed.photo {
            if let image = PINRemoteImageManager.shared().synchronousImageFromCache(with: url, processorKey: nil).image {
                if image.size.width / 2 > nicePhotoWidth {
                    photoSize = CGSize(width: nicePhotoWidth, height: nicePhotoWidth / image.size.width * image.size.height)
                } else if image.size.width < nicePhotoWidth {
                    photoSize = CGSize(width: nicePhotoWidth / 2, height: nicePhotoWidth / 2 / image.size.width * image.size.height)
                } else {
                    photoSize = CGSize(width: image.size.width / 2, height:  image.size.height / 2)
                }
                photoNode.url = url
            } else {
                PINRemoteImageManager.shared().downloadImage(with: url, processorKey: nil, processor: nil, progressDownload: nil, completion: { (result) in
                    if let _ = result.image {
                        self.delegate?.reload(feed: self.feed)
                    }
                })
            }
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let nameMeta = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .baselineFirst, children: [nameNode, metaNode])
        let content = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [nameMeta, textNode])
        textNode.style.spacingBefore = 3
        if let photoSize = photoSize {
            photoContainerNode.style.preferredSize = photoSize
            photoContainerNode.style.maxHeight = ASDimensionMake(nicePhotoWidth * 1.5)
            photoNode.frame = CGRect(origin: .zero, size: photoSize)
            content.children?.append(photoContainerNode)
            photoContainerNode.style.spacingBefore = 8
        }
        let body = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .start, alignItems: .start, children: [avatarNode, content])
        nameMeta.style.width = ASDimensionMake("100%")
        content.style.width = ASDimensionMake("100%")
        content.style.flexShrink = 1
        body.style.width = ASDimensionMake("100%")
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), child: body)
    }
    
}
