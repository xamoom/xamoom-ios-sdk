//
//  XMMListManager.h
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMEnduserApi.h"

@interface XMMListManager : NSObject

@property XMMEnduserApi *api;
@property NSDictionary *listItems;
@property NSDictionary *callbacks;

- (void)downloadContentsWith:(NSArray *)tags pageSize:(int)pageSize ascending:(Boolean)ascending position:(int)position callback:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion;

@end
