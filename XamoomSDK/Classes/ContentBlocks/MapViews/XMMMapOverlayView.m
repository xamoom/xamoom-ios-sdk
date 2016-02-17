//
//  XMMMapOverlayView.m
//  XamoomSDK
//
//  Created by Raphael Seher on 11/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMMapOverlayView.h"

@interface XMMMapOverlayView()

@property (nonatomic) NSString *contentID;
@property (nonatomic) CLLocationCoordinate2D locationCoordinate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spotImageAspectConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spotImageWidthConstraint;

@end

@implementation XMMMapOverlayView

- (void)displayAnnotation:(XMMAnnotation *)annotation {
  self.contentID = annotation.data.content.ID;
  self.locationCoordinate = annotation.coordinate;
  
  self.spotTitleLabel.text = annotation.data.name;
  
  self.spotDescriptionLabel.text = annotation.data.spotDescription;
  [self.spotDistanceLabel sizeToFit];
  
  self.spotDistanceLabel.text = annotation.distance;
  
  self.spotImageAspectConstraint.active = YES;
  self.spotImageWidthConstraint.constant = 153;
  if (annotation.data.image == nil) {
    self.spotImageAspectConstraint.active = NO;
    self.spotImageWidthConstraint.constant = 0;
  }
  [self needsUpdateConstraints];

  [self.spotImageView sd_setImageWithURL:[NSURL URLWithString:annotation.data.image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //
  }];
  
  self.openContentButton.hidden = NO;
  if (self.contentID == nil || [self.contentID isEqualToString:@""]) {
    self.openContentButton.hidden = YES;
  }
}

- (IBAction)routeAction:(id)sender {
  MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.locationCoordinate addressDictionary:nil];
  
  MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
  mapItem.name = self.spotTitleLabel.text;
  
  NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
  [mapItem openInMapsWithLaunchOptions:launchOptions];
}

- (IBAction)openAction:(id)sender {
  NSDictionary *userInfo = @{@"contentID":self.contentID};
  [[NSNotificationCenter defaultCenter]
   postNotificationName:XMMContentBlocks.kContentBlock9MapContentLinkNotification
   object:self userInfo:userInfo];
}

@end
