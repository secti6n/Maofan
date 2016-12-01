//
//  FeedText.swift
//  Maofan
//
//  Created by Catt Liu on 2016/11/30.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import Foundation
import YYText

struct FeedText {
    
    let plainTexts: [String]
    let linkTexts: [LinkText]
    
    init(string: String) {
        let pattern = "([@#]?)<a href=\"(.*?)\".*?>(.*?)</a>([#]?)"
        let regular = try! NSRegularExpression(pattern: pattern, options:.caseInsensitive)
        let array = regular.matches(in: string, options: [], range: NSMakeRange(0, string.characters.count))
        var plainTexts: [String] = []
        var linkTexts: [LinkText] = []
        var index = 0
        for e in array {
            let range = e.rangeAt(0)
            let beforeRange = NSRange(location: index, length: range.location - index)
            index = range.location + range.length
            plainTexts.append((string as NSString).substring(with: beforeRange))
            let text = (string as NSString).substring(with: e.rangeAt(1)) + (string as NSString).substring(with: e.rangeAt(3)) + (string as NSString).substring(with: e.rangeAt(4))
            let urlString = (string as NSString).substring(with: e.rangeAt(2))
            linkTexts.append(LinkText(text: text, urlString: urlString))
        }
        let afterRange = NSRange(location: index, length: (string as NSString).length - index)
        plainTexts.append((string as NSString).substring(with: afterRange))
        self.plainTexts = plainTexts
        self.linkTexts = linkTexts
        print("原始字串：\(string)\n")
        print("count: \(plainTexts.count) \(linkTexts.count)")
        print(self)
    }
    
    func parseToAttrString() -> NSAttributedString? {
        guard let last = plainTexts.last else { return nil }
        let text = NSMutableAttributedString()
        for (index, linkText) in linkTexts.enumerated() {
            let plainAttr = NSAttributedString(string: plainTexts[index])
            text.append(plainAttr)
            let linkAttr = NSMutableAttributedString(string: linkText.text)
            let range = NSRange(location: 0, length: linkAttr.length)
            let highlight = YYTextHighlight()
            highlight.setColor(UIColor.red)
            highlight.userInfo = ["urlString" : linkText.urlString]
            linkAttr.yy_setTextHighlight(highlight, range: range)
            linkAttr.yy_color = UIColor.blue
            text.append(linkAttr)
        }
        text.append(NSAttributedString(string: last))
        text.yy_font = UIFont.systemFont(ofSize: 17)
        text.yy_lineSpacing = 10
        return text
    }
    
}

struct LinkText {
    
    let text: String
    let urlString: String
    
    init(text: String, urlString: String) {
        self.text = text
        self.urlString = urlString
    }
    
}
