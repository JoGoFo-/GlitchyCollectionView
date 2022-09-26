//
//  ScrollingCardCollectionViewLayout.swift
//  GlitchyCollectionView
//
//  Created by Jonathon Francis on 26/9/2022.
//

import UIKit

class ScrollingCardCollectionViewLayout: UICollectionViewCompositionalLayout {
    override func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs = super.layoutAttributesForElements(in: rect)
        guard let attrs = attrs, let collectionView = collectionView else { return attrs }
        if let attr = attrs.first(where: { $0.representedElementCategory == .cell && $0.indexPath.section == 0 && $0.indexPath.item == 0 }) {
            let offset = collectionView.contentOffset
            let inset = collectionView.contentInset
            let adjustedOffset = offset.y + inset.top
            
            if adjustedOffset > 0 {
                attr.frame.origin.y = adjustedOffset / 3 * 2
            } else {
                attr.frame.origin.y = adjustedOffset / 5
            }
            
            attr.zIndex = -1
        }
        return attrs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.layoutAttributesForItem(at: indexPath)
        return attrs
    }
}
