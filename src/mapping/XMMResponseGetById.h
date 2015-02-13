//
//  XMResponseContent.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 04.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMEnduserApi.h"

@class XMMResponseStyle;
@class XMMResponseContent;

@interface XMMResponseGetById : NSObject

@property (nonatomic, copy) NSString *systemName;
@property (nonatomic, copy) NSString *systemUrl;
@property (nonatomic, copy) NSString *systemId;
@property (nonatomic) XMMResponseContent *content;
@property (nonatomic) NSArray *menu;
@property (nonatomic) XMMResponseStyle* style;

+ (RKObjectMapping*) getMapping;

@end

