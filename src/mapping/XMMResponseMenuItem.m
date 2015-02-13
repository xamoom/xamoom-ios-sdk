//
//  XMResponseMenu.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseMenuItem.h"

@implementation XMMResponseMenuItem

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[XMMResponseMenuItem class]];
    [mapping addAttributeMappingsFromDictionary:@{@"item_label":@"itemLabel",
                                                  @"content_id":@"contentId",
                                                  }];
    return mapping;
}

@end
