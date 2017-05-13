//
//  Feed.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/20.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import SwiftyJSON

class Feed {
    
    let json: JSON
    let user: User
    var feedTexts: [FeedText] = []

    init(_ json: JSON) {
        self.json = json
        user = User(json["user"])
        feedTexts = makeFeedTexts()
    }
    
    var text: String {
        return json["text"].stringValue
    }
    
    var id: String {
        return json["id"].stringValue
    }
    
    var rawid: Int {
        return json["rawid"].intValue
    }
    
    
    var hasPhoto: Bool {
        return nil != photo
    }
    
    var photo: URL? {
        return json["photo"]["largeurl"].url
    }
    
    var photoString: String {
        return json["photo"]["largeurl"].stringValue
    }
    
    var smallPhoto: URL? {
        return json["photo"]["imageurl"].url
    }
    
    var time: String {
        return json["created_at"].stringValue
    }
    
    func makeFeedTexts() -> [FeedText] {
        var value: [FeedText] = []
        let string = text
        let pattern = "([@#]?)<a href=\"(.*?)\".*?>(.*?)</a>([#]?)"
        let regular = try! NSRegularExpression(pattern: pattern, options: [])
        let array = regular.matches(in: string, options: [], range: NSMakeRange(0, (string as NSString).length))
        var index = 0
        for e in array {
            // Plain
            let range = e.rangeAt(0)
            let beforeRange = NSRange(location: index, length: range.location - index)
            index = range.location + range.length
            value.append(FeedText((string as NSString).substring(with: beforeRange).stringByDecodingHTMLEntities))
            // Link
            let firstChar = (string as NSString).substring(with: e.rangeAt(1))
            let text = firstChar + (string as NSString).substring(with: e.rangeAt(3)).stringByDecodingHTMLEntities + (string as NSString).substring(with: e.rangeAt(4))
            let urlString = (string as NSString).substring(with: e.rangeAt(2))
            let type: FeedTextType
            switch firstChar {
            case "@":
                type = .mention
            case "#":
                type = .tag
            default:
                type = .link
            }
            value.append(FeedText(text, urlString: urlString, type: type))
        }
        let length = (string as NSString).length - index
        if length > 0 {
            let afterRange = NSRange(location: index, length: length)
            value.append(FeedText((string as NSString).substring(with: afterRange).stringByDecodingHTMLEntities))
        }
        if value.count == 0 {
            value.append(FeedText("上传了新照片"))
        }
        return value
    }
    
}

extension Feed: Hashable {
    
    var hashValue: Int {
        return rawid
    }
    
}

extension Feed: Comparable {}

func ==(lhs: Feed, rhs: Feed) -> Bool {
    return lhs.rawid == rhs.rawid
}

func >(lhs: Feed, rhs: Feed) -> Bool {
    return lhs.rawid > rhs.rawid
}

func <(lhs: Feed, rhs: Feed) -> Bool {
    return lhs.rawid < rhs.rawid
}

func ==(lhs: Feed, rhs: Feed?) -> Bool {
    return false
}

func >(lhs: Feed, rhs: Feed?) -> Bool {
    return true
}

func <(lhs: Feed, rhs: Feed?) -> Bool {
    return false
}
