//
//  XMMMapOverlayView.h
//  XamoomSDK
//
//  Created by Raphael Seher on 11/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMAnnotation.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface XMMMapOverlayView : UIView

@property (weak, nonatomic) IBOutlet UILabel *spotTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *spotDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *spotDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *angleDownImageView;
@property (weak, nonatomic) IBOutlet UIImageView *spotImageView;

- (void)displayAnnotation:(XMMAnnotation *)annotation;

@end
