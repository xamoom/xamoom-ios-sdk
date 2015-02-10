//
//  XMResponseGetByLocationIdentifier.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMResponseGetByLocationIdentifier.h"

@implementation XMResponseGetByLocationIdentifier

+(RKObjectMapping *)getMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[XMResponseGetByLocationIdentifier class]];
    [mapping addAttributeMappingsFromDictionary:@{@"system_name":@"systemName",
                                                  @"system_url":@"systemUrl",
                                                  @"system_id":@"systemId",
                                                  @"has_content":@"hasContent",
                                                  @"has_spot":@"hasSpot",
                                                  }];
    return mapping;
}

@end
