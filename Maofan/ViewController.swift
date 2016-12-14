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
import SwiftyJSON
import AsyncDisplayKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let string = NSAttributedString(string: "Hey, here's some text.")
        
        let node = ASTextNode()
        node.attributedText = string
        node.frame = CGRect(x: 50, y: 50, width: 100, height: 20)
        view.addSubnode(node)
        
        
        label.text = "press test button to parse a fanfou feed"
        label.numberOfLines = 0
        label.highlightTapAction = { (view, attrString, range, rect) in
            let hightlight = attrString.attributedSubstring(from: range).attribute(YYTextHighlightAttributeName, at: 0, effectiveRange: nil)
            print((hightlight as! YYTextHighlight).userInfo!["urlString"] as! String)
        }
        label.highlightLongPressAction = { (view, attrString, range, rect) in
            print("long press")
        }
    }
    
    @IBOutlet weak var label: YYLabel!
    
    @IBAction func testButtonDidTouch(_ sender: AnyObject) {
        let image = UIImageJPEGRepresentation(UIImage(named: "a1")!, 0.1)!
        Service.sharedInstance.update_profile_image(parameters: [ : ], image: image, success: { (response) in
            print(JSON(data: response.data))
        }, failure: { (error) in
            Misc.handleError(error)
        })
        
        
        
        let param = [
            "id" : "CgQlwCFDq-Y", // "CgQlwCFDq-Y" "IhY_NBPnw-g"
            "format" : "html"
        ]
        Service.sharedInstance.show(parameters: param, success: { (response) in
            let json = JSON(data: response.data)
            self.label.attributedText = FeedText(string: json["text"].stringValue).parseToAttrString()
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
        Service.sharedInstance.postText(parameters: param, success: { (response) in
            print(JSON(data: response.data))
        }, failure: { (error) in
            Misc.handleError(error)
        })
    }
    
    @IBAction func imageButtonDidTouch(_ sender: AnyObject) {
        let param = [
            "format": "html",
            "status": "Hello, world! \(arc4random())"
        ]
        let image = UIImageJPEGRepresentation(UIImage(named: "test")!, 0.1)!
        Service.sharedInstance.postImage(parameters: param, image: image, success: { (response) in
            print(JSON(data: response.data))
        }, failure: { (error) in
            Misc.handleError(error)
        })
    }

}
