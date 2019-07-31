//
//  ContenBlock0CollectionViewCell.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 04.07.19.
//

#import "ContenBlock0CollectionViewCell.h"

@interface ContenBlock0CollectionViewCell()
  @property (nonatomic, strong) UILabel *testLabel;
@end

@implementation ContenBlock0CollectionViewCell

  - (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    
    _testLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _testLabel.numberOfLines = 0;
    _testLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.contentView addSubview:_testLabel];
    _testLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [[_testLabel.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor constant:0] setActive: YES];
    [[_testLabel.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor constant:0] setActive: YES];
    [[_testLabel.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor constant:0] setActive: YES];
    [[_testLabel.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor constant:0] setActive: YES];
    [_testLabel setBackgroundColor:[UIColor greenColor]];
  }

  - (void)prepareForReuse {
    [super prepareForReuse];
  }

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
  }
  return self;
}
  - (void)setup:(NSString *)row {
    [self.contentView setBackgroundColor:[UIColor redColor]];
    
    _testLabel.text = row;

    //_testLabel.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 200);
    [_testLabel sizeToFit];
  }

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
  _testLabel.preferredMaxLayoutWidth = layoutAttributes.size.width;
  CGRect f = layoutAttributes.bounds;
  f.size.height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  layoutAttributes.bounds = f;
  return layoutAttributes;
}

@end
