//
//  XMResponseStyle.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMEnduserApi.h"

@interface XMResponseStyle : NSObject

@property (nonatomic, copy) NSString* backgroundColor;
@property (nonatomic, copy) NSString* highlightFontColor;
@property (nonatomic, copy) NSString* foregroundFontColor;
@property (nonatomic, copy) NSString* chromeHeaderColor;
@property (nonatomic, copy) NSString* customMarker;
@property (nonatomic, copy) NSString* icon;

+ (RKObjectMapping*) getMapping;

@end
