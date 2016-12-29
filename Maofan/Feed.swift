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
    var layout: YYTextLayout?
    weak var label: YYLabel?
    
    init(json: JSON) {
        self.json = json
        self.generateLayout()
        if let photo = photo {
            YYWebImageManager.shared().requestImage(with: photo, progress: nil, transform: nil)
        }
    }
    
    func generateLayout() {
        DispatchQueue.global().async {
            let text = FeedText(string: self.text).parseToAttrString()
            let container = YYTextContainer()
            container.size = CGSize(width: 414, height: CGFloat.greatestFiniteMagnitude)
            container.maximumNumberOfRows = 0
            let layout = YYTextLayout(container: container, text: text)!
            self.layout = layout
            if let label = self.label {
                DispatchQueue.main.async {
                    label.textLayout = layout
                    label.frame.size.height = layout.textBoundingSize.height
                }
            }
        }
    }
    
    func exportLayoutTo(label: YYLabel) {
        self.label = label
        if let layout = self.layout {
            print("Hit layout cache.")
            DispatchQueue.main.async {
                label.textLayout = layout
                label.frame.size.height = layout.textBoundingSize.height
            }
        } else {
            print("Layout not ready. Will be generated in 'generateLayout()'.")
        }
    }
    
    var text: String {
        get {
            return json["text"].stringValue
        }
    }
    
    var name: String {
        get {
            return json["user"]["name"].stringValue
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
    
    var photo: URL? {
        get {
            return json["photo"]["largeurl"].URL
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

extension Feed {
    
    

}
