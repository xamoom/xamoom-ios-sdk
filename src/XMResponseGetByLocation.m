//
//  XMResponseGetByLocation.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMResponseGetByLocation.h"

@implementation XMResponseGetByLocation

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[XMResponseGetByLocation class]];
    [mapping addAttributeMappingsFromDictionary:@{@"kind":@"kind",
                                                  }];
    return mapping;
}

@end
