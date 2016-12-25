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
            self.layout = layout // *
            if let label = self.label {
                DispatchQueue.main.async {
                    label.frame.size = layout.textBoundingSize
                    label.textLayout = layout
                }
            }
        }
    }
    
    /*
    生成不会重复，排版可能重复：当下面方法中 1、2 两句之间发生了 * 就会这样。但机率很小。
    1. 赋值（下面
    *. 生成+排版（上面，因为有 1 的赋值了
    2. 排版（下面，因为有 2 的排版了
    */
    func exportLayoutTo(label: YYLabel) {
        self.label = label // 1
        if let layout = self.layout { // 2
            DispatchQueue.main.async {
                label.frame.size = layout.textBoundingSize
                label.textLayout = layout
            }
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
