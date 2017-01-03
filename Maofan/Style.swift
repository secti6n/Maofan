//
//  Style.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/31.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit
import YYText

class Style {
    
    static var whitespace: CGFloat = 40
    static var avatarSideLength: CGFloat = 32
    static var photoHeight: CGFloat = 240
    static var nameWidth: CGFloat = statusWidth - avatarSideLength - 8
    static var statusWidth: CGFloat = 414 - 32 - 24
    static var lineHeight: CGFloat = 22
    
    static func layout(name feed: Feed) -> YYTextLayout {
        let text = render(name: feed.user.name)
        let container = YYTextContainer()
        container.size = CGSize(width: nameWidth, height: CGFloat.greatestFiniteMagnitude)
        container.maximumNumberOfRows = 1
        return YYTextLayout(container: container, text: text)!
    }
    
    static func render(name: String) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: name)
        attr.yy_color = plainColor
        attr.yy_font = nameFont
        return attr
    }
    
    static func layout(meta feed: Feed) -> YYTextLayout {
        let text = render(meta: feed.time[11..<19])
        let container = YYTextContainer()
        container.size = CGSize(width: nameWidth, height: CGFloat.greatestFiniteMagnitude)
        container.maximumNumberOfRows = 1
        return YYTextLayout(container: container, text: text)!
    }
    
    static func render(meta: String) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: meta)
        attr.yy_color = metaColor
        attr.yy_font = metaFont
        return attr
    }
    
    static func layout(status feed: Feed) -> YYTextLayout {
        let text = render(feed: feed)
        let container = YYTextContainer()
        let modifier = YYTextLinePositionSimpleModifier()
        modifier.fixedLineHeight = lineHeight
        container.linePositionModifier = modifier
        if feed.hasPhoto {
            container.size = CGSize(width: statusWidth, height: CGFloat.greatestFiniteMagnitude)
        } else {
            container.size = CGSize(width: statusWidth, height: CGFloat.greatestFiniteMagnitude)
        }
        return YYTextLayout(container: container, text: text)!
    }
    
    static func render(feed: Feed) -> NSMutableAttributedString {
        let text = NSMutableAttributedString()
        for (index, linkText) in feed.feedText.linkTexts.enumerated() {
            text.append(render(plainText: feed.feedText.plainTexts[index]))
            text.append(render(linkText: linkText))
        }
        text.append(render(plainText: feed.feedText.plainTexts.last ?? ""))
        return text
    }
    
    static func render(plainText: String) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: plainText)
        attr.yy_color = plainColor
        attr.yy_font = plainFont
        return attr
    }
    
    static func render(linkText: LinkText) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: linkText.text)
        switch linkText.type {
        case .mention:
            attr.yy_color = plainColor
        case .tag:
            attr.yy_color = metaColor
        default:
            attr.yy_color = metaColor
        }
        attr.yy_font = linkFont
        let range = NSRange(location: 0, length: attr.length)
        let highlight = YYTextHighlight()
        highlight.userInfo = ["urlString" : linkText.urlString]
        highlight.setColor(highlightColor)
        attr.yy_setTextHighlight(highlight, range: range)
        return attr
    }
    
    static var linkFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
    }
    
    static var nameFont: UIFont {
        return UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
    }
    
    static var plainFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
    }
    
    static var metaFont: UIFont {
        return UIFont.systemFont(ofSize: 10, weight: UIFontWeightRegular)
    }
    
    static var plainColor: UIColor {
        return UIColor(hex: "33363F")
    }
    
    static var highlightColor: UIColor {
        return UIColor(hex: "007AFE")
    }
    
    static var metaColor: UIColor {
        return UIColor(hex: "CCD0D9")
    }
    
    static var backgroundColor: UIColor {
        return UIColor(hex: "FFFFFF")
    }
    
    static var backgroundColorTouch: UIColor {
        return UIColor(hex: "F8F8F9")
    }
    
    static var unSelect: UIColor {
        return UIColor(hex: "334566").alpha(0.25)
    }
    
    static func image(_ tintColor: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        return image(tintColor: tintColor, size: size)
    }
    
    static func image(tintColor: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        tintColor.setFill()
        context.fill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
