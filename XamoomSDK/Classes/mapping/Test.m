//
//  Test.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 31.07.19.
//

#import "Test.h"

@implementation Test

- (void)prepareLayout {
  [super prepareLayout];
  
  self.minimumLineSpacing = 0;
  [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  self.itemSize = self.collectionView.contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  CGRect oldBounds = self.collectionView.bounds;
  if (CGRectGetHeight(newBounds) != CGRectGetHeight(oldBounds)) {
    return YES;
  }
  return NO;
}
@end
