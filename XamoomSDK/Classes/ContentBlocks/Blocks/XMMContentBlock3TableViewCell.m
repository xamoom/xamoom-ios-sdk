//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock3TableViewCell.h"
#import "XMMOfflineFileManager.h"
#import "XMMWebViewController.h"

@interface XMMContentBlock3TableViewCell()

@end

@implementation XMMContentBlock3TableViewCell

- (void)awakeFromNib {
  [self setupGestureRecognizers];
  [self.blockImageView setIsAccessibilityElement:YES];
  self.fileManager = [[XMMOfflineFileManager alloc] init];
  
  self.titleLabel.text = nil;
  self.copyrightLabel.text = nil;
  [super awakeFromNib];
}

- (void)setupGestureRecognizers {
  UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageToPhotoLibary:)];
  longPressGestureRecognizer.delegate = self;
  [self addGestureRecognizer:longPressGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.blockImageView removeConstraint:self.imageRatioConstraint];
  self.horizontalSpacingImageTitleConstraint.constant = 8;
  self.imageLeftHorizontalSpaceConstraint.constant = 0;
  self.imageRightHorizontalSpaceConstraint.constant = 0;
  self.imageRatioConstraint = nil;
  
  self.titleLabel.text = nil;

  [self setNeedsUpdateConstraints];
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline {
  UIColor *textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  
[_blockImageView addConstraint:[NSLayoutConstraint constraintWithItem:_blockImageView
   attribute:NSLayoutAttributeWidth
   relatedBy:NSLayoutRelationEqual
   toItem:nil
   attribute: NSLayoutAttributeNotAnAttribute
   multiplier:1
   constant:_blockImageView.superview.bounds.size.width+50]];

    
[_blockImageView addConstraint:[NSLayoutConstraint constraintWithItem:_blockImageView
  attribute:NSLayoutAttributeHeight
  relatedBy:NSLayoutRelationEqual
  toItem:nil
  attribute: NSLayoutAttributeNotAnAttribute
  multiplier:1
  constant:_blockImageView.superview.bounds.size.height+50]];
    
  if (textColor != nil) {
    self.titleLabel.textColor = textColor;
    self.copyrightLabel.textColor = textColor;
  }

  if (![block.contentID isEqualToString:@""]) {
    self.contentID = block.contentID;
  }
  
  if (![block.linkUrl isEqualToString:@""]) {
    self.linkUrl = block.linkUrl;
  }
  
  if (block.title != nil && ![block.title isEqualToString:@""]) {
    self.titleLabel.text = block.title;
    self.horizontalSpacingImageTitleConstraint.constant = 8;
  } else {
    self.horizontalSpacingImageTitleConstraint.constant = 0;
  }
  
  if (block.copyright != nil || ![block.copyright isEqualToString:@""]) {
    self.copyrightLabel.text = block.copyright;
  } else {
    self.copyrightLabel.text = @"";
  }
  
  if (block.altText != nil && ![block.altText isEqualToString:@""]){
    self.blockImageView.accessibilityHint = block.altText;
  } else {
    self.blockImageView.accessibilityHint = block.title;
  }
  
  if (block.scaleX > 0) {
    [self calculateImageScaling:block.scaleX];
  }
  
  if (offline) {
    NSURL *filePath = [self.fileManager urlForSavedData:block.fileID];
    [self displayImageFromURL:filePath tableView:tableView indexPath:indexPath];
  } else if (block.fileID != nil && ![block.fileID isEqualToString:@""]) {
    [self displayImageFromURL:[NSURL URLWithString:block.fileID] tableView:tableView indexPath:indexPath];
  }
}

- (void)calculateImageScaling:(double)scaleX {
  double scalingFactor = scaleX / 100;
  double newImageWidth = self.bounds.size.width * scalingFactor;
  double sizeDiff = self.bounds.size.width - newImageWidth;
  
  self.imageLeftHorizontalSpaceConstraint.constant = sizeDiff/2;
  self.imageRightHorizontalSpaceConstraint.constant = (sizeDiff/2)*(-1);
}

