//
//  XMResponseContentBlockType5.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseContentBlockType5.h"

@implementation XMMResponseContentBlockType5

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMMResponseContentBlockType5 class] ];
    [mapping addAttributeMappingsFromDictionary:@{@"file_id":@"fileId",
                                                  @"artists":@"artist",
                                                  @"public":@"publicStatus",
                                                  @"content_block_type":@"contentBlockType",
                                                  @"title":@"title",
                                                  }];
    return mapping;
}

+ (RKObjectMappingMatcher*) getDynamicMappingMatcher
{
    RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                   expectedValue:@"5"
                                                                   objectMapping:[self getMapping]];
    return matcher;
}


@end
