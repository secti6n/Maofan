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
    let user: User
    
    var layout: YYTextLayout {
        get {
            return _layout ?? Style.layout(self)
        }
    }
    
    var feedText: FeedText {
        get {
            return _feedText ?? FeedText(self)
        }
    }
    
    private var _feedText: FeedText?
    private var _layout: YYTextLayout?
    
    init(_ json: JSON) {
        self.json = json
        user = User(json["user"])
        DispatchQueue.global().async {
            self._feedText = FeedText(self)
            self._layout = Style.layout(self)
            YYWebImageManager.shared().preDownload(url: self.user.avatar)
            YYWebImageManager.shared().preDownload(url: self.photo)
        }
    }
    
    func exportLayoutTo(label: YYLabel) {
        DispatchQueue.main.async {
            label.textLayout = self.layout
            label.frame.size = self.layout.textBoundingSize
        }
    }
    
    var feedTextHeight: CGFloat {
        get {
            return layout.textBoundingSize.height
        }
    }
    
    var feedCellHeight: CGFloat {
        get {
            return max((hasPhoto ? max(feedTextHeight, 90) : feedTextHeight), 48) + Style.whitespace * 2
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
