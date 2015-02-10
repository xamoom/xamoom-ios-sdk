//
//  XMResponseStyle.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMResponseStyle.h"

@implementation XMResponseStyle

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[XMResponseStyle class]];
    [mapping addAttributeMappingsFromDictionary:@{@"fg_color":@"foregroundFontColor",
                                                  @"bg_color":@"backgroundColor",
                                                  @"hl_color":@"highlightFontColor",
                                                  @"ch_color":@"chromeHeaderColor",
                                                  @"custom_marker":@"customMarker",
                                                  @"icon":@"icon",
                                                  }];
    return mapping;
}

@end
