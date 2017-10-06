//
//  XMMListManager.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import "XMMListManager.h"
#import "XMMListItem.h"

@implementation XMMListManager

- (void)downloadContentsWith:(NSArray *)tags pageSize:(int)pageSize ascending:(Boolean)ascending position:(int)position callback:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  XMMListItem *item = [self listItemFor:position];
  if (item == nil) {
    item = [[XMMListItem alloc] initWith:tags pageSize:pageSize];
  }
  
  XMMContentSortOptions sorting = 0;
  if (ascending) {
    sorting = XMMContentSortOptionsTitle;
  }
  
  [_api contentsWithTags:tags pageSize:item.pageSize cursor:item.cursor sort:sorting completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    if (error) {
      NSLog(@"Error");
      return;
    }
    
    [item.contents addObjectsFromArray:contents];
    item.cursor = cursor;
  }];
}

- (XMMListItem *)listItemFor:(int)position {
  return [_listItems objectForKey:[NSNumber numberWithInt:position]];
}

@end
