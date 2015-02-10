//
//  XMResponseContentBlockType3.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMResponseContentBlockType3.h"

@implementation XMResponseContentBlockType3

+ (RKObjectMapping *)getMapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMResponseContentBlockType3 class] ];
    [mapping addAttributeMappingsFromDictionary:@{@"file_id":@"fileId",
                                                  @"public":@"publicStatus",
                                                  @"content_block_type":@"contentBlockType",
                                                  @"title":@"title",
                                                  }];
    return mapping;
}

+ (RKObjectMappingMatcher*) getDynamicMappingMatcher
{
    RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                   expectedValue:@"3"
                                                                   objectMapping:[self getMapping]];
    return matcher;
}

@end
