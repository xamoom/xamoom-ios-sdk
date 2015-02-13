//
//  XMResponseContentBlockType1.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseContentBlockType1.h"

@implementation XMMResponseContentBlockType1


+ (RKObjectMapping *)getMapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMMResponseContentBlockType1 class] ];
    [mapping addAttributeMappingsFromDictionary:@{@"file_id":@"fileId",
                                                  @"public":@"publicStatus",
                                                  @"content_block_type":@"contentBlockType",
                                                  @"title":@"title",
                                                  @"artists":@"artist",
                                                  }];
    return mapping;
}

+ (RKObjectMappingMatcher*) getDynamicMappingMatcher
{
    RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                   expectedValue:@"1"
                                                                   objectMapping:[self getMapping]];
    return matcher;
}

@end
