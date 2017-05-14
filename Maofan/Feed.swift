//
//  Feed.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/20.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import SwiftyJSON
import PINRemoteImage

class Feed {
    
    let json: JSON
    let user: User
    var feedTexts: [FeedText]!
    var feedAttr: NSAttributedString!

    init(_ json: JSON) {
        self.json = json
        user = User(json["user"])
        feedTexts = makeFeedTexts(string: text)
        feedAttr = makeFeedAttr(feedTexts: feedTexts)
        if let url1 = user.avatar, let url2 = photo {
            PINRemoteImageManager.shared().prefetchImages(with: [url1, url2])
        }
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
    
}

extension Feed {
    
    func makeFeedTexts(string: String) -> [FeedText] {
        var value: [FeedText] = []
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
    
    func makeFeedAttr(feedTexts: [FeedText]) -> NSAttributedString {
        let mas = NSMutableAttributedString()
        for feedText in feedTexts {
            let attr = NSMutableAttributedString(string: feedText.text)
            switch feedText.type {
            case .mention:
                attr.addAttributes([NSForegroundColorAttributeName : Style.tintColor, kLinkAttributeName : feedText.urlString])
            case .tag:
                attr.addAttributes([NSForegroundColorAttributeName : Style.metaColor, kLinkAttributeName : feedText.urlString])
            case .link:
                attr.addAttributes([NSForegroundColorAttributeName : Style.tintColor, kLinkAttributeName : feedText.urlString])
            default:
                attr.addAttributes([NSForegroundColorAttributeName : Style.plainColor])
            }
            mas.append(attr)
        }
        let parag = NSMutableParagraphStyle()
        parag.lineHeightMultiple = 1.1
        mas.addAttributes([NSFontAttributeName : Style.plainFont, NSParagraphStyleAttributeName : parag])
        return mas
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

extension NSMutableAttributedString {
    
    func addAttributes(_ attrs: [String : Any]) {
        self.addAttributes(attrs, range: NSRange(location: 0, length: length))
    }
    
}
