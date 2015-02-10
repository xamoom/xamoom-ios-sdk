//
//  XMResponseGetByLocation.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMEnduserApi.h"

@interface XMResponseGetByLocation : NSObject

@property (nonatomic) NSArray *items;
@property (nonatomic,copy) NSString *kind;

+ (RKObjectMapping*) getMapping;

@end
