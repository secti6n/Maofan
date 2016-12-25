import UIKit
import AsyncDisplayKit
import SwiftyJSON

final class FeedsViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate {
    
    var feeds: [Feed] = []
    
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    
    init() {
        super.init(node: ASTableNode())
        tableNode.delegate = self
        tableNode.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let feed = feeds[indexPath.row]
        
        // this may be executed on a background thread - it is important to make sure it is thread safe
        let nodeBlock = { () -> ASCellNode in
            let node = FeedCellNode(url: feed.photo!, string: feed.text)
            return node
        }
        
        return nodeBlock
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func viewDidLoad() {
        Login.xauth(username: FanfouConsumer.username, password: FanfouConsumer.password)
        let parameters = [
            "format" : "html",
            "page" : "1",
            "count" : "12",
            ]
        Service.sharedInstance.photos_user_timeline(parameters: parameters, success: { (response) in
            for json in JSON(data: response.data).array! {
                self.feeds.append(Feed(json: json))
            }
            let indexPaths = (0..<self.feeds.count).map { index in
                IndexPath(row: index, section: 0)
            }
            self.tableNode.insertRows(at: indexPaths , with: .none)
        }, failure: { (error) in
            Misc.handleError(error)
        })
    }
}
