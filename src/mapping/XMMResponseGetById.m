//
//  XMResponseContent.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 04.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseGetById.h"

@implementation XMMResponseGetById

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[XMMResponseGetById class]];
    [mapping addAttributeMappingsFromDictionary:@{@"system_name":@"systemName",
                                                  @"system_url":@"systemUrl",
                                                  @"system_id":@"systemId",
                                                  }];
    return mapping;
}

@end
