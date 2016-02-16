//
//  XMMMapOverlayView.m
//  XamoomSDK
//
//  Created by Raphael Seher on 11/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMMapOverlayView.h"

@interface XMMMapOverlayView()

@property (nonatomic) UIImage *angleDownImage;

@end

@implementation XMMMapOverlayView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self loadAngleImage];
  }
  return self;
}

- (void)loadAngleImage {
  self.angleDownImage = [UIImage imageNamed:@"angleDown"];
}

- (void)displayAnnotation:(XMMAnnotation *)annotation {
  self.angleDownImageView.image = self.angleDownImage;
  
  self.spotTitleLabel.text = annotation.data.name;
  
  self.spotDescriptionLabel.text = annotation.data.spotDescription;
  [self.spotDistanceLabel sizeToFit];
  
  self.spotDistanceLabel.text = annotation.distance;
  
  [self.spotImageView sd_setImageWithURL:[NSURL URLWithString:annotation.data.image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //
  }];
}

- (IBAction)routeAction:(id)sender {
  NSLog(@"Route!");
}

- (IBAction)openAction:(id)sender {
  NSLog(@"Action!");
}

@end
