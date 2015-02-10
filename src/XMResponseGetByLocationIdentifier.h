//
//  XMResponseGetByLocationIdentifier.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMResponseContent.h"

@class XMResponseStyle;
@class XMResponseMenuItem;

@interface XMResponseGetByLocationIdentifier : NSObject

@property (nonatomic, copy) NSString *systemName;
@property (nonatomic, copy) NSString *systemUrl;
@property (nonatomic, copy) NSString *systemId;
@property (nonatomic, copy) NSString *hasContent;
@property (nonatomic, copy) NSString *hasSpot;
@property (nonatomic) XMResponseContent *content;
@property (nonatomic) XMResponseStyle *style;
@property (nonatomic) NSArray *menu;



+ (RKObjectMapping*) getMapping;

@end
