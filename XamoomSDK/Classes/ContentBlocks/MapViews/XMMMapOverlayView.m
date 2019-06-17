//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMMapOverlayView.h"

@interface XMMMapOverlayView()

@property (nonatomic) NSString *contentID;
@property (nonatomic) CLLocationCoordinate2D locationCoordinate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spotImageAspectConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spotImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLabelTrailingConstraint;

@end

@implementation XMMMapOverlayView

- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor  {
  _buttonBackgroundColor = buttonBackgroundColor;
  [self changeBackgroundColors];
}

- (void)setButtonTextColor:(UIColor *)buttonTextColor  {
  _buttonTextColor = buttonTextColor;
  [self changeTextColors];
}

- (void)displayAnnotation:(XMMAnnotation *)annotation showContent:(bool)showContent {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *libBundle;
  if (url != nil) {
    libBundle = [NSBundle bundleWithURL:url];
  } else {
    libBundle = bundle;
  }
  
  [self.openContentButton setTitle:NSLocalizedStringFromTableInBundle(@"Open", @"Localizable", libBundle, nil) forState:UIControlStateNormal];
  
  self.contentID = annotation.spot.content.ID;
  self.locationCoordinate = CLLocationCoordinate2DMake(annotation.spot.latitude, annotation.spot.longitude) ;
  
  self.spotTitleLabel.text = annotation.spot.name;
  
  self.spotDescriptionLabel.text = annotation.spot.spotDescription;
  [self.spotDistanceLabel sizeToFit];
  
  self.spotDistanceLabel.text = annotation.distance;
  
  self.spotImageAspectConstraint.active = YES;
  self.spotImageWidthConstraint.constant = 153;
  self.descriptionLabelTrailingConstraint.constant = 153 + 16;
  if (annotation.spot.image == nil) {
    self.spotImageAspectConstraint.active = NO;
    self.spotImageWidthConstraint.constant = 0;
    self.descriptionLabelTrailingConstraint.constant = 0;
  }
  [self needsUpdateConstraints];

  [self.spotImageView sd_setImageWithURL:[NSURL URLWithString:annotation.spot.image] completed:nil];
  
  self.openContentButton.hidden = NO;
  if (self.contentID == nil || !showContent) {
    self.openContentButton.hidden = YES;
  }
}

- (void)changeBackgroundColors {
  [self.openContentButton setBackgroundColor:self.buttonBackgroundColor];
  [self.routeButton setBackgroundColor:self.buttonBackgroundColor];
}

- (void)changeTextColors {
  [self.openContentButton setTitleColor: _buttonTextColor forState:UIControlStateNormal];
  [self.routeButton setTitleColor: _buttonTextColor forState:UIControlStateNormal];
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
