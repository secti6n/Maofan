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

class HomeViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate, ASTextNodeDelegate, UIScrollViewDelegate, FeedCellNodeDelegate {
    
    let tableNode: ASTableNode
    var data: [Feed] = []
    private let refreshControl = UIRefreshControl()
    
    func reload(feed: Feed) {
        for (index, item) in data.enumerated() {
            if feed == item {
                DispatchQueue.main.async {
                    self.tableNode.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
                }
                break
            }
        }
    }
    
    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        print(value)
    }
    
    init() {
        tableNode = ASTableNode()
        super.init(node: tableNode)
    }
    
    @objc func loadData() {
        Service.sharedInstance.home_timeline(parameters: ["count" : 60, "format" : "html"], success: { (res) in
            var feeds = [Feed]()
            for json in JSON(data: res.data).arrayValue {
                let feed = Feed(json)
                feeds.append(feed)
            }
            self.data = feeds
            self.tableNode.reloadData()
            self.refreshControl.endRefreshing()
        }) { (e) in
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.view.separatorStyle = .none
        tableNode.view.refreshControl = refreshControl
        refreshControl.addTarget(nil, action: #selector(loadData), for: .valueChanged)
        Login.xauth(username: FanfouConsumer.username, password: FanfouConsumer.password)
        if let account = CoreDataTool.sharedInstance.fetch().first {
            let user = User(JSON(data: account.jsonData! as Data))
            print(user.name)
        }
        loadData()
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let cellNodeBlock = { () -> ASCellNode in
            let cellNode = FeedCellNode(with: self.data[indexPath.row])
            cellNode.textNode.delegate = self
            cellNode.delegate = self
            return cellNode
        }
        return cellNodeBlock
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
