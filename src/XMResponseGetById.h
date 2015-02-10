//
//  XMResponseContent.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 04.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMEnduserApi.h"

@class XMResponseStyle;
@class XMResponseContent;

@interface XMResponseGetById : NSObject

@property (nonatomic, copy) NSString *systemName;
@property (nonatomic, copy) NSString *systemUrl;
@property (nonatomic, copy) NSString *systemId;
@property (nonatomic) XMResponseContent *content;
@property (nonatomic) NSArray *menu;
@property (nonatomic) XMResponseStyle* style;

+ (RKObjectMapping*) getMapping;

@end

