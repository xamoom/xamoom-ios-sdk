//
//  RMResponseContentBlockType0.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMResponseContentBlockType0.h"

@implementation XMResponseContentBlockType0

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMResponseContentBlockType0 class] ];
    [mapping addAttributeMappingsFromDictionary:@{@"text":@"text",
                                                  @"public":@"publicStatus",
                                                  @"content_block_type":@"contentBlockType",
                                                  @"title":@"title",
                                                  }];
    return mapping;
}

+ (RKObjectMappingMatcher*) getDynamicMappingMatcher
{
    RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                   expectedValue:@"0"
                                                                   objectMapping:[self getMapping]];
    return matcher;
}

@end
