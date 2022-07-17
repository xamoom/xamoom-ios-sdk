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
#import <WebKit/WebKit.h>

/**
 * XMMContentBlock0TableViewCell is used to display text contentBlocks from the xamoom cloud.
 */
@interface XMMContentBlock0TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
  @property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
  @property (weak, nonatomic) IBOutlet NSLayoutConstraint *copyrightHeight;
  
+ (int)fontSize;
+ (void)setFontSize:(int)fontSize;

@end

@interface XMMContentBlock0TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

@end
