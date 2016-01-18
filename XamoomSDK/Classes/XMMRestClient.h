//
//  XMMRestClient.h
//  XamoomSDK
//
//  Created by Raphael Seher on 15/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMQuery.h"
#import <JSONAPI/JSONAPI.h>

@interface XMMRestClient : NSObject

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) XMMQuery *query;

- (instancetype)initWithBaseUrl:(NSURL *)baseUrl session:(NSURLSession *)session;

- (void)fetchResource:(Class)resourceClass completion:(void (^)(JSONAPI *result, NSError *error))completion;

- (void)fetchResource:(Class)resourceClass id:(NSString *)resourceId parameters:(NSDictionary *)parameters completion:(void (^)(JSONAPI *result, NSError *error))completion;

@end
