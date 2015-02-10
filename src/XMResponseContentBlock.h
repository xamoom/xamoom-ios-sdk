//
//  XMResponseContentBlock.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface XMResponseContentBlock : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *publicStatus;
@property (nonatomic, copy) NSString *contentBlockType;

+ (RKObjectMapping*) getMapping;

@end
