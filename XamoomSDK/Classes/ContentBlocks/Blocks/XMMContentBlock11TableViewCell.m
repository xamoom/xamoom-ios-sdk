//
//  XMMContentBlock11TableViewCell.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import "XMMContentBlock11TableViewCell.h"
#import "XMMContentBlocks.h"
#import "XMMListManager.h"

@interface XMMContentBlock11TableViewCell()

@property (nonatomic, strong) XMMContentBlocks *contentBlocks;

@end

@implementation XMMContentBlock11TableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api listManager:(XMMListManager *)listManager position:(NSInteger)position offline:(BOOL)offline {
  if (_contentBlocks == nil) {
    _contentBlocks = [[XMMContentBlocks alloc] initWithTableView:_tableView api:api];
  }
  
  if (block.title != nil && ![block.title isEqualToString:@""]) {
    _titleLabel.text = block.title;
  }
  
  [listManager downloadContentsWith:block.contentListTags pageSize:block.contentListPageSize ascending:block.contentListSortAsc position:(int)position callback:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    //
  }];
  
  [_contentBlocks viewWillAppear];
}

@end
