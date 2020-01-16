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
@property (nonatomic, strong) NSMutableArray *contentBlocks;
@property (nonatomic, strong) NSString *contentID;
@property (nonatomic, assign) int position;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstrait;
@property (nonatomic, strong) UIView *currentSubview;
@property (nonatomic, assign) BOOL hardcodeLoadImage;
@property (nonatomic, strong) XMMStyle *style;

@end

@implementation XMMContentBlock12TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRight];
  
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeft];
    
    _hardcodeLoadImage = YES;
    
    self.contentBlocks = [NSMutableArray new];
    self.isLoading = FALSE;
    self.position = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
  
- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(id)style api:(id)api offline:(BOOL)offline {
    _tv = tableView;
    self.position = 0;
    
    self.contentID = block.contentID;
    self.style = style;
    
    [self downloadContentBlock:api];
}

- (void)downloadContentBlock:(XMMEnduserApi *)api {
    if (self.isLoading){
        return;
    }
    
    self.isLoading = TRUE;
  
    if ([self.contentBlocks count] > 0){
        [self addSubviewForPosition: self.position];
        return;
    }
    
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
        self.isLoading = FALSE;
        [self addSubviewForPosition:self.position];
        return;
 }];
}

- (NSBundle *)getNibBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[XMMContentBlocks class]];
    NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
    if (url) {
        return [NSBundle bundleWithURL:url];
        
    } else {
        return bundle;
    }
}

- (id)getCellFor:(int)contentBlockType by:(NSBundle *)nibBundle {
    NSString *nibName = [NSString stringWithFormat:@"XMMContentBlock%dTableViewCell", contentBlockType];
    return [nibBundle loadNibNamed:nibName owner:self options:nil].firstObject;
}

- (void)removeSubViews {
    for (UIView *subView in [self.containerView subviews]) {
      
        if(subView != self.currentSubview){
          if ([subView isKindOfClass:[XMMContentBlock2TableViewCell class]]) {
            XMMContentBlock2TableViewCell *c = (XMMContentBlock2TableViewCell *)subView;
            [c.webView removeFromSuperview];
          }
          
          [subView removeFromSuperview];
        }
    }
}

- (void)addSubviewForPosition:(int)position {
    XMMContentBlock *block = (XMMContentBlock *) self.contentBlocks[self.position];
    NSBundle *nibBundle = [self getNibBundle];
    id cell = [self getCellFor:block.blockType by:nibBundle];
    self.currentSubview = cell;
    
    if ([cell isKindOfClass:[XMMContentBlock0TableViewCell class]]) {
        // TEXT
        XMMContentBlock0TableViewCell *c = (XMMContentBlock0TableViewCell *)cell;
        [self displayText:block blockCell:c];
    } else if ([cell isKindOfClass:[XMMContentBlock3TableViewCell class]]) {
        // IMAGE
        XMMContentBlock3TableViewCell *c = (XMMContentBlock3TableViewCell *)cell;
        //[self.containerView addSubview:cell];
      if (block.fileID != nil && ![block.fileID isEqualToString:@""]) {
        [self displayImageFromURL:[NSURL URLWithString:block.fileID] blockCell:c];
      }
    } else if ([cell isKindOfClass:[XMMContentBlock2TableViewCell class]]) {
        //VIDEO
        XMMContentBlock2TableViewCell *c = (XMMContentBlock2TableViewCell *)cell;
        [self displayVideo:block blockCell:c];
    } else if ([cell isKindOfClass:[XMMContentBlock1TableViewCell class]]) {
        //AUDIO
        XMMContentBlock1TableViewCell *c = (XMMContentBlock1TableViewCell *)cell;
        [self displayAudio:block blockCell:c];
    }
}

- (void)displayAudio:(XMMContentBlock *)contentBlock blockCell:(XMMContentBlock1TableViewCell *)cell{
    cell.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, CGRectGetMaxY(cell.frame));
    [cell configureForCell:contentBlock tableView:nil indexPath:nil style:_style offline:NO];
    CGFloat height = cell.audioPlayerView.frame.size.height + cell.audioPlayerView.frame.origin.y + 15; //15 => make it as high as default audioplayer block
    cell.contentView.frame = CGRectMake(0, 0, cell.frame.size.width, height);
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, height);
    
    _containerHeight.constant = CGRectGetMaxY(cell.audioPlayerView.frame) + 20; //20 => Offset for page indicator
    
    CGPoint loc = self->_tv.contentOffset;
    [self removeSubViews];
    [self.containerView addSubview:cell];
    
    [self setNeedsLayout];
    self->_tv.estimatedRowHeight = cell.frame.size.height;
    [self->_tv beginUpdates];
    [self->_tv endUpdates];
    self->_tv.contentOffset = loc;
}

- (void)displayVideo:(XMMContentBlock *)contentBlock blockCell:(XMMContentBlock2TableViewCell *)cell{
    cell.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, CGRectGetMaxY(cell.frame));
    [cell configureForCell:contentBlock tableView:nil indexPath:nil style:_style offline:NO];
    CGFloat height = cell.webView.frame.size.height + cell.webView.frame.origin.y;
    cell.contentView.frame = CGRectMake(0, 0, cell.frame.size.width, height);
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, height);
    _containerHeight.constant = CGRectGetMaxY(cell.webView.frame);
    
    CGPoint loc = self->_tv.contentOffset;
    [self removeSubViews];
    [self.containerView addSubview:cell];
    
    [self setNeedsLayout];
    self->_tv.estimatedRowHeight = cell.frame.size.height;
    [self->_tv beginUpdates];
    [self->_tv endUpdates];
    self->_tv.contentOffset = loc;
}

