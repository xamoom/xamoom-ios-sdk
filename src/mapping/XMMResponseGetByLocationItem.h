//
//  XMResponseGetByLocationItems.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMEnduserApi.h"

@interface XMMResponseGetByLocationItem : NSObject

@property (nonatomic, copy) NSString *systemName;
@property (nonatomic, copy) NSString *systemUrl;
@property (nonatomic, copy) NSString *systemId;
@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *descriptionOfContent;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *foregroundFontColor;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *highlightFontColor;
@property (nonatomic, copy) NSString *imagePublicUrl;
@property (nonatomic, copy) NSString *kind;

+ (RKObjectMapping*) getMapping;

@end
