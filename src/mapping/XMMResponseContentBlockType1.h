//
//  XMResponseContentBlockType1.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMResponseContentBlock.h"



@interface XMMResponseContentBlockType1 : XMMResponseContentBlock

@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSString *artist;

+ (RKObjectMapping*) getMapping;
+ (RKObjectMappingMatcher*) getDynamicMappingMatcher;

@end