//
//  XMResponseContentBlockType3.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMResponseContentBlock.h"

@interface XMResponseContentBlockType3 : XMResponseContentBlock

@property (nonatomic, copy) NSString *fileId;

+ (RKObjectMapping*) getMapping;
+ (RKObjectMappingMatcher*) getDynamicMappingMatcher;


@end
