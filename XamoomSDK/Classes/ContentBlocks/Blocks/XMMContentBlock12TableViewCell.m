//
//  XMMContentBlock12TableViewCell.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 04.07.19.
//

#import "XMMContentBlock12TableViewCell.h"
#import "ContenBlock0CollectionViewCell.h"
#import "XMMContentBlock0TableViewCell.h"

@interface XMMContentBlock12TableViewCell()
@property (nonatomic, strong) NSArray *strings;
@property (nonatomic, strong) NSMutableArray *contentBlocks;
@property (nonatomic, strong) NSString *contentID;
@property (nonatomic, assign) int position;
@property (nonatomic, strong) UIView *curentSubview;
@property (nonatomic, assign) BOOL hardcodeLoadImage;

@end

@implementation XMMContentBlock12TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
  _strings = @[@"aöb ökwrfwö  öhw   ö  wh wg wöBG JRBAGAJER EAGÖ AR GRAG AG SEBGLAG ELAB GAREÖGA ER Ö aöb ökwrfwö  öhw   ö  wh wg wöBG JRBAGAJER EAGÖ AR GRAG AG SEBGLAG ELAB GAREÖGA ER 1 aelbg lb lrgb reb bbg öö bö börebgaletslbl geltebhlte", @"aöb ökwrfwö  öhw   ö  wh wg wöBG  EAGÖ AR GRAG AG SEBGLAG ELAB GAREÖGA ER Ö aöb ökwrfwö  öhw   ö  wh wg wöBG JRBAGAJER EAGÖ AR GRAG AG SEBGLAG ELAB GAREÖGA ER 4"];
  
  UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
  swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
  [self addGestureRecognizer:swipeRight];
  
  UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
  swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
  [self addGestureRecognizer:swipeLeft];

  _hardcodeLoadImage = YES;
  
  self.contentBlocks = [NSMutableArray new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
  
  - (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(id)style api:(id)api offline:(BOOL)offline {
    
    _tv = tableView;
    _position = 0;
    
    self.contentID = block.contentID;
    
    [self downloadContentBlock:api];
  }

- (void)addSubviewForPosition:(int)position {
  
  NSBundle *bundle = [NSBundle bundleForClass:[XMMContentBlocks class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *nibBundle;
  if (url) {
    nibBundle = [NSBundle bundleWithURL:url];
  } else {
    nibBundle = bundle;
  }
  
  XMMContentBlock *block = (XMMContentBlock *) self.contentBlocks[_position];
  
  NSString *nibName = [NSString stringWithFormat:@"XMMContentBlock%dTableViewCell", block.blockType];
  id cell = [nibBundle loadNibNamed:nibName owner:self options:nil].firstObject;
  
  if ([cell isKindOfClass:[XMMContentBlock0TableViewCell class]]) {
    XMMContentBlock0TableViewCell *c = (XMMContentBlock0TableViewCell *)cell;
    
    c.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, CGRectGetMaxY(c.frame));
    [c configureForCell:block tableView:nil indexPath:nil style:nil offline:NO];
    
    CGFloat height = c.contentTextView.frame.size.height + c.contentTextView.frame.origin.y;
    
    c.contentView.frame = CGRectMake(0, 0, c.frame.size.width, height);
    c.frame = CGRectMake(0, 0, c.frame.size.width, height);

    _containerHeight.constant = CGRectGetMaxY(c.contentTextView.frame);
    
    [self.containerView addSubview:c];
    _curentSubview = c;
    
  } else if ([cell isKindOfClass:[XMMContentBlock3TableViewCell class]]) {
    
    XMMContentBlock3TableViewCell *c = (XMMContentBlock3TableViewCell *)cell;
    c.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, CGFLOAT_MAX);
    
    if (block.fileID != nil && ![block.fileID isEqualToString:@""]) {
      [self displayImageFromURL:[NSURL URLWithString:block.fileID] blockCell:c];
    }
  } else if ([cell isKindOfClass:[XMMContentBlock2TableViewCell class]]) {
    XMMContentBlock2TableViewCell *c = (XMMContentBlock2TableViewCell *)cell;
    
    c.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, CGRectGetMaxY(c.frame));
    [c configureForCell:block tableView:nil indexPath:nil style:nil offline:NO];
    
    CGFloat height = c.webView.frame.size.height + c.webView.frame.origin.y;
    
    c.contentView.frame = CGRectMake(0, 0, c.frame.size.width, height);
    c.frame = CGRectMake(0, 0, c.frame.size.width, height);
    
    _containerHeight.constant = CGRectGetMaxY(c.webView.frame);
    
    [self.containerView addSubview:c];
    _curentSubview = c;
    
  } else if ([cell isKindOfClass:[XMMContentBlock1TableViewCell class]]) {
    XMMContentBlock1TableViewCell *c = (XMMContentBlock1TableViewCell *)cell;
    
    c.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, CGRectGetMaxY(c.frame));
    [c configureForCell:block tableView:nil indexPath:nil style:nil offline:NO];
    
    CGFloat height = c.audioPlayerView.frame.size.height + c.audioPlayerView.frame.origin.y;
    
    c.contentView.frame = CGRectMake(0, 0, c.frame.size.width, height);
    c.frame = CGRectMake(0, 0, c.frame.size.width, height);
    
    _containerHeight.constant = CGRectGetMaxY(c.audioPlayerView.frame);
    
    [self.containerView addSubview:c];
    _curentSubview = c;
  }
  
  _pageControl.currentPage = _position;
  
  [_tv beginUpdates];
  [self setNeedsLayout];
  [self layoutSubviews];
  [self layoutIfNeeded];
  [self updateConstraints];
  [self setNeedsUpdateConstraints];
  [_tv endUpdates];
}

