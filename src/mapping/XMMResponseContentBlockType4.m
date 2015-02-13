//
//  XMResponseContentBlockType4.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseContentBlockType4.h"

@implementation XMMResponseContentBlockType4

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMMResponseContentBlockType4 class] ];
    [mapping addAttributeMappingsFromDictionary:@{@"text":@"text",
                                                  @"link_url":@"linkUrl",
                                                  @"link_type":@"linkType",
                                                  @"public":@"publicStatus",
                                                  @"content_block_type":@"contentBlockType",
                                                  @"title":@"title",
                                                  }];
    return mapping;
}

+ (RKObjectMappingMatcher*) getDynamicMappingMatcher
{
    RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                   expectedValue:@"4"
                                                                   objectMapping:[self getMapping]];
    return matcher;
}

@end
