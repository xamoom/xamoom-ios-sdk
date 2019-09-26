//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <UIKit/UIKit.h>
#import "XMMContentBlock.h"
#import "XMMStyle.h"
#import "UIColor+HexString.h"
#import "XMMSpot.h"

/**
 * XMMContentBlock0TableViewCell is used to display text contentBlocks from the xamoom cloud.
 */
@interface XMMContentBlock100TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (strong, nonatomic) XMMSpot *relatedSpot;
@property (strong, nonatomic) NSDate *eventStartDate;
@property (strong, nonatomic) NSDate *eventEndDate;
@property (strong, nonatomic) NSString *chromeColor;
@property (weak, nonatomic) IBOutlet UIImageView *eventTimeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *eventLocationImageView;
@property (weak, nonatomic) NSNumber *navigationType;
@property (strong, nonatomic) NSString *contentTilte;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelHeightConstraint;

+ (int)fontSize;
+ (void)setFontSize:(int)fontSize;

@end

@interface XMMContentBlock100TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

@end