- (IBAction)swipeLeft:(UISwipeGestureRecognizer*)recognizer {
  _position = _position + 1;
  if (_position >= self.contentBlocks.count) {
    return;
  }
 
  for (UIView *subView in [self.containerView subviews]) {
    if ([subView isKindOfClass:[XMMContentBlock1TableViewCell class]]) {
      XMMContentBlock1TableViewCell *c = (XMMContentBlock1TableViewCell *)subView;
      
      if (c.playing) {
        [c.audioControlButton sendActionsForControlEvents:UIControlEventTouchUpInside];
      }
    }
    
    if ([subView isKindOfClass:[XMMContentBlock2TableViewCell class]]) {
      XMMContentBlock2TableViewCell *c = (XMMContentBlock2TableViewCell *)subView;
      [c.webView removeFromSuperview];
    }
    
    [subView removeFromSuperview];
  }
  
  [self addSubviewForPosition:_position];
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer*)recognizer {
  _position = _position - 1;
  if (_position < 0) {
    return;
  }
  
  for (UIView *subView in [self.containerView subviews]) {
    if ([subView isKindOfClass:[XMMContentBlock1TableViewCell class]]) {
      XMMContentBlock1TableViewCell *c = (XMMContentBlock1TableViewCell *)subView;
      
      if (c.playing) {
        [c.audioControlButton sendActionsForControlEvents:UIControlEventTouchUpInside];
      }
    }
    
    if ([subView isKindOfClass:[XMMContentBlock2TableViewCell class]]) {
      XMMContentBlock2TableViewCell *c = (XMMContentBlock2TableViewCell *)subView;
      [c.webView removeFromSuperview];
    }
    
    [subView removeFromSuperview];
  }
  
  [self addSubviewForPosition:_position];
}

- (void)downloadContentBlock:(XMMEnduserApi *)api {
  
 [api contentWithID:self.contentID options:XMMContentOptionsPreview reason:XMMContentReasonLinkedContent password:nil completion:^(XMMContent *content, NSError *error, BOOL passwordRequired) {
   if (error && !content) {
     return;
   }
   
   for (XMMContentBlock *cb in content.contentBlocks) {
     int type = cb.blockType;
     if (type == 0 || type == 3 || type == 2 || type == 1) {
       [self.contentBlocks addObject:cb];
     }
   }
   
   self.pageControl.numberOfPages = self.contentBlocks.count;
  [self addSubviewForPosition: self.position];
   return;
 }];

}

