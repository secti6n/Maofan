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

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let l = TTTAttributedLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        print(l)
    }
    
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

