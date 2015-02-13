//
//  XMResponseContentBlockType2.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseContentBlockType2.h"

@implementation XMMResponseContentBlockType2

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMMResponseContentBlockType2 class] ];
    [mapping addAttributeMappingsFromDictionary:@{@"youtube_url":@"youtubeUrl",
                                                  @"public":@"publicStatus",
                                                  @"content_block_type":@"contentBlockType",
                                                  @"title":@"title",
                                                  }];
    return mapping;
}

+ (RKObjectMappingMatcher*) getDynamicMappingMatcher
{
    RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                   expectedValue:@"2"
                                                                   objectMapping:[self getMapping]];
    return matcher;
}

@end
