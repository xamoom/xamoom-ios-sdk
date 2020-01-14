//
//  XMMContentBlock11TableViewCell.h
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMContentBlock.h"
#import "XMMStyle.h"
#import "XMMEnduserApi.h"
#import "XMMListManager.h"
#import "UIColor+HexString.h"

@interface XMMContentBlock11TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIColor *loadMoreButtonColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *loadMoreButtonTintColor UI_APPEARANCE_SELECTOR;
@property (weak, nonatomic) IBOutlet UIButton *loadMoreButton;

-(void)setLoadMoreButtonColor:(UIColor *)loadMoreButtonColor;
-(void)setLoadMoreButtonTintColor:(UIColor *)loadMoreButtonTintColor;

-(UIColor *)loadMoreButtonColor;
-(UIColor *)loadMoreButtonTintColor;

@end

@interface XMMContentBlock11TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api listManager:(XMMListManager *)listManager offline:(BOOL)offline delegate:(id)delegate;

@end
