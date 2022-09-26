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
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // A minor tweak so that the card 'snaps' to the bottom if the doesn't quite scroll all the way, ensuring all content behind is displayed
        var point = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        guard let scrollView = collectionView else { return point }
        if velocity.y < 0 && point.y <= -scrollView.adjustedContentInset.top + 250 {
            point.y = -scrollView.adjustedContentInset.top
        }
        return point
    }
}
