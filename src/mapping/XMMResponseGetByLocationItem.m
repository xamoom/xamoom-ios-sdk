//
//  XMResponseGetByLocationItems.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseGetByLocationItem.h"

@implementation XMMResponseGetByLocationItem

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[XMMResponseGetByLocationItem class]];
    [mapping addAttributeMappingsFromDictionary:@{@"system_name":@"systemName",
                                                  @"system_url":@"systemUrl",
                                                  @"system_id":@"systemId",
                                                  @"content_id":@"contentId",
                                                  @"description":@"descriptionOfContent",
                                                  @"language":@"language",
                                                  @"title":@"title",
                                                  @"style_bg_color":@"backgroundColor",
                                                  @"lat":@"lat",
                                                  @"lon":@"lon",
                                                  @"style_fg_color":@"foregroundFontColor",
                                                  @"style_icon":@"icon",
                                                  @"style_hl_color":@"highlightFontColor",
                                                  @"image_public_url":@"imagePublicUrl",
                                                  @"kind":@"kind",
                                                  }];
    return mapping;
}


@end
