//
//  XMResponseContentBlockType4.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMResponseContentBlock.h"

@interface XMResponseContentBlockType4 : XMResponseContentBlock

@property (nonatomic, copy) NSString *linkUrl;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *linkType;


+ (RKObjectMapping*) getMapping;
+ (RKObjectMappingMatcher*) getDynamicMappingMatcher;


@end
