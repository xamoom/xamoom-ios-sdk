//
//  XMResponseContentBlockType9.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMResponseContentBlock.h"

@interface XMMResponseContentBlockType9 : XMMResponseContentBlock

@property (nonatomic, copy) NSString *spotMapTag;

+ (RKObjectMapping*) getMapping;
+ (RKObjectMappingMatcher*) getDynamicMappingMatcher;

@end
