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
    
    init(plainTexts: [String], linkTexts: [LinkText]) {
        self.plainTexts = plainTexts
        self.linkTexts = linkTexts
    }
    
    func parse(to label: YYLabel) {
        guard let last = plainTexts.last else { return }
        let text = NSMutableAttributedString()
        for (index, linkText) in linkTexts.enumerated() {
            let plainAttr = NSAttributedString(string: plainTexts[index])
            text.append(plainAttr)
            let linkAttr = NSMutableAttributedString(string: linkText.text)
            let range = NSRange(location: 0, length: linkAttr.length)
            linkAttr.yy_color = UIColor.blue
            linkAttr.yy_setLink(linkText.url, range: range)
            let highlight = YYTextHighlight()
            highlight.setColor(UIColor.red)
            linkAttr.yy_setTextHighlight(highlight, range: range)
            text.append(linkAttr)
        }
        text.append(NSAttributedString(string: last))
        text.yy_font = UIFont.systemFont(ofSize: 17)
        text.yy_lineSpacing = 10
        label.attributedText = text
    }
    
}

struct LinkText {
    
    let text: String
    let url: URL?
    
    init(text: String, url: URL?) {
        self.text = text
        self.url = url
    }
    
}
