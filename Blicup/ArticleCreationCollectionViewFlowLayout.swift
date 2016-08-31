//
//  ArticleCreationCollectionViewFlowLayout.swift
//  Blicup
//
//  Created by Gustavo Tiago on 30/08/16.
//  Copyright © 2016 Moymer. All rights reserved.
//

import Foundation
import UIKit

class ArticleCreationCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if let cv = self.collectionView {
            
            let cvBounds = cv.bounds
            let halfWidth = cvBounds.size.height * 0.5;
            let proposedContentOffsetCenterY = proposedContentOffset.y + halfWidth;
            
            if let attributesForVisibleCells = self.layoutAttributesForElementsInRect(cvBounds) {
                
                var candidateAttributes : UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    
                    // == Skip comparison with non-cell items (headers and footers) == //
                    if attributes.representedElementCategory != UICollectionElementCategory.Cell {
                        continue
                    }
                    
                    
                    if (attributes.center.y == 0) || (attributes.center.y > (cv.contentOffset.y + halfWidth) && velocity.y < 0) {
                        continue
                    }
                    
                    // == First time in the loop == //
                    guard let candAttrs = candidateAttributes else {
                        candidateAttributes = attributes
                        continue
                    }
                    
                    let a = attributes.center.y - proposedContentOffsetCenterY
                    let b = candAttrs.center.y - proposedContentOffsetCenterY
                    
                    if fabsf(Float(a)) < fabsf(Float(b)) {
                        candidateAttributes = attributes;
                    }
                    
                    
                }
                
                // Beautification step , I don't know why it works!
                if(proposedContentOffset.y == -(cv.contentInset.top) || proposedContentOffset.y == -(cv.contentInset.bottom)) {
                    return proposedContentOffset
                }
                
                
                return CGPoint(x: candidateAttributes!.center.x, y: floor(candidateAttributes!.center.y - halfWidth))
                
            }
            
            
        }
        
        // fallback
        return super.targetContentOffsetForProposedContentOffset(proposedContentOffset)
    }

}