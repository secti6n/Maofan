//
//  HomeViewController.swift
//  Maofan
//
//  Created by Catt Liu on 2017/5/12.
//  Copyright © 2017年 Catt Liu. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import SwiftyJSON

class HomeViewController: ASViewController<ASDisplayNode>, ASCollectionDataSource, ASCollectionDelegate, ASTextNodeDelegate, UIScrollViewDelegate, FeedCellNodeDelegate {
    
    let collectionNode: ASCollectionNode
    var data: [Feed] = []
    private let refreshControl = UIRefreshControl()
    
    func reload(feed: Feed) {
        for (_, item) in data.enumerated() {
            if feed == item {
                DispatchQueue.main.async {
//                    self.collectionNode.reloadItems(at: [IndexPath(item: index, section: 0)])
                }
                break
            }
        }
        
    }
    
    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        print(value)
    }
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        collectionNode.dataSource = self
        collectionNode.delegate = self
        collectionNode.backgroundColor = UIColor.white
        refreshControl.addTarget(nil, action: #selector(loadData), for: .valueChanged)
    }
    
    @objc func loadData() {
        Service.sharedInstance.home_timeline(parameters: ["count" : 20, "format" : "html"], success: { (res) in
            var feeds = [Feed]()
            for json in JSON(data: res.data).arrayValue {
                let feed = Feed(json)
                feeds.append(feed)
            }
            self.data = feeds
            self.collectionNode.reloadData()
            self.refreshControl.endRefreshing()
        }) { (e) in
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionNode.view.addSubview(refreshControl)
//        Login.xauth(username: FanfouConsumer.username, password: FanfouConsumer.password)
//        if let account = CoreDataTool.sharedInstance.fetch().first {
//            let user = User(JSON(data: account.jsonData! as Data))
//            print(user.name)
//        }
        loadData()
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let cellNode = FeedCellNode(with: self.data[indexPath.row])
        cellNode.textNode.delegate = self
        cellNode.delegate = self
        return cellNode
    }
    
//    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
//        let cellNodeBlock = { () -> ASCellNode in
//            let cellNode = FeedCellNode(with: self.data[indexPath.row])
//            cellNode.textNode.delegate = self
//            cellNode.delegate = self
//            return cellNode
//        }
//        return cellNodeBlock
//    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
