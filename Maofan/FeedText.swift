//
//  FeedText.swift
//  Maofan
//
//  Created by Catt Liu on 2016/11/30.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import Foundation

enum FeedTextType {
    case mention
    case tag
    case link
    case text
}

struct FeedText {
    
    let text: String
    let urlString: String
    let type: FeedTextType
    
    init(_ text: String, urlString: String = "", type: FeedTextType = .text) {
        self.text = text
        self.urlString = urlString
        self.type = type
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
                return decodeNumeric(String(entity[3 ..< entity.count - 1]), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(String(entity[3 ..< entity.count - 1]), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        var result = ""
        var position = startIndex
        
        while let ampRange = self.range(of: "&", range: position ..< endIndex) {
            result.append(String(self[position ..< ampRange.lowerBound]))
            position = ampRange.lowerBound
            if let semiRange = self.range(of: ";", range: position ..< endIndex) {
                let entity = self[position ..< semiRange.upperBound]
                position = semiRange.upperBound
                if let decoded = decode(String(entity)) {
                    result.append(decoded)
                } else {
                    result += entity
                }
            } else {
                break
            }
        }
        result.append(String(self[position ..< endIndex]))
        return result
        
    }
    
}

