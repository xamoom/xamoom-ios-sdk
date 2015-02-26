//
//  XMMResponseSpotMapItem.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 26/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseGetSpotMapItem.h"

@implementation XMMResponseGetSpotMapItem

+ (RKObjectMapping*)getMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[XMMResponseGetSpotMapItem class]];
    [mapping addAttributeMappingsFromDictionary:@{@"display_name":@"displayName",
                                                  @"description":@"descriptionOfContent",
                                                  @"location.lat":@"lat",
                                                  @"location.lon":@"lon",
                                                  @"image":@"image",
                                                  }];
    return mapping;
}


@end
