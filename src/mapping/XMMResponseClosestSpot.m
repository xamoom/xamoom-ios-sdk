//
//  XMMResponseClosestSpot.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 30/04/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseClosestSpot.h"

@implementation XMMResponseClosestSpot

+ (RKObjectMapping*)mapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[XMMResponseClosestSpot class]];
  [mapping addAttributeMappingsFromDictionary:@{@"radius":@"radius",
                                                @"limit":@"limit",
                                                }];
  return mapping;
}

@end
