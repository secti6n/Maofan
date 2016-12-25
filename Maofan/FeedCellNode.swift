import AsyncDisplayKit
import UIKit

final class FeedCellNode: ASCellNode {
    
    let image = ASNetworkImageNode()
    
    init(url: URL, string: String) {
        super.init()
        addSubnode(image)
        image.url = url
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageSize = CGSize(width: 200, height: 200)
        image.style.preferredSize = imageSize
        image.backgroundColor = .red
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 16,
            justifyContent: .center,
            alignItems: .center,
            children: [ image ]
        )
    }
    
}
