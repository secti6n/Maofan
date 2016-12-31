//
//  Feed.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/20.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import SwiftyJSON
import YYText
import YYWebImage

class Feed {
    
    let json: JSON
    var feedText: FeedText!
    private var layout: YYTextLayout!
    
    weak var label: YYLabel?
    
    init(_ json: JSON) {
        self.json = json
        feedText = FeedText(text)
        DispatchQueue.global().async {
            self.layout = Style.layout(feed: self)
        }
        if let photo = photo {
            YYWebImageManager.shared().requestImage(with: photo, progress: nil, transform: nil)
        }
    }
    
    func exportLayoutTo(label: YYLabel) {
        self.label = label
        var layout: YYTextLayout! = self.layout
        if nil == layout {
            print("Layout not ready. Calculate now.")
            layout = Style.layout(feed: self)
        } else {
            print("Hit layout cache.")
        }
        label.textLayout = layout
        label.frame.size = layout.textBoundingSize
    }
    
    var feedTextHeight: CGFloat {
        get {
            if nil == self.layout {
                self.layout = Style.layout(feed: self)
            }
            return self.layout.textBoundingSize.height
        }
    }
    
    var feedCellHeight: CGFloat {
        get {
            if hasPhoto {
                return max(feedTextHeight, 100) + FeedCell.whitespace * 2
            } else {
                return feedTextHeight + FeedCell.whitespace * 2
            }
        }
    }
    
    var text: String {
        get {
            return json["text"].stringValue
        }
    }
    
    var id: String {
        get {
            return json["id"].stringValue
        }
    }
    
    var rawid: Int {
        get {
            return json["rawid"].intValue
        }
    }
    
    var photoSize: CGSize? {
        get {
            if let image = YYImageCache.shared().getImageForKey(photoString) {
                return image.size
            }
            return nil
        }
    }
    
    var hasPhoto: Bool {
        get {
            return nil != photo
        }
    }
    
    var photo: URL? {
        get {
            return json["photo"]["largeurl"].URL
        }
    }
    
    var photoString: String {
        get {
            return json["photo"]["largeurl"].stringValue
        }
    }
    
    var smallPhoto: URL? {
        get {
            return json["photo"]["imageurl"].URL
        }
    }
    
    var user: User {
        get {
            return User(json["user"])
        }
    }
    
    var name: String {
        get {
            return json["user"]["name"].stringValue
        }
    }
    
    var userId: String {
        get {
            return json["user"]["id"].stringValue
        }
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
