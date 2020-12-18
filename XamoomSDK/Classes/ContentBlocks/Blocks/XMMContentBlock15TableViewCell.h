//
//  XMMContentBlock15TableViewCell.h
//  XamoomSDK
//
//  Created by G0yter on 11.12.2020.
//  Copyright © 2020 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMEnduserApi.h"
#import "XMMContentBlocks.h"
#import "XMMContentBlocksCache.h"
#import "XMMStyle.h"

@interface XMMContentBlock15TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;

@end


@interface XMMContentBlock15TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

@end

