//
//  XMResponseGetByLocationIdentifier.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseGetByLocationIdentifier.h"

@implementation XMMResponseGetByLocationIdentifier

+(RKObjectMapping *)getMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[XMMResponseGetByLocationIdentifier class]];
    [mapping addAttributeMappingsFromDictionary:@{@"system_name":@"systemName",
                                                  @"system_url":@"systemUrl",
                                                  @"system_id":@"systemId",
                                                  @"has_content":@"hasContent",
                                                  @"has_spot":@"hasSpot",
                                                  }];
    return mapping;
}

@end
