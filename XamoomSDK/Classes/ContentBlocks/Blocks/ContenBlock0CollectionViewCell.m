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

//  - (void)awakeFromNib {
//    [super awakeFromNib];
//    
//    _label.text = nil;
//
//    _label.translatesAutoresizingMaskIntoConstraints = NO;
//
//    [[_label.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor constant:0] setActive: YES];
//    [[_label.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor constant:0] setActive: YES];
//    [[_label.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor constant:0] setActive: YES];
//    [[_label.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor constant:0] setActive: YES];
//    [_label setBackgroundColor:[UIColor greenColor]];
//  }

  - (void)prepareForReuse {
    [super prepareForReuse];
  }

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _testLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _testLabel.numberOfLines = 0;
    _testLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.contentView addSubview:_testLabel];
    _testLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [[_testLabel.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor constant:0] setActive: YES];
    [[_testLabel.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor constant:0] setActive: YES];
    [[_testLabel.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor constant:0] setActive: YES];
    [[_testLabel.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor constant:0] setActive: YES];
    [_testLabel setBackgroundColor:[UIColor greenColor]];
  }
  return self;
}
  - (void)setup:(NSString *)row {
    [self.contentView setBackgroundColor:[UIColor redColor]];
    _testLabel.text = row;
    
  }

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
  _label.preferredMaxLayoutWidth = layoutAttributes.size.width;
  CGRect f = layoutAttributes.bounds;
  f.size.height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  layoutAttributes.bounds = f;
  
  return layoutAttributes;
}

@end
