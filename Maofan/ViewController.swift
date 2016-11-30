//
//  ViewController.swift
//  Maofan
//
//  Created by Catt Liu on 16/9/8.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//
import UIKit
import CoreData
import YYText

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.numberOfLines = 0
        let text = NSMutableAttributedString(string: "Some Text, blabla...")
        text.yy_font = UIFont.systemFont(ofSize: 17)
        let range = NSRange(location: 0, length: 8)
        let highlight = YYTextHighlight()
        highlight.setColor(UIColor.red)
        text.yy_setTextHighlight(highlight, range: range)
        label.attributedText = text
        label.highlightTapAction = { (view, attrString, range, rect) in
            let url = attrString.attributedSubstring(from: range).attribute(NSLinkAttributeName, at: 0, effectiveRange: nil)
            print(url as Any)
        }
        label.highlightLongPressAction = { (view, attrString, range, rect) in
            print("long press")
        }
    }
    
    @IBOutlet weak var label: YYLabel!
    
    @IBAction func testButtonDidTouch(_ sender: AnyObject) {
        let param = [
            "id" : "IhY_NBPnw-g", // "CgQlwCFDq-Y" "IhY_NBPnw-g" "9NrjB94ISbI"
            "format" : "html"
        ]
        Service.sharedInstance.show(parameters: param, success: { (response) in
            let json = JSON(data: response.data)
            let string = json["text"].stringValue
            print("原始字串：\(string)\n")
            let pattern = "([@#]?)<a href=\"([^\"]+)[^>]*>([^<]+)</a>([#]?)"
            let regular = try! NSRegularExpression(pattern: pattern, options:.caseInsensitive)
            let array = regular.matches(in: string, options: [], range: NSMakeRange(0, string.characters.count))
            var index = 0
            var plainTexts: [String] = []
            var linkTexts: [LinkText] = []
            for e in array {
                let range = e.rangeAt(0)
                let beforeRange = NSRange(location: index, length: range.location - index)
                index = range.location + range.length
                plainTexts.append((string as NSString).substring(with: beforeRange))
                let text = (string as NSString).substring(with: e.rangeAt(1)) + (string as NSString).substring(with: e.rangeAt(3)) + (string as NSString).substring(with: e.rangeAt(4))
                let urlString = (string as NSString).substring(with: e.rangeAt(2))
                linkTexts.append(LinkText(text: text, url: URL(string: urlString)))
            }
            let feedText = FeedText(plainTexts: plainTexts, linkTexts: linkTexts)
            feedText.parse(to: self.label)
            print(feedText)
        }, failure: nil)
    }
    
    @IBAction func deleteAllButtonDidTouch(_ sender: AnyObject) {
        CoreDataTool.sharedInstance.delete(forEntityName: "Account")
    }
    
    @IBAction func fetchButtonDidTouch(_ sender: AnyObject) {
        let arr = CoreDataTool.sharedInstance.fetch()
        for account in arr {
            let json = JSON(data: account.jsonData as! Data)
            print(json)
            print(account.unique_id as Any)
        }
    }
    
    @IBAction func login1ButtonDidTouch(_ sender: AnyObject) {
        Login.xauth(username: FanfouConsumer.username, password: FanfouConsumer.password)
    }
    
    @IBAction func login2ButtonDidTouch(_ sender: AnyObject) {
        Login.xauth(username: FanfouConsumer.username2, password: FanfouConsumer.password2)
    }
    
    @IBAction func textButtonDidTouch(_ sender: AnyObject) {
        let param = [
            "format": "html",
            "status": "Hello, world! \(arc4random())"
        ]
        Service.sharedInstance.postText(parameters: param, success: nil, failure: nil)
    }
    
    @IBAction func imageButtonDidTouch(_ sender: AnyObject) {
        let param = [
            "format": "html",
            "status": "Hello, world! \(arc4random())"
        ]
        let image = UIImageJPEGRepresentation(UIImage(named: "test")!, 0.1)!
        Service.sharedInstance.postImage(parameters: param, image: image, success: { (response) in
            print(JSON(data: response.data))
        }) { (error) in
            Misc.handleError(error)
        }
    }

}

//每次使用前先清空。
//点击颜色跟着范围终点走，如果范围不够终点了，那么颜色消失。
//点击跟着跟着范围起点走，如果范围不够起点了，那么点击消失。
//只要 label 的 text 没有重置，link 的点击效果和逻辑都还在，一旦范围够了，都会恢复。
