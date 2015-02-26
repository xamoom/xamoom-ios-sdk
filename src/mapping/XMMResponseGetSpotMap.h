//
//  XMMResponseGetSpotMap.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 26/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMEnduserApi.h"

@interface XMMResponseGetSpotMap : NSObject

@property (nonatomic) NSArray* items;

+ (RKObjectMapping*) getMapping;

@end
