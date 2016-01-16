//
//  XMMQuery.h
//  XamoomSDK
//
//  Created by Raphael Seher on 15/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMResource.h"

@interface XMMQuery : NSObject

@property (strong, nonatomic) NSURL *baseUrl;

- (instancetype)initWithBaseUrl:(NSURL *)url;

- (NSURL *)urlWithResource:(Class <XMMRestResource>)resourceClass;

- (NSURL *)urlWithResource:(Class)resourceClass id:(NSString *)resourceId;

- (NSURL *)addQueryParamtersToUrl:(NSURL *)url name:(NSString *)name value:(NSString *)value;

- (NSURL *)addQueryParamtersToUrl:(NSURL *)url paramters:(NSDictionary *)paramters;

- (NSURL *)extendUrl:(NSURL *)url message:(NSString *)message;

@end
