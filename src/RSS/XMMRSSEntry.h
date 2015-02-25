//
//  XMMRSSEntry.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 25/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMMRSSEntry : NSObject

@property (copy) NSString *title;
@property (copy) NSString *link;
@property (copy) NSString *comments;
@property (copy) NSDate *pubDate;
@property (copy) NSString *category;
@property (copy) NSString *guid;
@property (copy) NSString *descriptionOfContent;
@property (copy) NSString *content;
@property (copy) NSString *wfw;
@property (copy) NSString *slash;

- (NSString*)description;

@end
