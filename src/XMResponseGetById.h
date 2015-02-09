//
//  XMResponseContent.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 04.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMResponseContent.h"
#import "XMResponseContentBlockType0.h"

@interface XMResponseGetById : NSObject

@property (nonatomic, copy) NSString *systemName;
@property (nonatomic, copy) NSString *systemUrl;
@property (nonatomic) XMResponseContent *content;

@end

