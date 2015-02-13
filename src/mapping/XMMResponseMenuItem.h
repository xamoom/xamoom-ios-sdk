//
//  XMResponseMenu.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMEnduserApi.h"

@interface XMMResponseMenuItem : NSObject

@property (nonatomic, copy) NSString* itemLabel;
@property (nonatomic, copy) NSString* contentId;

+ (RKObjectMapping*) getMapping;

@end
