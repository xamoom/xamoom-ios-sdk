//
//  XMResponseMenu.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMResponseMenuItem.h"

@implementation XMResponseMenuItem

+ (RKObjectMapping*) getMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[XMResponseMenuItem class]];
    [mapping addAttributeMappingsFromDictionary:@{@"item_label":@"itemLabel",
                                                  @"content_id":@"contentId",
                                                  }];
    return mapping;
}

@end
