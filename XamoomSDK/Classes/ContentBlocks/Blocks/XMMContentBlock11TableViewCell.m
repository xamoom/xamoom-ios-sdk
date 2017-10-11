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

@property (nonatomic, strong) UITableView *parentTableView;
@property (nonatomic, strong) XMMListManager *listManager;
@property (nonatomic, strong) NSIndexPath *parentIndexPath;
@property (nonatomic, strong) XMMContentBlocks *contentBlocks;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadMoreButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadMoreButtonTopConstraint;

@end

@implementation XMMContentBlock11TableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  _tableView.contentInset = UIEdgeInsetsMake(-16, 0, 0, 0);
  _tableView.scrollEnabled = NO;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  //_loadMoreButton.titleLabel.text = @"Load more";
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _loadMoreButtonTopConstraint.constant = 8;
  _loadMoreButtonHeightConstraint.constant = 39;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)layoutSubviews {
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api listManager:(XMMListManager *)listManager position:(NSInteger)position offline:(BOOL)offline {
  _listManager = listManager;
  _parentTableView = tableView;
  _parentIndexPath = indexPath;
  
  if (_contentBlocks == nil) {
    _contentBlocks = [[XMMContentBlocks alloc] initWithTableView:_tableView api:api];
  }
  
  if (block.title != nil && ![block.title isEqualToString:@""]) {
    _titleLabel.text = block.title;
  }
  
  _loadMoreButton.hidden = YES;
  _activityIndicator.hidden = NO;
  
  XMMListItem *listItem = [listManager listItemFor: (int)indexPath.row];
  if (listItem != nil && listItem.contents.count > 0) {
    _activityIndicator.hidden = YES;
    if (listItem.hasMore) {
      _loadMoreButton.hidden = NO;
    } else {
      [self hideLoadMoreButtonWithConstraints];
    }
    
    _tableViewHeightConstraint.constant = 89 * listItem.contents.count;
    [self setNeedsLayout];
    
    [_contentBlocks displayContent: [self generateContentsFrom:listItem.contents]];
    /*
     if (listItem.contents.count == _contentBlocks.items.count) {
     return;
     }
     
     NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
     int index = listItem.contents.count - _contentBlocks.items.count;
     if (index < 0 || _contentBlocks.items.count == 0) {
     index = 0;
     }
     while (index < listItem.contents.count) {
     [indexPaths addObject:[NSIndexPath indexPathForItem:index inSection:0]];
     index += 1;
     }
     [_tableView beginUpdates];
     _contentBlocks.items = [[self generateContentsFrom:listItem.contents] contentBlocks];
     [_tableView insertRowsAtIndexPaths:indexPaths
     withRowAnimation:UITableViewRowAnimationNone];
     [_tableView endUpdates];
     */
    
    
  } else {
    [self loadContentWith:block.contentListTags pageSize:block.contentListPageSize ascending:block.contentListSortAsc position:(int)indexPath.row];
  }
}

- (IBAction)didClickLoadMore:(id)sender {
  [self showLoading];
  
  XMMListItem *listItem = [_listManager listItemFor: (int)_parentIndexPath.row];
  [self loadContentWith:listItem.tags pageSize:listItem.pageSize ascending:listItem.sortAsc position:(int)_parentIndexPath.row];
}

- (void)loadContentWith:(NSArray *)tags pageSize:(int)pageSize ascending:(Boolean)ascending position:(int)position {
  [_listManager downloadContentsWith:tags pageSize:pageSize ascending:ascending position:(int)position callback:^(NSArray *contents, bool hasMore, int position, NSError *error) {
    _activityIndicator.hidden = YES;
    
    if (error != nil) {
      [self hideLoadMoreButtonWithConstraints];
      return;
    }
    
    if (hasMore) {
      _loadMoreButton.hidden = NO;
    } else {
      [self hideLoadMoreButtonWithConstraints];
    }
    
    _tableViewHeightConstraint.constant = 89 * contents.count;
    [self setNeedsLayout];
    
    [_contentBlocks displayContent: [self generateContentsFrom:contents]];
    //[_parentTableView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:position inSection:0];
    [_parentTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
  }];
}

- (void)showLoading {
  _loadMoreButton.hidden = YES;
  _activityIndicator.hidden = NO;
  [_activityIndicator stopAnimating];
}

- (void)hideLoadMoreButtonWithConstraints {
  _loadMoreButton.hidden = YES;
  _loadMoreButtonTopConstraint.constant = 0;
  _loadMoreButtonHeightConstraint.constant = 0;
  
  [self setNeedsLayout];
}

- (XMMContent *)generateContentsFrom:(NSArray *)contents {
  NSMutableArray *contentBlocks = [[NSMutableArray alloc] init];
  for (XMMContent *content in contents) {
    XMMContentBlock *block = [[XMMContentBlock alloc] init];
    block.contentID = content.ID;
    block.blockType = 6;
    [contentBlocks addObject:block];
  }
  
  XMMContent *content = [[XMMContent alloc] init];
  content.contentBlocks = contentBlocks;
  
  return content;
}

@end