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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldImageAspectRatioConstraint;
@property (nonatomic) NSLayoutConstraint *imageRatioConstraint;

@end

@implementation XMMContentBlock3TableViewCell

- (void)awakeFromNib {
  
  //longPressGestureRecognizer for saving images
  UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageToPhotoLibary:)];
  longPressGestureRecognizer.delegate = self;
  [self addGestureRecognizer:longPressGestureRecognizer];
  
  //tapGesture for opening links
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLink:)];
  tapGestureRecognizer.delegate = self;
  [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)saveImageToPhotoLibary:(UILongPressGestureRecognizer*)sender {
  //check if there is a SVGKImageView as Subview, because you can't save SVGImages
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bild speichern"
                                                  message:@"Willst du das Bild in dein Fotoalbum speichern?"
                                                 delegate:self
                                        cancelButtonTitle:@"Ja"
                                        otherButtonTitles:@"Abbrechen", nil];
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if(buttonIndex == 0) {
    //save image to camera roll
    UIImageWriteToSavedPhotosAlbum(self.blockImageView.image, nil, nil, nil);
  }
}

- (void)openLink:(UITapGestureRecognizer*)sender {
  if (self.linkUrl != nil && ![self.linkUrl isEqualToString:@""]) {
    NSURL *url = [NSURL URLWithString:self.linkUrl];
    [[UIApplication sharedApplication] openURL:url];
  }
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
  
  self.titleLabel.text = nil;
  [self.blockImageView setIsAccessibilityElement:YES];
  self.linkUrl = self.linkUrl;
  self.imageLeftHorizontalSpaceConstraint.constant = 0;
  self.imageRightHorizontalSpaceConstraint.constant = 0;
  
  //set title
  if (block.title != nil && ![block.title isEqualToString:@""]) {
    self.titleLabel.text = block.title;
    self.blockImageView.accessibilityHint = block.title;
  }
  
  if (block.altText != nil || [block.altText isEqualToString:@""]){
    self.blockImageView.accessibilityHint = block.altText;
  }
  
  //scale the imageView
  float scalingFactor = 1;
  if (block.scaleX < 1) {
    scalingFactor = block.scaleX / 100;
    float newImageWidth = self.bounds.size.width * scalingFactor;
    float sizeDiff = self.bounds.size.width - newImageWidth;
    
    self.imageLeftHorizontalSpaceConstraint.constant = sizeDiff/2;
    self.imageRightHorizontalSpaceConstraint.constant = (sizeDiff/2)*(-1);
  }
  
  if (block.fileID != nil) {
    [self.imageLoadingIndicator startAnimating];
    /*
     if ([self.fileId containsString:@".svg"]) {
     SVGKImage* newImage;
     newImage = [SVGKImage imageWithContentsOfURL:[NSURL URLWithString:self.fileId]];
     cell.image.image = newImage.UIImage;
     
     [cell.image removeConstraint:cell.imageRatioConstraint];
     cell.imageRatioConstraint =[NSLayoutConstraint
     constraintWithItem:cell.image
     attribute:NSLayoutAttributeWidth
     relatedBy:NSLayoutRelationEqual
     toItem:cell.image
     attribute:NSLayoutAttributeHeight
     multiplier:(newImage.size.width/newImage.size.height)
     constant:0.0f];
     
     [cell.image addConstraint:cell.imageRatioConstraint];
     [cell needsUpdateConstraints];
     if (cell.image.frame.size.height == 0 && cell.image.frame.size.width > 0) {
     [tableView reloadData];
     }
     
     [cell.imageLoadingIndicator stopAnimating];
     } else {*/
    
    self.blockImageView.backgroundColor = [UIColor blueColor];
    
    [self.blockImageView sd_setImageWithURL:[NSURL URLWithString:block.fileID]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               
                               self.imageRatioConstraint =[NSLayoutConstraint
                                                           constraintWithItem:self.blockImageView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                           toItem:self.blockImageView
                                                           attribute:NSLayoutAttributeWidth
                                                           multiplier:1/(image.size.width/image.size.height)
                                                           constant:0.0f];
                               self.imageRatioConstraint.priority = UILayoutPriorityDefaultHigh;
                               
                               [self setNeedsUpdateConstraints];
                               
                               if ([tableView.visibleCells containsObject:self]) {
                                 [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationFade];
                               }
                               
                               [self.imageLoadingIndicator stopAnimating];
                             }];
  }
}

- (void)updateConstraints {
  if (self.imageRatioConstraint) {
    [self updateImageRatioConstraint];
  }
  
  [super updateConstraints];
}

- (void)updateImageRatioConstraint {
  [self.blockImageView removeConstraint:self.oldImageAspectRatioConstraint];
  [self.blockImageView addConstraint:self.imageRatioConstraint];
}

- (void)prepareForReuse {
  [self.blockImageView removeConstraint:self.imageRatioConstraint];
}

@end
