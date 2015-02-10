//
//  XMResponseContent.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 04.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMResponseGetById.h"

@implementation XMResponseGetById

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[XMResponseGetById class]];
    [mapping addAttributeMappingsFromDictionary:@{@"system_name":@"systemName",
                                                  @"system_url":@"systemUrl",
                                                  @"system_id":@"systemId",
                                                  }];
    return mapping;
}

@end
