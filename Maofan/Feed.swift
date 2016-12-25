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
    
    init(json: JSON) {
        self.json = json
        generateLayout()
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
        }
    }
    
    func exportLayoutTo(label: YYLabel) {
        if let layout = self.layout {
            DispatchQueue.main.async {
                label.frame.size = layout.textBoundingSize
                label.textLayout = layout
            }
        } else {
            print("Layout not ready. Consider generate layout instantly.")
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
