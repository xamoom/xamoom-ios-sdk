//
//  XMMResponseSpotMapItem.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 26/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMEnduserApi.h"

@interface XMMResponseGetSpotMapItem : NSObject

@property (nonatomic, copy) NSString* displayName;
@property (nonatomic, copy) NSString* descriptionOfContent;
@property (nonatomic, copy) NSString* lat;
@property (nonatomic, copy) NSString* lon;
@property (nonatomic, copy) NSString* image;

+ (RKObjectMapping*)getMapping;

@end
