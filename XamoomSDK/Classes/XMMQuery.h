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

- (NSURL *)addQueryParameterToUrl:(NSURL *)url name:(NSString *)name value:(NSString *)value;

- (NSURL *)addQueryParametersToUrl:(NSURL *)url parameters:(NSDictionary *)parameters;

@end
