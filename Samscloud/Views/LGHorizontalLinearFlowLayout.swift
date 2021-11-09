//
//  LGHorizontalLinearFlowLayout.swift
//  LGLinearFlowView
//
//  Created by Luka Gabric on 16/08/15.
//  Copyright © 2015 Luka Gabric. All rights reserved.
//

import UIKit

public class LGHorizontalLinearFlowLayout: UICollectionViewFlowLayout {
    
    private var lastCollectionViewSize: CGSize = .zero
    public var scalingOffset: CGFloat = 200 // for offsets >= scalingOffset scale factor is minimumScaleFactor
    public var minimumScaleFactor: CGFloat = 0.85
    public var scaleItems: Bool = true
    
    
    // MARK: - ACTIONS
    
    static func configureLayout(collectionView: UICollectionView, itemSize: CGSize, minimumLineSpacing: CGFloat) -> LGHorizontalLinearFlowLayout {
        let layout = LGHorizontalLinearFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = itemSize
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.collectionViewLayout = layout
        return layout
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        if self.collectionView == nil {
            return
        }
        let currentCollectionViewSize = self.collectionView!.bounds.size
        if !currentCollectionViewSize.equalTo(self.lastCollectionViewSize) {
            self.configureInset()
            self.lastCollectionViewSize = currentCollectionViewSize
        }
    }
    
    private func configureInset() -> Void {
        if self.collectionView == nil {
            return
        }
        let inset = self.collectionView!.bounds.size.width / 2 - self.itemSize.width / 2
        self.collectionView!.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        self.collectionView!.contentOffset = CGPoint(x: -inset, y: 0)//CGPointMake(-inset, 0)
    }
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if self.collectionView == nil {
            return proposedContentOffset
        }
        let collectionViewSize = self.collectionView!.bounds.size
        let proposedRect = CGRect(x: proposedContentOffset.x,
                                  y: 0,
                                  width: collectionViewSize.width,
                                  height: collectionViewSize.height)
        let layoutAttributes = self.layoutAttributesForElements(in: proposedRect)
        if layoutAttributes == nil {
            return proposedContentOffset
        }
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width / 2
        for attributes: UICollectionViewLayoutAttributes in layoutAttributes! {
            if attributes.representedElementCategory != .cell {
                continue
            }
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            if abs(attributes.center.x - proposedContentOffsetCenterX) < abs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }
        if candidateAttributes == nil {
            return proposedContentOffset
        }
        var newOffsetX = candidateAttributes!.center.x - self.collectionView!.bounds.size.width / 2
        let offset = newOffsetX - self.collectionView!.contentOffset.x
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = self.itemSize.width + self.minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }
        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if !self.scaleItems || self.collectionView == nil {
            return super.layoutAttributesForElements(in: rect)
        }
        let superAttributes = super.layoutAttributesForElements(in: rect)
        if superAttributes == nil {
            return nil
        }
        let contentOffset = self.collectionView!.contentOffset
        let size = self.collectionView!.bounds.size
        let visibleRect = CGRect(x: contentOffset.x,
                                 y: contentOffset.y,
                                 width: size.width,
                                 height: size.height)
        let visibleCenterX = visibleRect.midX        
        var newAttributesArray = Array<UICollectionViewLayoutAttributes>()
        for (_, attributes) in superAttributes!.enumerated() {
            let newAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            newAttributesArray.append(newAttributes)
            let distanceFromCenter = visibleCenterX - newAttributes.center.x
            let absDistanceFromCenter = min(abs(distanceFromCenter), self.scalingOffset)
            let scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.scalingOffset + 1
            newAttributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        }
        return newAttributesArray;
    }
    
    
    
    
}
