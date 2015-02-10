//
//  XMResponseContentBlockType6.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMResponseContentBlock.h"

@interface XMResponseContentBlockType6 : XMResponseContentBlock

@property (nonatomic, copy) NSString *contentId;

+ (RKObjectMapping*) getMapping;
+ (RKObjectMappingMatcher*) getDynamicMappingMatcher;


@end
