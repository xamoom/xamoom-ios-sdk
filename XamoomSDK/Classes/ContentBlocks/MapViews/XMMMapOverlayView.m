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

- (void)displayAnnotation:(XMMAnnotation *)annotation showContent:(bool)showContent {
  self.contentID = annotation.spot.content.ID;
  self.locationCoordinate = annotation.coordinate;
  
  self.spotTitleLabel.text = annotation.spot.name;
  
  self.spotDescriptionLabel.text = annotation.spot.spotDescription;
  [self.spotDistanceLabel sizeToFit];
  
  self.spotDistanceLabel.text = annotation.distance;
  
  self.spotImageAspectConstraint.active = YES;
  self.spotImageWidthConstraint.constant = 153;
  if (annotation.spot.image == nil) {
    self.spotImageAspectConstraint.active = NO;
    self.spotImageWidthConstraint.constant = 0;
  }
  [self needsUpdateConstraints];

  [self.spotImageView sd_setImageWithURL:[NSURL URLWithString:annotation.spot.image] completed:nil];
  
  self.openContentButton.hidden = NO;
  if (self.contentID == nil || !showContent) {
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
