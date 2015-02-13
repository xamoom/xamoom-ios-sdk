//
//  XMResponseContentBlockType7.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMResponseContentBlock.h"

@interface XMMResponseContentBlockType7 : XMMResponseContentBlock

@property (nonatomic, copy) NSString *soundcloudUrl;

+ (RKObjectMapping*) getMapping;
+ (RKObjectMappingMatcher*) getDynamicMappingMatcher;


@end
