//
//  XMResponseContentBlockType2.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

//YOUTUBE

#import <Foundation/Foundation.h>
#import "XMResponseContentBlock.h"

@interface XMResponseContentBlockType2 : XMResponseContentBlock

@property (nonatomic, copy) NSString *youtubeUrl;

+ (RKObjectMapping*) getMapping;
+ (RKObjectMappingMatcher*) getDynamicMappingMatcher;


@end
