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
    
    static func layout(_ feed: Feed) -> YYTextLayout {
        let text = render(feed: feed)
        let container = YYTextContainer()
        if feed.hasPhoto {
            container.size = CGSize(width: 220, height: CGFloat.greatestFiniteMagnitude)
        } else {
            container.size = CGSize(width: 322, height: CGFloat.greatestFiniteMagnitude)
        }
        container.maximumNumberOfRows = 0
        return YYTextLayout(container: container, text: text)!
    }
    
    static func render(feed: Feed) -> NSMutableAttributedString {
        let text = NSMutableAttributedString()
        for (index, linkText) in feed.feedText.linkTexts.enumerated() {
            text.append(render(feed.feedText.plainTexts[index]))
            text.append(render(linkText))
        }
        text.append(render(feed.feedText.plainTexts.last ?? ""))
        text.yy_lineSpacing = 4
        return text
    }
    
    static func render(_ plainText: String) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: plainText)
        attr.yy_color = plainColor
        attr.yy_font = plainFont
        return attr
    }
    
    static func render(_ linkText: LinkText) -> NSMutableAttributedString {
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
        get {
            return UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        }
    }
    
    static var plainFont: UIFont {
        get {
            return UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        }
    }
    
    static var plainColor: UIColor {
        get {
            return UIColor(hex: "33363F")
        }
    }
    
    static var highlightColor: UIColor {
        get {
            return UIColor(hex: "007AFE")
        }
    }
    
    static var metaColor: UIColor {
        get {
            return UIColor(hex: "CCD0D9")
        }
    }
    
    static var backgroundColor: UIColor {
        get {
            return UIColor(hex: "FFFFFF")
        }
    }
    
    static var backgroundColorTouch: UIColor {
        get {
            return UIColor(hex: "F8F8F9")
        }
    }
    
    static var unSelect: UIColor {
        get {
            return UIColor(hex: "334566").alpha(0.25)
        }
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