- (void)displayImageFromURL:(NSURL *)fileURL tableView:(UITableView *)tableView indexPath:(NSIndexPath *) indexPath {
  if ([fileURL.absoluteString containsString:@".svg"]) {
    [self displaySVGFromURL:fileURL tableView:tableView indexPath:indexPath];
  } else if ([fileURL.absoluteString containsString:@".gif"]) {
    [self.imageLoadingIndicator startAnimating];

    NSData *gifData = [NSData dataWithContentsOfURL:fileURL];
    self.blockImageView.image = [UIImage sd_animatedGIFWithData:gifData];
    [self.imageLoadingIndicator stopAnimating];
    [self createAspectConstraintFromImage:self.blockImageView.image.size];
    [self setNeedsUpdateConstraints];

  } else {
    [self.imageLoadingIndicator startAnimating];
    [self.blockImageView sd_setImageWithURL:fileURL
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    [self.imageLoadingIndicator stopAnimating];
                                    [self createAspectConstraintFromImage:image.size];
                                    [self setNeedsUpdateConstraints];
                                    
                                    if ([tableView.visibleCells containsObject:self]) {
                                      [tableView reloadData];
                                    }
                                  }];
  }
}

- (void)displaySVGFromURL:(NSURL *)fileURL tableView:(UITableView *)tableView indexPath:(NSIndexPath *) indexPath {
  self.blockImageView.image = nil;
  [self.imageLoadingIndicator startAnimating];
  
  [[[NSURLSession sharedSession] dataTaskWithURL:fileURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    JAMSVGImage *svgImage = [JAMSVGImage imageWithSVGData:data];
    
    float ratio = svgImage.size.width/svgImage.size.height;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *image = [svgImage imageAtSize:CGSizeMake(self.bounds.size.width, self.bounds.size.width*ratio)];

      XMMContentBlock3TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
      cell.blockImageView.image = image;
      
      [self.imageLoadingIndicator stopAnimating];
      [self createAspectConstraintFromImage:image.size];
      [self setNeedsUpdateConstraints];
    });
    
  }] resume];
  
}

- (void)createAspectConstraintFromImage:(CGSize)size {
  if (size.height <= 0 || size.width <= 0) {
    return;
  }
  
  self.imageRatioConstraint =[NSLayoutConstraint
                              constraintWithItem:self.blockImageView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.blockImageView
                              attribute:NSLayoutAttributeWidth
                              multiplier:1/(size.width/size.height)
                              constant:0.0f];
  self.imageRatioConstraint.priority = UILayoutPriorityRequired;
}

- (void)updateConstraints {
  if (self.imageRatioConstraint) {
    [self addImageRatioConstraint];
  }
  
  [super updateConstraints];
}

- (void)addImageRatioConstraint {
  [self.blockImageView addConstraint:self.imageRatioConstraint];
}

- (void)saveImageToPhotoLibary:(UILongPressGestureRecognizer*)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
    [self showAlertController];
  }
}

- (void)showAlertController {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *libBundle;
  if (url != nil) {
    libBundle = [NSBundle bundleWithURL:url];
  } else {
    libBundle = bundle;
  }

  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                           message:NSLocalizedStringFromTableInBundle(@"SaveImage", @"Localizable", libBundle, nil)
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  
  [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", libBundle, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self saveImageToPhotos];
  }]];
  
  [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Cancel", @"Localizable", libBundle, nil) style:UIAlertActionStyleCancel handler:nil]];
  
  UIViewController* activeVC = [UIApplication sharedApplication].keyWindow.rootViewController;
  [activeVC presentViewController:alertController animated:YES completion:nil];
}

- (void)saveImageToPhotos {
  UIImageWriteToSavedPhotosAlbum(self.blockImageView.image, nil, nil, nil);
}

- (void)openLink {
  if (self.linkUrl != nil) {
    NSURL *url = [NSURL URLWithString:self.linkUrl];
    [[UIApplication sharedApplication] openURL:url];
  }
}


- (void)openLink:(NSArray *)internalUrls nonInternalUrls:(NSArray *) nonInternalUrls controller:(UINavigationController *)navCon {
  if (internalUrls.count == 0) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkUrl]];
    return;
  }
    
  for (int i = 0; i < nonInternalUrls.count; i++) {
    NSString *url = nonInternalUrls[i];
    if ([self.linkUrl containsString:url]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkUrl]];
        return;
    }
  }
  
  BOOL openInternal = NO;
  
  for (int i = 0; i < internalUrls.count; i++) {
    NSString *url = internalUrls[i];
    if ([self.linkUrl containsString:url]) {
      openInternal = YES;
      break;
    }
  }
  
  if (openInternal) {
    // open internal webview
    XMMWebViewController *webViewController = [XMMWebViewController new];
    webViewController.url = self.linkUrl;
    webViewController.navigationBarColor = _webViewControllerNavigationTintColor;
    [navCon pushViewController:webViewController animated:YES];
  } else {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkUrl]];
  }
}

- (void) setWebViewControllerNavigationTintColor:(UIColor *)webViewControllerNavigationTintColor {
  _webViewControllerNavigationTintColor = webViewControllerNavigationTintColor;
}

@end