- (void)displayText:(XMMContentBlock *)contentBlock blockCell:(XMMContentBlock0TableViewCell *)cell{
    [cell configureForCell:contentBlock tableView:nil indexPath:nil style:_style offline:NO];
    CGFloat height = cell.contentTextView.frame.size.height + cell.contentTextView.frame.origin.y;
    cell.contentView.frame = CGRectMake(0, 0, cell.frame.size.width, height);
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, height);
    _containerHeight.constant = CGRectGetMaxY(cell.contentTextView.frame);
    
    CGPoint loc = self->_tv.contentOffset;
    [self removeSubViews];
    [self.containerView addSubview:cell];
    
    [self setNeedsLayout];
    self->_tv.estimatedRowHeight = cell.frame.size.height;
    [self->_tv beginUpdates];
    [self->_tv endUpdates];
    self->_tv.contentOffset = loc;
}

- (void)displayImageFromURL:(NSURL *)fileURL blockCell:(XMMContentBlock3TableViewCell *)cell{
  if ([fileURL.absoluteString containsString:@".svg"]) {
    [self displaySVGFromURL:fileURL blockCell:cell];
  } else {
    [cell.imageLoadingIndicator startAnimating];
    [cell.blockImageView sd_setImageWithURL:fileURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.imageLoadingIndicator stopAnimating];
        
        CGPoint loc = self->_tv.contentOffset;
        [self removeSubViews];
        [self layoutImage:cell for:image.size];
        [self.containerView addSubview:cell];
        
        [self setNeedsLayout];
        self->_tv.estimatedRowHeight = cell.frame.size.height;
        [self->_tv beginUpdates];
        [self->_tv endUpdates];
        self->_tv.contentOffset = loc;
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
        
        CGPoint loc = self->_tv.contentOffset;
        [self removeSubViews];
        [self layoutImage:cell for:image.size];
        [self.containerView addSubview:cell];
        [self setNeedsLayout];
        self->_tv.estimatedRowHeight = cell.frame.size.height;
        [self->_tv beginUpdates];
        [self->_tv endUpdates];
        self->_tv.contentOffset = loc;
    });
    
  }] resume];
  
}

- (void)calculateImageScaling:(double)scaleX blockCell:(XMMContentBlock3TableViewCell *)cell{
  double scalingFactor = scaleX / 100;
  double newImageWidth = self.bounds.size.width * scalingFactor;
  double sizeDiff = self.bounds.size.width - newImageWidth;
  
  cell.imageLeftHorizontalSpaceConstraint.constant = sizeDiff/2;
  cell.imageRightHorizontalSpaceConstraint.constant = (sizeDiff/2)*(-1);
}

- (void)layoutImage:(XMMContentBlock3TableViewCell *)cell for:(CGSize)size {
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
    
    // Set Title, Alttext and Copyright
    BOOL hasBottomSpace = NO;
    XMMContentBlock *block = (XMMContentBlock *) self.contentBlocks[self.position];
    
    if (block.title != nil) {
      if ([block.title isEqualToString:@""]) {
        [cell.titleLabel setHidden:YES];
        cell.horizontalSpacingImageTitleConstraint.constant = 0;
      } else {
        cell.titleLabel.text = block.title;
        cell.horizontalSpacingImageTitleConstraint.constant = 8;
        hasBottomSpace = YES;
      }
    } else {
      [cell.titleLabel setHidden:YES];
      cell.horizontalSpacingImageTitleConstraint.constant = 0;
    }
    
    [cell.copyrightLabel setHidden:NO];

    if (block.copyright != nil) {
      if ([block.copyright isEqualToString:@""]) {
        [cell.copyrightLabel setHidden:YES];
      } else {
        cell.copyrightLabel.text = block.copyright;
        hasBottomSpace = YES;
      }
    } else {
      [cell.copyrightLabel setHidden:YES];
    }
    
    if (block.altText != nil && ![block.altText isEqualToString:@""]){
      cell.blockImageView.accessibilityHint = block.altText;
    } else {
      cell.blockImageView.accessibilityHint = block.title;
    }
    
    if (block.scaleX > 0) {
      [self calculateImageScaling:block.scaleX blockCell:cell];
    }
    
    double cellHeight = imageHeight;
    if (hasBottomSpace) {
      cellHeight = cellHeight + 40;
    }
    
    cell.frame = CGRectMake(0, 0, imageWidth, cellHeight);
    _containerHeight.constant = CGRectGetMaxY(cell.frame);
    [cell layoutIfNeeded];
}

- (IBAction)swipeLeft:(UISwipeGestureRecognizer*)recognizer {
  if (self.position == self.contentBlocks.count - 1) {
    return;
  }
  
  self.position = self.position + 1;
  
  [self addSubviewForPosition:self.position];
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer*)recognizer {
  if (self.position == 0) {
    return;
  }
  
  self.position = self.position - 1;
  
  [self addSubviewForPosition:self.position];
}
@end
