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
    
    init(_ feed: Feed) {
        let string = feed.text
        let pattern = "([@#]?)<a href=\"(.*?)\".*?>(.*?)</a>([#]?)"
        let regular = try! NSRegularExpression(pattern: pattern, options: [])
        let array = regular.matches(in: string, options: [], range: NSMakeRange(0, (string as NSString).length))
        var plainTexts: [String] = []
        var linkTexts: [LinkText] = []
        var index = 0
        for e in array {
            let range = e.rangeAt(0)
            let beforeRange = NSRange(location: index, length: range.location - index)
            index = range.location + range.length
            plainTexts.append((string as NSString).substring(with: beforeRange).stringByDecodingHTMLEntities)
            let text = (string as NSString).substring(with: e.rangeAt(1)) + (string as NSString).substring(with: e.rangeAt(3)).stringByDecodingHTMLEntities + (string as NSString).substring(with: e.rangeAt(4))
            let urlString = (string as NSString).substring(with: e.rangeAt(2))
            linkTexts.append(LinkText(text: text, urlString: urlString))
        }
        let afterRange = NSRange(location: index, length: (string as NSString).length - index)
        plainTexts.append((string as NSString).substring(with: afterRange).stringByDecodingHTMLEntities)
        self.plainTexts = plainTexts
        self.linkTexts = linkTexts
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

// Very slightly adapted from http://stackoverflow.com/a/30141700/106244
// Mapping from XML/HTML character entity reference to character
// From http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references

private let characterEntities : [String : Character] = [
    "&quot;" : "\"",
    "&amp;" : "&",
    "&lt;" : "<",
    "&gt;" : ">",
]

extension String {
    
    var stringByDecodingHTMLEntities : String {

        func decodeNumeric(_ string : String, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }

        func decode(_ entity : String) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 3) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 2) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        var result = ""
        var position = startIndex
        
        while let ampRange = self.range(of: "&", range: position ..< endIndex) {
            result.append(self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            if let semiRange = self.range(of: ";", range: position ..< endIndex) {
                let entity = self[position ..< semiRange.upperBound]
                position = semiRange.upperBound
                if let decoded = decode(entity) {
                    result.append(decoded)
                } else {
                    result.append(entity)
                }
            } else {
                break
            }
        }
        result.append(self[position ..< endIndex])
        return result
        
    }
    
}

