//
//  Feed.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/20.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import SwiftyJSON
import YYText

class Feed {
    
    // 是否需要有 weak？
    let json: JSON
    var layout: YYTextLayout?
    var label: YYLabel?
    
    init(json: JSON) {
        self.json = json
        generateLayout()
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
                    label.frame.size = layout.textBoundingSize
                    label.textLayout = layout
                }
            }
        }
    }
    
    /*
    可能的重复排版：
    1. 赋值
    2. 生成+排版
    3. 排版
    */
    func applyLayoutTo(label: YYLabel) {
        self.label = label
        if let layout = self.layout {
            label.frame.size = layout.textBoundingSize
            label.textLayout = layout
        } else {
            print("layout not ready")
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