- (void)calculateImageScaling:(double)scaleX blockCell:(XMMContentBlock3TableViewCell *)cell{
  double scalingFactor = scaleX / 100;
  double newImageWidth = self.bounds.size.width * scalingFactor;
  double sizeDiff = self.bounds.size.width - newImageWidth;
  
  cell.imageLeftHorizontalSpaceConstraint.constant = sizeDiff/2;
  cell.imageRightHorizontalSpaceConstraint.constant = (sizeDiff/2)*(-1);
}

- (void)displayImageFromURL:(NSURL *)fileURL blockCell:(XMMContentBlock3TableViewCell *)cell{
  if ([fileURL.absoluteString containsString:@".svg"]) {
    [self displaySVGFromURL:fileURL blockCell:cell];
  } else {
    [cell.imageLoadingIndicator startAnimating];
    [cell.blockImageView sd_setImageWithURL:fileURL
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    [cell.imageLoadingIndicator stopAnimating];
                                    [self createAspectConstraintFromImage:image.size blockCell:cell];
                                  }];
  }
}

- (void)displaySVGFromURL:(NSURL *)fileURL blockCell:(XMMContentBlock3TableViewCell *)cell {
  cell.blockImageView.image = nil;
  [cell.imageLoadingIndicator startAnimating];
  
  [[[NSURLSession sharedSession] dataTaskWithURL:fileURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    JAMSVGImage *svgImage = [JAMSVGImage imageWithSVGData:data];
    
    float ratio = svgImage.size.width/svgImage.size.height;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *image = [svgImage imageAtSize:CGSizeMake(self.bounds.size.width, self.bounds.size.width*ratio)];
      
      cell.blockImageView.image = image;
      
      [cell.imageLoadingIndicator stopAnimating];
      [self createAspectConstraintFromImage:image.size blockCell:cell];
    });
    
  }] resume];
  
}

- (void)createAspectConstraintFromImage:(CGSize)size blockCell:(XMMContentBlock3TableViewCell *)cell {
  if (size.height <= 0 || size.width <= 0) {
    return;
  }
  
  double multiplier = 1/(size.width/size.height);
  double imageWidth =  UIScreen.mainScreen.bounds.size.width;
  double imageHeight =  imageWidth * multiplier;
  cell.blockImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
  cell.imageRatioConstraint =[NSLayoutConstraint
                              constraintWithItem:cell.blockImageView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:cell.blockImageView
                              attribute:NSLayoutAttributeWidth
                              multiplier:1/(size.width/size.height)
                              constant:0.0f];
  cell.imageRatioConstraint.priority = UILayoutPriorityRequired;
  
  [cell.blockImageView addConstraint:cell.imageRatioConstraint];
  [cell.blockImageView layoutSubviews];
  [cell layoutIfNeeded];
  
  XMMContentBlock *block = (XMMContentBlock *) self.contentBlocks[_position];

  if (block.title != nil && ![block.title isEqualToString:@""]) {
    cell.titleLabel.text = block.title;
    cell.horizontalSpacingImageTitleConstraint.constant = 8;
  } else {
    cell.horizontalSpacingImageTitleConstraint.constant = 0;
  }
  
  if (block.copyright != nil || ![block.copyright isEqualToString:@""]) {
    cell.copyrightLabel.text = block.copyright;
  } else {
    cell.copyrightLabel.text = @"";
  }
  
  if (block.altText != nil && ![block.altText isEqualToString:@""]){
    cell.blockImageView.accessibilityHint = block.altText;
  } else {
    cell.blockImageView.accessibilityHint = block.title;
  }
  
  if (block.scaleX > 0) {
    [self calculateImageScaling:block.scaleX blockCell:cell];
  }
  
  cell.frame = CGRectMake(0, 0, imageWidth, imageHeight + 40);
  _containerHeight.constant = CGRectGetMaxY(cell.frame);
  [self.containerView addSubview:cell];
  _curentSubview = cell;
  
  if (!_hardcodeLoadImage) {
    _hardcodeLoadImage = YES;
    return;
  }
  
  _hardcodeLoadImage = NO;
  
  for (UIView *subView in [self.containerView subviews]) {
    [subView removeFromSuperview];
  }
  
  [self addSubviewForPosition:_position];
  
}
@end
