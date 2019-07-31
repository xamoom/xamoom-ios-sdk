//
//  XMMContentBlock12TableViewCell.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 04.07.19.
//

#import "XMMContentBlock12TableViewCell.h"
#import "ContenBlock0CollectionViewCell.h"
#import "CustomCollectionViewFlowLAyout.h"

@interface XMMContentBlock12TableViewCell()
@property (nonatomic, strong) NSArray *strings;
@end

@implementation XMMContentBlock12TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
  _strings = @[@"aöb ökwrfwö  öhw   ö  wh wg wöBG JRBAGAJER EAGÖ AR GRAG AG SEBGLAG ELAB GAREÖGA ER Ö aöb ökwrfwö  öhw   ö  wh wg wöBG JRBAGAJER EAGÖ AR GRAG AG SEBGLAG ELAB GAREÖGA ER 1", @"aöb ökwrfwö  öhw   ö  wh wg wöBG 2", @"aöb ökwrfwö  öhw   ö  wh wg wöBG JRBAGAJER EAGÖ AR GRAG AG SEBGLAG ELAB GAREÖGA ER Ö aöb ökwrfwö  öhw   ö  wh wg wöBG JRBAGAJER EAGÖ AR GRAG AG SEBGLAG ELAB GAREÖGA ER 3", @"aöb ökwrfwö  öhw   ö  wh wg wöBG  EAGÖ AR GRAG AG SEBGLAG ELAB GAREÖGA ER Ö aöb ökwrfwö  öhw   ö  wh wg wöBG JRBAGAJER EAGÖ AR GRAG AG SEBGLAG ELAB GAREÖGA ER 4", @"aöb ökwrfwö  öhw   ö  wh wg wöBG 5"];
  NSBundle *bundle = [NSBundle bundleForClass:[XMMContentBlock12TableViewCell class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *nibBundle;
  if (url) {
    nibBundle = [NSBundle bundleWithURL:url];
  } else {
    nibBundle = bundle;
  }
  UINib *nib =[UINib nibWithNibName:@"ContenBlock0CollectionViewCell" bundle:nibBundle];
  //[_collectionView registerNib:nib forCellWithReuseIdentifier:@"ContenBlock0CollectionViewCell"];
  
  [_collectionView registerClass:[ContenBlock0CollectionViewCell self] forCellWithReuseIdentifier:@"ContenBlock0CollectionViewCell"];
  
  _collectionView.delegate = self;
  _collectionView.dataSource = self;
  _collectionView.pagingEnabled = YES;
  
  self.collectionView.collectionViewLayout = [CustomCollectionViewFlowLAyout new];
  UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  CGFloat w = _collectionView.frame.size.width;
  flow.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
  
  - (void)configureForCell:(id)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(id)style api:(id)api offline:(BOOL)offline {
    
    self.titleLabel.text = @"TestTitle";
    _tv = tableView;
  }
  
  - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
  }
  
  - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _strings.count;
  }

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ContenBlock0CollectionViewCell * collectionviewitem = [collectionView dequeueReusableCellWithReuseIdentifier:@"ContenBlock0CollectionViewCell" forIndexPath:indexPath];
    [collectionviewitem setup:_strings[indexPath.row]];
    
    return collectionviewitem;
  }

- (NSIndexPath *)findCenterInCell {
  CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
  CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
  NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
  return visibleIndexPath;
}

-(void)transformCell {
  CGFloat offset = 0.0F;
  
  UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[self findCenterInCell]];
  if (cell isKindOfClass:[ContenBlock0CollectionViewCell class]) {
    offset = 1.0;
  }
  
  cell trans
}
  
  - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    ContenBlock0CollectionViewCell *cell = (ContenBlock0CollectionViewCell*) [_collectionView cellForItemAtIndexPath:visibleIndexPath];
    double height = cell.contentView.frame.size.height;
    _collectionViewHEoght.constant = height;
    
    [_tv beginUpdates];
    [self layoutIfNeeded];
    [_tv endUpdates];

    [_collectionView scrollToItemAtIndexPath:visibleIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
  }
  
@end
