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

class TestViewController: ASViewController<ASDisplayNode>, ASTextNodeDelegate {
    
    let testNode = ASDisplayNode()
    
    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        print(Date())
    }
    
    init() {
        super.init(node: testNode)
        node.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
