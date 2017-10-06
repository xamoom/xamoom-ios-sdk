//
//  XMMListItem.h
//  XamoomSDK
//
//  Created by Raphael Seher on 06/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMMListItem : NSObject

@property (nonatomic) NSArray *tags;
@property (nonatomic) NSMutableArray *contents;
@property (nonatomic) int pageSize;
@property (nonatomic) NSString *cursor;

- (instancetype)initWith:(NSArray *)tags pageSize:(int)pageSize;

@end
