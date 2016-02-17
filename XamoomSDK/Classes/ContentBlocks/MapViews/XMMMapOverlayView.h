//
//  XMMMapOverlayView.h
//  XamoomSDK
//
//  Created by Raphael Seher on 11/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "XMMAnnotation.h"
#import "XMMContentBlocks.h"

@interface XMMMapOverlayView : UIView

@property (weak, nonatomic) IBOutlet UILabel *spotTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *spotDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *spotDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *spotImageView;
@property (weak, nonatomic) IBOutlet UIButton *openContentButton;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;

- (void)displayAnnotation:(XMMAnnotation *)annotation;

@end
