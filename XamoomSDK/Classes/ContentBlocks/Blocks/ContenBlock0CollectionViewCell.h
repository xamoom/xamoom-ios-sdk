//
//  ContenBlock0CollectionViewCell.h
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 04.07.19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContenBlock0CollectionViewCell : UICollectionViewCell

  @property (weak, nonatomic) IBOutlet UIView *contentCellView;
  @property (weak, nonatomic) IBOutlet UILabel *label;
  @property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
  @property (nonatomic, assign) BOOL isHeightCalculated;

  - (void)setup:(NSString *)row;

@end

NS_ASSUME_NONNULL_END
