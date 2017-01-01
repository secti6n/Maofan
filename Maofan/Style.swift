//
//  Style.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/31.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

//        let name = NSMutableAttributedString(string: feed.user.name + " ")
//        name.yy_font = nameFont
//        name.yy_color = linkColor
//        let range = NSRange(location: 0, length: name.length)
//        let highlight = YYTextHighlight()
//        highlight.userInfo = ["urlString" : "http://fanfou.com/user/" + feed.user.id]
//        highlight.setColor(UIColor.red)
//        name.yy_setTextHighlight(highlight, range: range)
//        text.insert(name, at: 0)

import UIKit
import YYText

class Style {
    
    static func layout(_ feed: Feed) -> YYTextLayout {
        let text = render(feed: feed)
        let container = YYTextContainer()
        if feed.hasPhoto {
            container.size = CGSize(width: 226, height: CGFloat.greatestFiniteMagnitude)
        } else {
            container.size = CGSize(width: 340, height: CGFloat.greatestFiniteMagnitude)
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
        text.yy_font = textFont
        text.yy_lineSpacing = 4
        return text
    }
    
    static func render(_ plainText: String) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: plainText)
        attr.yy_color = plainColor
        attr.yy_font = textFont
        return attr
    }
    
    static func render(_ linkText: LinkText) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: linkText.text)
        attr.yy_color = linkColor
        attr.yy_font = textFont
        let range = NSRange(location: 0, length: attr.length)
        let highlight = YYTextHighlight()
        highlight.userInfo = ["urlString" : linkText.urlString]
        highlight.setColor(UIColor.red)
        attr.yy_setTextHighlight(highlight, range: range)
        return attr
    }
    
    static var nameFont: UIFont {
        get {
            return UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
        }
    }
    
    static var textFont: UIFont {
        get {
            return UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
        }
    }
    
    static var plainColor: UIColor {
        get {
            return UIColor(hex: "33363F")
        }
    }
    
    static var linkColor: UIColor {
        get {
            return UIColor(hex: "18B6F2")
        }
    }
    
    static var metaColor: UIColor {
        get {
            return UIColor(hex: "CCCDCF")
        }
    }
    
    static var backgroundColor: UIColor {
        get {
            return UIColor(hex: "FCFCFD")
        }
    }
    
    static var backgroundTouchColor: UIColor {
        get {
            return UIColor(hex: "F8F8FA")
        }
    }
        
}
