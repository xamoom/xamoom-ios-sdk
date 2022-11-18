//
//  XMMContentBlock16TableViewCell.h
//  Pods
//
//  Created by Vladyslav on 16.11.2022.
//

#import <UIKit/UIKit.h>
#import "XMMEnduserApi.h"
#import "XMMContentBlocks.h"
#import "XMMContentBlocksCache.h"
#import "XMMStyle.h"
           
@interface XMMContentBlock16TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (nonatomic) BOOL showCBFormOverlay;
@property (weak, nonatomic) IBOutlet UILabel *coverViewLabel;


@end


@interface XMMContentBlock16TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

@end
