//
//  InfoAlertViewController.m
//  XamoomSDK
//
//  Created by G0yter on 11.08.2020.
//  Copyright © 2020 xamoom GmbH. All rights reserved.
//

#import "InfoAlertView.h"

@interface InfoAlertView ()

@end

@implementation InfoAlertView


- (void) setAlertValues: (NSString *) title distance: (NSString *) distance ascent: (NSString *) ascent
               descent: (NSString *) descent time: (NSString *) time {
    
    self.infoTitle.text = title;
    self.infoDistance.titleLabel.text = distance;
    self.infoAscent.titleLabel.text = ascent;
    self.infoDescent.titleLabel.text = descent;
    self.infoTime.titleLabel.text = time;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void) customInit {
    [[NSBundle mainBundle] loadNibNamed:@"InfoAlertView" owner:self options:nil];
//    [self addSubview:self.contentView];
//    self.contentView.frame = self.bounds;
}




@end
