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
    
    var layout_status: YYTextLayout {
        return _layout_status ?? Style.layout(status: self)
    }
    
    var layout_name: YYTextLayout {
        return _layout_name ?? Style.layout(name: self)
    }
    
    var layout_meta: YYTextLayout {
        return Style.layout(meta: self)
    }
    
    var feedText: FeedText {
        return _feedText ?? FeedText(self)
    }
    
    private var _feedText: FeedText?
    private var _layout_status: YYTextLayout?
    private var _layout_name: YYTextLayout?
    
    init(_ json: JSON) {
        self.json = json
        user = User(json["user"])
        DispatchQueue.global().async {
            self._feedText = FeedText(self)
            self._layout_name = Style.layout(name: self)
            self._layout_status = Style.layout(status: self)
            YYWebImageManager.shared().preDownload(url: self.user.avatar)
            YYWebImageManager.shared().preDownload(url: self.photo)
        }
    }
    
    func export(status: YYLabel) {
        DispatchQueue.main.async {
            status.textLayout = self.layout_status
            status.frame.size = self.layout_status.textBoundingSize
        }
    }
    
    func export(name: YYLabel) {
        DispatchQueue.main.async {
            name.textLayout = self.layout_name
            name.frame.size.height = self.nameSize.height
        }
    }
    
    func export(meta: YYLabel) {
        DispatchQueue.main.async {
            meta.textLayout = self.layout_meta
            meta.frame.size.height = self.metaSize.height
            meta.frame.origin.y = Style.whitespace + self.nameSize.height - self.metaSize.height
            meta.textAlignment = .right
        }
    }
    
    func export(photo: YYAnimatedImageView) {
        DispatchQueue.main.async {
            photo.yy_setImage(with: self.photo, options: [.setImageWithFadeAnimation])
            photo.frame.origin.y = Style.whitespace * 2 + self.statusSize.height
        }
    }
    
    func export(avatar: YYAnimatedImageView) {
        DispatchQueue.main.async {
            avatar.yy_setImage(with: self.user.avatar, options: [.setImageWithFadeAnimation])
        }
    }
    
    var statusSize: CGSize {
        return layout_status.textBoundingSize
    }
    
    var metaSize: CGSize {
        return layout_meta.textBoundingSize
    }
    
    var nameSize: CGSize {
        return layout_name.textBoundingSize
    }
    
    var feedCellHeight: CGFloat {
        let contentHeight = statusSize.height + Style.whitespace * (1 - 1 / 3)
        let contentHeightWithPhoto = statusSize.height + Style.whitespace + 200
        return max(48, hasPhoto ? contentHeightWithPhoto : contentHeight) + Style.whitespace * 2
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
    
    var photoSize: CGSize? {
        if let image = YYImageCache.shared().getImageForKey(photoString) {
            return image.size
        }
        return nil
    }
    
    var hasPhoto: Bool {
        return nil != photo
    }
    
    var photo: URL? {
        return json["photo"]["largeurl"].URL
    }
    
    var photoString: String {
        return json["photo"]["largeurl"].stringValue
    }
    
    var smallPhoto: URL? {
        return json["photo"]["imageurl"].URL
    }
    
    var time: String {
        return json["created_at"].stringValue
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
