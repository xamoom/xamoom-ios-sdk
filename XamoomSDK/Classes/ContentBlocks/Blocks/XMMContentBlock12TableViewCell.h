//
//  XMMContentBlock12TableViewCell.h
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 04.07.19.
//

#import <UIKit/UIKit.h>
#import "XMMEnduserApi.h"
#import "XMMContentBlocks.h"
#import "XMMContentBlocksCache.h"
#import "XMMStyle.h"
#import "ContenBlock0CollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMMContentBlock12TableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
  @property (weak, nonatomic) IBOutlet UIView *containerView;
  @property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
  @property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHEoght;
  @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
  @property (nonatomic, strong) UITableView *tv;
  @end

@interface XMMContentBlock12TableViewCell (XMMTableViewRepresentation)
  - (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api offline:(BOOL)offline;
@end

NS_ASSUME_NONNULL_END
