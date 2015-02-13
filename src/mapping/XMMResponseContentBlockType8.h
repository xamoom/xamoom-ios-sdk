//
//  XMResponseContentBlockType8.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMResponseContentBlock.h"

@interface XMMResponseContentBlockType8 : XMMResponseContentBlock

@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSString *downloadType;
@property (nonatomic, copy) NSString *text;

+ (RKObjectMapping*) getMapping;
+ (RKObjectMappingMatcher*) getDynamicMappingMatcher;


@end
