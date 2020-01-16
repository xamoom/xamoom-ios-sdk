//
//  XMMContentBlockEventTableViewCell.h
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 26.09.19.
//  Copyright © 2019 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMSpot.h"
#import "XMMContent.h"
#import "XMMAnnotation.h"
#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMMContentBlockEventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UILabel *calendarTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *calendarDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *navigationDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *calendarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *navigationImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationViewTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarViewHeightConstraint;
@property (weak, nonatomic) NSNumber *navigationType;
@property (nonatomic) UIColor *calendarColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *calendarTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *navigationColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *navigationTintColor UI_APPEARANCE_SELECTOR;

- (void)setupCellWithContent:(XMMContent *)content spot:(XMMSpot *)spot;

- (UIColor *)calendarColor;
- (UIColor *)calendarTintColor;
- (UIColor *)navigationColor;
- (UIColor *)navigationTintColor;

- (void)setCalendarColor:(UIColor *)calendarColor;
- (void)setCalendarTintColor:(UIColor *)calendarTintColor;
- (void)setNavigationColor:(UIColor *)navigationColor;
- (void)setNavigationTintColor:(UIColor *)navigationTintColor;
@end

NS_ASSUME_NONNULL_END
