//
//  XMMContentBlock11TableViewCell.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import "XMMContentBlock11TableViewCell.h"
#import "XMMContentBlocks.h"

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

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api listManager:(id)listManager offline:(BOOL)offline {
  _contentBlocks = [[XMMContentBlocks alloc] initWithTableView:_tableView api:api];
  
  block.ID = @"21401059125125";
  block.blockType = 6;
  block.contentID = @"7cf2c58e6d374ce3888c32eb80be53b5";
  block.title = @"Hello";
  block.contentListSortAsc = true;
  block.contentListPageSize = 11;
  block.contentListTags = @[@"test1", @"test2"];
  
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"1294810294";
  content.contentBlocks = [NSArray arrayWithObject:block];
  
  //[_contentBlocks displayContent:content];
  //[_contentBlocks viewWillAppear];
}

@end
