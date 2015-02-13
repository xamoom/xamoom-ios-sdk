//
//  XMResponseContentBlockType6.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseContentBlockType6.h"

@implementation XMMResponseContentBlockType6

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMMResponseContentBlockType6 class] ];
    [mapping addAttributeMappingsFromDictionary:@{@"content_id":@"contentId",
                                                  @"public":@"publicStatus",
                                                  @"content_block_type":@"contentBlockType",
                                                  }];
    return mapping;
}

+ (RKObjectMappingMatcher*) getDynamicMappingMatcher
{
    RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                   expectedValue:@"6"
                                                                   objectMapping:[self getMapping]];
    return matcher;
}

@end
