//
//  XMResponseContent.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMResponseContent.h"

@implementation XMResponseContent

+(RKObjectMapping *)getMapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[XMResponseContent class] ];
    [mapping addAttributeMappingsFromDictionary:@{@"description":@"descriptionOfContent",
                                                  @"language":@"language",
                                                  @"title":@"title",
                                                  @"image_public_url":@"imagePublicUrl",
                                                  }];
    return mapping;
}

@end
