//
//  XMMResource.h
//  XamoomSDK
//
//  Created by Raphael Seher on 15/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMMResource : NSObject

@end

@protocol XMMRestResource <NSObject>

+ (NSString *)resourceName;

@end