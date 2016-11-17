//
//  ViewController.swift
//  Maofan
//
//  Created by Catt Liu on 16/9/8.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit
import CoreData
import TTTAttributedLabel

class ViewController: UIViewController, TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.attributedText = NSAttributedString(string: "😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃testhttps://fanfou.com", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 17)
            ])
//        let mas = NSMutableAttributedString()
//        let as1 = NSAttributedString(string: "abc")
//        let as2 = NSAttributedString(string: "test", attributes: [
//            NSLinkAttributeName : URL(string: "http://fanfou.com")!,
//            NSForegroundColorAttributeName : UIColor.red,
//            NSFontAttributeName : UIFont.systemFont(ofSize: 20)
//            ])
//        mas.append(as1)
//        mas.append(as2)
//        label.attributedText = mas
        label.delegate = self
        let range = (label.text! as NSString).range(of: "https://fanfou.com")
        label.linkAttributes = [
            NSForegroundColorAttributeName : UIColor.red,
        ]
        label.activeLinkAttributes = [
            kCTForegroundColorAttributeName as AnyHashable : UIColor.green,
        ]
        print(label.attributedText)
        label.addLink(to: URL(string: "http://fanfou.com"), with: range)
//        label.text = nil
//        label.attributedText = NSAttributedString(string: "testtthttps://fanfou.1", attributes: [
//            NSFontAttributeName : UIFont.systemFont(ofSize: 17)
//            ])
    }
    
    @IBOutlet weak var label: TTTAttributedLabel!
    
    @IBAction func testButtonDidTouch(_ sender: AnyObject) {
        print(Service.sharedInstance.client.credential.oauthToken)
        let param = [
            "id" : "CgQlwCFDq-Y", // "CgQlwCFDq-Y" "IhY_NBPnw-g"
            "format" : "html"
        ]
        Service.sharedInstance.show(parameters: param, success: { (response) in
            let json = JSON(data: response.data)
            let string = json["text"].stringValue
            print(string+"\n")
            let pattern = "[@#]?<a href=\"([^\"]+)[^>]*>([^<]+)</a>[#]?"
            let regular = try! NSRegularExpression(pattern: pattern, options:.caseInsensitive)
            let array = regular.matches(in: string, options: [], range: NSMakeRange(0, string.characters.count))
            for e in array {
                print((string as NSString).substring(with: e.rangeAt(0)))
                print((string as NSString).substring(with: e.rangeAt(1)))
                print((string as NSString).substring(with: e.rangeAt(2))+"\n")
            }
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

