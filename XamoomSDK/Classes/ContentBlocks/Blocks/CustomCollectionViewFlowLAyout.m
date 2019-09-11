//
//  CustomCollectionViewFlowLAyout.m
//  Pods
//
//  Created by Thomas Krainz-Mischitz on 31.07.19.
//

#import "CustomCollectionViewFlowLAyout.h"

@implementation CustomCollectionViewFlowLAyout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
  CGFloat offsetAdjustment = CGFLOAT_MAX;
  CGFloat horizontalOffset = proposedContentOffset.x;
  CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.width);
  for (UICollectionViewLayoutAttributes *la in [self layoutAttributesForElementsInRect:targetRect]) {
    CGFloat itemOffset = la.frame.origin.x;
    if (fabs(itemOffset - horizontalOffset) < fabs(offsetAdjustment)) {
      offsetAdjustment = itemOffset - horizontalOffset;
    }
  }
  return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}
@end
