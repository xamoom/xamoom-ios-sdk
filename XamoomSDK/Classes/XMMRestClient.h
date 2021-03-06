//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>
#import "XMMQuery.h"
#import "XMMPushDevice.h"
#import <JSONAPI/JSONAPI.h>

@protocol XMMRestClientDelegate<NSObject>

- (void)gotEphemeralId:(NSString *)ephemeralId;
- (void)gotAuthorizationId:(NSString *)authorizationId;

@end

@interface XMMRestClient : NSObject

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) XMMQuery *query;
@property (nonatomic) id<XMMRestClientDelegate> delegate;

- (instancetype)initWithBaseUrl:(NSURL *)baseUrl
                        session:(NSURLSession *)session;

- (NSURLSessionDataTask *)fetchResource:(Class)resourceClass
                                headers:(NSDictionary *)headers
                             completion:(void (^)(JSONAPI *result, NSError *error))completion;

- (NSURLSessionDataTask *)fetchResource:(Class)resourceClass
                             parameters:(NSDictionary *)parameters
                                headers:(NSDictionary *)headers
                             completion:(void (^)(JSONAPI *result, NSError *error))completion;

- (NSURLSessionDataTask *)fetchResource:(Class)resourceClass
                                     id:(NSString *)resourceId
                             parameters:(NSDictionary *)parameters
                                headers:(NSDictionary *)headers
                             completion:(void (^)(JSONAPI *result, NSError *error))completion;

- (NSURLSessionDataTask *)voucherStatusWithContentID:(NSString *)contentID
                                            clientID:(NSString *)clientID
                                             headers:(NSDictionary *)headers
                                          completion:(void (^)(JSONAPI *result, NSError *error))completion;

- (NSURLSessionDataTask *)redeemVoucherWithContentID:(NSString *)contentID
                                            clientID:(NSString *)clientID
                                          redeemCode:(NSString *)redeemCode
                                             headers:(NSDictionary *)headers
                                          completion:(void (^)(JSONAPI *result, NSError *error))completion;

- (NSURLSessionDataTask *)postPushDevice:(Class)resourceClass
                                      id:(NSString *)resourceId
                              parameters:(NSDictionary *)parameters
                                 headers:(NSDictionary *)headers
                              pushDevice:(XMMPushDevice *)device
                              completion:(void (^)(JSONAPI *result, NSError *error))completion;

@end
