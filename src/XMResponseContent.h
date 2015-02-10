//
//  XMResponseContent.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMEnduserApi.h"

@interface XMResponseContent : NSObject

@property (nonatomic, copy) NSString *imagePublicUrl;
@property (nonatomic, copy) NSString *descriptionOfContent;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSArray *contentBlocks;

+ (RKObjectMapping*) getMapping;

@end
