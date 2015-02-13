//
//  XMResponseGetByLocationIdentifier.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMResponseContent.h"

@class XMMResponseStyle;
@class XMMResponseMenuItem;

@interface XMMResponseGetByLocationIdentifier : NSObject

@property (nonatomic, copy) NSString *systemName;
@property (nonatomic, copy) NSString *systemUrl;
@property (nonatomic, copy) NSString *systemId;
@property (nonatomic, copy) NSString *hasContent;
@property (nonatomic, copy) NSString *hasSpot;
@property (nonatomic) XMMResponseContent *content;
@property (nonatomic) XMMResponseStyle *style;
@property (nonatomic) NSArray *menu;



+ (RKObjectMapping*) getMapping;

@end
