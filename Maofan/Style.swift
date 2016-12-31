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
    
    static func layout(feed: Feed) -> YYTextLayout {
        let text = parseToAttrString(feed: feed)
        let container = YYTextContainer()
        if feed.hasPhoto {
            container.size = CGSize(width: 260, height: CGFloat.greatestFiniteMagnitude)
        } else {
            container.size = CGSize(width: 370, height: CGFloat.greatestFiniteMagnitude)
        }
        container.maximumNumberOfRows = 0
        return YYTextLayout(container: container, text: text)!
    }
    
    static func parseToAttrString(feed: Feed) -> NSMutableAttributedString {
        let text = NSMutableAttributedString()
        for (index, linkText) in feed.feedText.linkTexts.enumerated() {
            let plainText = feed.feedText.plainTexts[index]
            let plainAttr = NSMutableAttributedString(string: plainText)
            plainAttr.yy_color = plainColor
            text.append(plainAttr)
            let linkAttr = NSMutableAttributedString(string: linkText.text)
            linkAttr.yy_color = linkColor
            let range = NSRange(location: 0, length: linkAttr.length)
            let highlight = YYTextHighlight()
            highlight.userInfo = ["urlString" : linkText.urlString]
            highlight.setColor(UIColor.red)
            linkAttr.yy_setTextHighlight(highlight, range: range)
            text.append(linkAttr)
        }
        text.append(NSAttributedString(string: feed.feedText.plainTexts.last!))
        text.yy_font = textFont

        let name = NSMutableAttributedString(string: feed.name + " ")
        name.yy_font = nameFont
        name.yy_color = linkColor
        let range = NSRange(location: 0, length: name.length)
        let highlight = YYTextHighlight()
        highlight.userInfo = ["urlString" : "http://fanfou.com/user/" + feed.userId]
        highlight.setColor(UIColor.red)
        name.yy_setTextHighlight(highlight, range: range)
        text.insert(name, at: 0)
        text.yy_lineSpacing = 6
        
        return text
    }
    
    static var nameFont: UIFont {
        get {
            return UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
        }
    }
    
    static var textFont: UIFont {
        get {
            return UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
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
            return UIColor(hex: "FCFCFC")
        }
    }
    
    static var backgroundTouchColor: UIColor {
        get {
            return UIColor(hex: "F3F4F5")
        }
    }
        
}
