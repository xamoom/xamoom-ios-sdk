//
//  XMResponseGetByLocationIdentifier.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 05.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMResponseContent.h"

@interface XMResponseGetByLocationIdentifier : NSObject

@property (nonatomic, strong) NSString *systemName;
@property (nonatomic, strong) XMResponseContent *content;
@property (nonatomic, strong) NSString *systemUrl;
@property (nonatomic, strong) NSString *hasContent;
@property (nonatomic, strong) NSString *hasSpot;

@end
