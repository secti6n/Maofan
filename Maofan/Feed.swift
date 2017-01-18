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
        return _layout_meta ?? Style.layout(name: self)
    }
    
    var feedText: FeedText {
        return _feedText ?? FeedText(self)
    }
    
    private var _feedText: FeedText?
    private var _layout_status: YYTextLayout?
    private var _layout_name: YYTextLayout?
    private var _layout_meta: YYTextLayout?
    
    init(_ json: JSON) {
        self.json = json
        user = User(json["user"])
        DispatchQueue.global().async {
            self._feedText = FeedText(self)
            self._layout_name = Style.layout(name: self)
            self._layout_status = Style.layout(status: self)
            self._layout_meta = Style.layout(meta: self)
            YYWebImageManager.shared().preDownload(url: self.user.avatar)
            YYWebImageManager.shared().preDownload(url: self.photo)
        }
    }
    
    func export(cell: FeedCell) {
        let avatar = cell.avatar!
        let name = cell.name!
        let status = cell.status!
        let photo = cell.photo!
        let meta = cell.meta!
        avatar.yy_setImage(with: self.user.avatar, options: [.setImageWithFadeAnimation])
        photo.yy_setImage(with: self.photo, options: [.setImageWithFadeAnimation])
        let h_name = self.layout_name.textBoundingSize.height
        let h_meta = self.layout_meta.textBoundingSize.height
        let w_meta = self.layout_meta.textBoundingSize.width
        let x_meta = Style.fullWidth - Style.rightSpace - w_meta
        let y_status = Style.whitespace + h_name + Style.statusTopSpace
        let h_status = self.layout_status.textBoundingSize.height
        let y_photo = y_status + h_status + Style.photoTopBottomSpace
        DispatchQueue.main.async {
            name.frame.size.height = h_name
            meta.frame.size.height = h_meta
            meta.frame.size.width = w_meta
            meta.frame.origin.x = x_meta
            status.frame.origin.y = y_status
            status.frame.size.height = h_status
            name.textLayout = self.layout_name
            status.textLayout = self.layout_status
            meta.textLayout = self.layout_meta
            if self.hasPhoto {
                photo.frame.origin.y = y_photo
                if let photoSize = self.photoSize {
                    photo.frame.size = photoSize.feedPhotoSize()
                } else {
                    photo.frame.size.width = Style.photoSideLength
                    photo.frame.size.height = Style.photoSideLength
                }
            } else {
                photo.frame.size.width = 0
                photo.frame.size.height = 0
            }
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
        return _feedCellHeight ?? caculateFeedCellHeight()
    }
    
    private var _feedCellHeight: CGFloat?
    
    func caculateFeedCellHeight() -> CGFloat {
        let contentHeight: CGFloat
        if hasPhoto {
            if let photoSize = photoSize {
                contentHeight = nameSize.height + Style.statusTopSpace + statusSize.height + Style.photoTopBottomSpace + photoSize.feedPhotoSize().height
                _feedCellHeight = contentHeight + Style.whitespace * 2
            } else {
                contentHeight = nameSize.height + Style.statusTopSpace + statusSize.height + Style.photoTopBottomSpace + Style.photoSideLength
            }
        } else {
            contentHeight = nameSize.height + Style.statusTopSpace + statusSize.height
            _feedCellHeight = contentHeight + Style.whitespace * 2
        }
        return contentHeight + Style.whitespace * 2
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
