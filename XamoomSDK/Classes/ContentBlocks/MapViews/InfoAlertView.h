//
//  InfoAlertViewController.h
//  XamoomSDK
//
//  Created by G0yter on 11.08.2020.
//  Copyright © 2020 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoAlertView : UIView


@property (strong, nonatomic) IBOutlet InfoAlertView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *infoTitle;
@property (weak, nonatomic) IBOutlet UIButton *infoDistance;
@property (weak, nonatomic) IBOutlet UIButton *infoAscent;
@property (weak, nonatomic) IBOutlet UIButton *infoDescent;
@property (weak, nonatomic) IBOutlet UIButton *infoTime;
@property (weak, nonatomic) IBOutlet UILabel *infoTimeDescription;


- (void) setAlertValues: (NSString *) title distance: (NSString *) distance ascent: (NSString *) ascent
    descent: (NSString *) descent time: (NSString *) time;



@end

