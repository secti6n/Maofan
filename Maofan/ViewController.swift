//
//  ViewController.swift
//  Maofan
//
//  Created by Catt Liu on 2017/5/12.
//  Copyright © 2017年 Catt Liu. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import SwiftyJSON

class ViewController: ASViewController<ASCollectionNode>, ASCollectionDataSource, ASCollectionDelegate, ASTextNodeDelegate {
    
    let collectionNode: ASCollectionNode
    var data: [Feed] = []
    
    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        print(Date())
    }
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        collectionNode.dataSource = self
        collectionNode.delegate = self
        collectionNode.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Login.xauth(username: FanfouConsumer.username, password: FanfouConsumer.password)
        if let account = CoreDataTool.sharedInstance.fetch().first {
            let user = User(JSON(data: account.jsonData! as Data))
            print(user.name)
        }
        Service.sharedInstance.home_timeline(parameters: ["count" : 60, "format" : "html_"], success: { (res) in
            for json in JSON(data: res.data).arrayValue {
                let feed = Feed(json)
                self.data.append(feed)
            }
            self.collectionNode.reloadData()
        }) { (e) in
            //
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        // this may be executed on a background thread - it is important to make sure it is thread safe
        let cellNodeBlock = { () -> ASCellNode in
            let cellNode = FeedCellNode(with: self.data[indexPath.row])
            cellNode.textNode.delegate = self
            return cellNode
        }
        return cellNodeBlock
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
        collectionNode.dataSource = nil
        collectionNode.delegate = nil
    }
    
}
