//
//  XMMResponseContentList.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 02/04/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseContentList.h"

@implementation XMMResponseContentList

+ (RKObjectMapping*)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[XMMResponseContentList class]];
    [mapping addAttributeMappingsFromDictionary:@{@"cursor":@"cursor",
                                                  @"more":@"hasMore",
                                                  }];
    return mapping;
}

@end
