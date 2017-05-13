//
//  ViewController.swift
//  Maofan
//
//  Created by Catt Liu on 2017/5/12.
//  Copyright © 2017年 Catt Liu. All rights reserved.
//

import UIKit
import SwiftyJSON
import AsyncDisplayKit

class ViewController1: ASViewController<ASDisplayNode>, ASCollectionDataSource, ASCollectionDelegateFlowLayout {
    
    var feeds: [Feed] = []
    var collectionNode: ASCollectionNode!
    let flowLayout = UICollectionViewFlowLayout()
    
    init() {
        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionNode.delegate = self
        collectionNode.dataSource = self
        collectionNode.view.allowsSelection = false
        collectionNode.view.backgroundColor = .white
        collectionNode.frame = self.view.bounds
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard feeds.count > indexPath.row else { return { ASCellNode() } }
        // this may be executed on a background thread - it is important to make sure it is thread safe
        let cellNodeBlock = { () -> ASCellNode in
            let cellNode = ASCellNode()
            return cellNode
        }
        return cellNodeBlock
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func v1iewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

