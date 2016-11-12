//
//  ViewController.swift
//  Maofan
//
//  Created by Catt Liu on 16/9/8.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Service.sharedInstance.xauthorize(username: FanfouConsumer.username, password: FanfouConsumer.password)
    }
    
    @IBAction func helloButtonDidTouch(_ sender: AnyObject) {
        let param1 = [
            "format": "html",
            "status": "Hello, world! \(arc4random())"
        ]
        Service.sharedInstance.postText(parameters: param1, success: nil, failure: nil)
        let param2 = [
            "format": "html",
            "status": "Hello, world! \(arc4random())"
        ]
        let image = UIImageJPEGRepresentation(UIImage(named: "test")!, 0.1)!
        Service.sharedInstance.postImage(parameters: param2, image: image, success: { (response) in
            print(JSON(data: response.data))
        }) { (error) in
            Misc.handleError(error)
        }
    }

}

