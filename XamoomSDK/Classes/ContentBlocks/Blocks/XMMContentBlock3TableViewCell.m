//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import "XMMContentBlock3TableViewCell.h"

@interface XMMContentBlock3TableViewCell()

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *imageLeftHorizontalSpaceConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *imageRightHorizontalSpaceConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpacingImageTitleConstraint;
@property (nonatomic) NSLayoutConstraint *imageRatioConstraint;

@end

@implementation XMMContentBlock3TableViewCell

- (void)awakeFromNib {
  [self setupGestureRecognizers];
  [self.blockImageView setIsAccessibilityElement:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareForReuse {
  [self.blockImageView removeConstraint:self.imageRatioConstraint];
  self.horizontalSpacingImageTitleConstraint.constant = 8;
  self.imageLeftHorizontalSpaceConstraint.constant = 0;
  self.imageRightHorizontalSpaceConstraint.constant = 0;
  self.imageRatioConstraint = nil;
  
  self.titleLabel.text = nil;

  [self setNeedsUpdateConstraints];
}

- (void)setupGestureRecognizers {
  UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageToPhotoLibary:)];
  longPressGestureRecognizer.delegate = self;
  [self addGestureRecognizer:longPressGestureRecognizer];
  
  //tapGesture for opening links
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLink:)];
  tapGestureRecognizer.delegate = self;
  [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)saveImageToPhotoLibary:(UILongPressGestureRecognizer*)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bild speichern"
                                                    message:@"Willst du das Bild in dein Fotoalbum speichern?"
                                                   delegate:self
                                          cancelButtonTitle:@"Ja"
                                          otherButtonTitles:@"Abbrechen", nil];
    [alert show];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if(buttonIndex == 0) {
    //save image to camera roll
    UIImageWriteToSavedPhotosAlbum(self.blockImageView.image, nil, nil, nil);
  }
}

- (void)openLink:(UITapGestureRecognizer*)sender {
  if (self.linkUrl != nil) {
    NSURL *url = [NSURL URLWithString:self.linkUrl];
    [[UIApplication sharedApplication] openURL:url];
  }
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
  if (![block.linkUrl isEqualToString:@""]) {
    self.linkUrl = block.linkUrl;
  }

  if (block.title != nil && ![block.title isEqualToString:@""]) {
    self.titleLabel.text = block.title;
    self.blockImageView.accessibilityHint = block.title;
  } else {
    self.horizontalSpacingImageTitleConstraint.constant = 0;
  }
  
  if (block.altText != nil || [block.altText isEqualToString:@""]){
    self.blockImageView.accessibilityHint = block.altText;
  }
  
  if (block.scaleX < 100) {
    [self calculateImageScaling:block.scaleX];
  }
  
  if (block.fileID != nil) {
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
  } else {
    [self.imageLoadingIndicator startAnimating];
    [self.blockImageView sd_setImageWithURL:fileURL
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    [self.imageLoadingIndicator stopAnimating];
                                    [self createAspectConstraintFromImage:image.size];
                                    [self setNeedsUpdateConstraints];
                                    
                                    if ([tableView.visibleCells containsObject:self]) {
                                      NSLog(@"Visible cells: %lu", (unsigned long)tableView.visibleCells.count);
                                      NSLog(@"self: %ld", (long)indexPath.row);
                                      
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
    UIImage *image = [svgImage imageAtSize:CGSizeMake(self.bounds.size.width, self.bounds.size.width*ratio)];

    dispatch_async(dispatch_get_main_queue(), ^{
      XMMContentBlock3TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
      cell.blockImageView.image = image;
      
      [self.imageLoadingIndicator stopAnimating];
      [self createAspectConstraintFromImage:image.size];
      [self setNeedsUpdateConstraints];
    });
    
  }] resume];
  
}

- (void)createAspectConstraintFromImage:(CGSize)size {
  self.imageRatioConstraint =[NSLayoutConstraint
                              constraintWithItem:self.blockImageView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.blockImageView
                              attribute:NSLayoutAttributeWidth
                              multiplier:1/(size.width/size.height)
                              constant:0.0f];
  self.imageRatioConstraint.priority = UILayoutPriorityRequired;
  self.imageRatioConstraint.identifier = @"Die da, die Freitags nie kann.";
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

@end
