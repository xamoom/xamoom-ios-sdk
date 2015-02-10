//
//  XMResponseContentBlockType7.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMResponseContentBlockType7.h"

@implementation XMResponseContentBlockType7

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMResponseContentBlockType7 class] ];
    [mapping addAttributeMappingsFromDictionary:@{@"soundcloud_url":@"soundcloudUrl",
                                                  @"public":@"publicStatus",
                                                  @"content_block_type":@"contentBlockType",
                                                  @"title":@"title",
                                                  }];
    return mapping;
}

+ (RKObjectMappingMatcher*) getDynamicMappingMatcher
{
    RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                   expectedValue:@"7"
                                                                   objectMapping:[self getMapping]];
    return matcher;
}

@end
