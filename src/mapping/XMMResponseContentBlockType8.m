//
//  XMResponseContentBlockType8.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMResponseContentBlockType8.h"

@implementation XMMResponseContentBlockType8

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMMResponseContentBlockType8 class] ];
    [mapping addAttributeMappingsFromDictionary:@{@"download_type":@"downloadType",
                                                  @"file_id":@"fileId",
                                                  @"public":@"publicStatus",
                                                  @"content_block_type":@"contentBlockType",
                                                  @"text":@"text",
                                                  @"title":@"title",
                                                  }];
    return mapping;
}

+ (RKObjectMappingMatcher*) getDynamicMappingMatcher
{
    RKObjectMappingMatcher* matcher = [RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type"
                                                                   expectedValue:@"8"
                                                                   objectMapping:[self getMapping]];
    return matcher;
}

@end
