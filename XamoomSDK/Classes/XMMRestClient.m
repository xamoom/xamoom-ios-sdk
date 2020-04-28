//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMRestClient.h"
#import "JSONAPIResourceParser.h"
#import "JSONAPIErrorResource.h"

@implementation XMMRestClient

static const NSString *EPHEMERAL_ID_HEADER = @"X-Ephemeral-Id";
static const NSString *AUTHORIZATION_ID_HEADER = @"Authorization";

- (instancetype)initWithBaseUrl:(NSURL *)baseUrl session:(NSURLSession *)session {
  self = [super init];
  self.query = [[XMMQuery alloc] initWithBaseUrl:baseUrl];
  self.session = session;
  return self;
}

- (NSURLSessionDataTask *)fetchResource:(Class)resourceClass
                                headers:(NSDictionary *)headers
                             completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSURL *requestUrl = [self.query urlWithResource:resourceClass];
  return [self makeRestCall:requestUrl
                    headers:headers
                 completion:completion];
}

- (NSURLSessionDataTask *)fetchResource:(Class)resourceClass
                             parameters:(NSDictionary *)parameters
                                headers:(NSDictionary *)headers
                             completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSURL *requestUrl = [self.query urlWithResource:resourceClass];
  requestUrl = [self.query addQueryParametersToUrl:requestUrl parameters:parameters];
  return [self makeRestCall:requestUrl
                    headers:headers
                 completion:completion];
}

- (NSURLSessionDataTask *)fetchResource:(Class)resourceClass
                                     id:(NSString *)resourceId
                             parameters:(NSDictionary *)parameters
                                headers:(NSDictionary *)headers
                             completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSURL *requestUrl = [self.query urlWithResource:resourceClass id:resourceId];
  requestUrl = [self.query addQueryParametersToUrl:requestUrl parameters:parameters];
  return [self makeRestCall:requestUrl
                    headers:headers
                 completion:completion];
}

- (NSURLSessionDataTask *)voucherStatusWithContentID:(NSString *)contentID
                                            clientID:(NSString *)clientID
                                             headers:(NSDictionary *)headers
                                          completion:(void (^)(JSONAPI *result, NSError *error))completion {

  NSString *resourcePath = @"consumer/voucher/status";
  NSURL *requestUrl = [[[self.query.baseUrl URLByAppendingPathComponent:resourcePath] URLByAppendingPathComponent:contentID] URLByAppendingPathComponent:clientID];
  
  NSURLComponents *components = [NSURLComponents componentsWithURL:requestUrl resolvingAgainstBaseURL:NO];
  components.queryItems = [NSArray arrayWithObject: [NSURLQueryItem queryItemWithName:@"timestamp" value:[NSString stringWithFormat:@"%f",
                                                                                 [[NSDate date] timeIntervalSince1970]]]];
  
  requestUrl = components.URL;
  
  return [self makeRestCall:requestUrl
                    headers:headers
                 completion:completion];
}

- (NSURLSessionDataTask *)redeemVoucherWithContentID:(NSString *)contentID
                                            clientID:(NSString *)clientID
                                          redeemCode:(NSString *)redeemCode
                                             headers:(NSDictionary *)headers
                                          completion:(void (^)(JSONAPI *result, NSError *error))completion {
  
  NSString *resourcePath = @"consumer/voucher/redeem";
  NSURL *requestUrl = [[[[self.query.baseUrl URLByAppendingPathComponent:resourcePath] URLByAppendingPathComponent:contentID]     URLByAppendingPathComponent:clientID] URLByAppendingPathComponent:redeemCode];
  
  NSURLComponents *components = [NSURLComponents componentsWithURL:requestUrl resolvingAgainstBaseURL:NO];
  components.queryItems = [NSArray arrayWithObject: [NSURLQueryItem queryItemWithName:@"timestamp" value:[NSString stringWithFormat:@"%f",
                                                                                 [[NSDate date] timeIntervalSince1970]]]];
  
  requestUrl = components.URL;
  
  return [self makeRestCall:requestUrl
                    headers:headers
                 completion:completion];
}

- (NSURLSessionDataTask *)postPushDevice:(Class)resourceClass
                                     id:(NSString *)resourceId
                             parameters:(NSDictionary *)parameters
                                headers:(NSDictionary *)headers
                              pushDevice:(XMMPushDevice *)device
                             completion:(void (^)(JSONAPI *result, NSError *error))completion {
  
  NSURL *requestUrl = [self.query urlWithResource:resourceClass id:resourceId];
  return [self postPushDevice:requestUrl
                    headers:headers
                 pushDevice:device
                 completion:completion];
}

- (NSURLSessionDataTask *)postPushDevice:(NSURL *)url
                               headers:(NSDictionary *)headers
                              pushDevice:(XMMPushDevice *)device
                            completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
  [request setAllHTTPHeaderFields:headers];
  [request setHTTPMethod:@"POST"];
  
  NSDictionary *jsonFromObject = [JSONAPIResourceParser dictionaryFor:device];
  
  if ([NSJSONSerialization isValidJSONObject:jsonFromObject]) {
    NSDictionary *jsonBody = @{@"data" : jsonFromObject};
    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:jsonBody options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:bodyData];
  }

  NSURLSessionDataTask *task =
  [self.session
   dataTaskWithRequest:request
   completionHandler:^(NSData * _Nullable data,
                       NSURLResponse * _Nullable response,
                       NSError * _Nullable error) {
     JSONAPI *jsonApi;
     
     NSHTTPURLResponse *urlResponse = ((NSHTTPURLResponse *)response);
     [self checkHeaders:[urlResponse allHeaderFields]];
     
     if (error) {
       dispatch_async(dispatch_get_main_queue(), ^{
         completion(jsonApi, error);
       });
       
       return;
     }
     
     jsonApi = [self jsonApiFromData:data];
     
     if (jsonApi.errors != nil) {
       NSLog(@"JSONAPI Error: %@", jsonApi.errors);
       JSONAPIErrorResource *apierror = jsonApi.errors.firstObject;
       
       NSDictionary *userInfo = @{@"code":apierror.code,
                                  @"status":apierror.status,
                                  @"title":apierror.title,
                                  @"detail":apierror.detail,};
       NSError *error = [NSError errorWithDomain:@"com.xamoom"
                                            code:[apierror.code intValue]
                                        userInfo:userInfo];
       
       dispatch_async(dispatch_get_main_queue(), ^{
         completion(jsonApi, error);
       });
       return;
     }
     
     dispatch_async(dispatch_get_main_queue(), ^{
       completion(jsonApi, error);
     });
   }];
  [task resume];
  return task;
}

- (NSURLSessionDataTask *)makeRestCall:(NSURL *)url
                               headers:(NSDictionary *)headers
                            completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
  [request setAllHTTPHeaderFields:headers];
  
  NSURLSessionDataTask *task =
  [self.session
   dataTaskWithRequest:request
   completionHandler:^(NSData * _Nullable data,
                       NSURLResponse * _Nullable response,
                       NSError * _Nullable error) {
     JSONAPI *jsonApi;
     
     NSHTTPURLResponse *urlResponse = ((NSHTTPURLResponse *)response);
     [self checkHeaders:[urlResponse allHeaderFields]];
     
     if (error) {
       dispatch_async(dispatch_get_main_queue(), ^{
         completion(jsonApi, error);
       });
       
       return;
     }
     
     jsonApi = [self jsonApiFromData:data];
     
     if (jsonApi.errors != nil) {
       NSLog(@"JSONAPI Error: %@", jsonApi.errors);
       JSONAPIErrorResource *apierror = jsonApi.errors.firstObject;
       
       NSDictionary *userInfo = @{@"code":apierror.code,
                                  @"status":apierror.status,
                                  @"title":apierror.title,
                                  @"detail":apierror.detail,};
       NSError *error = [NSError errorWithDomain:@"com.xamoom"
                                            code:[apierror.code intValue]
                                        userInfo:userInfo];
       
       dispatch_async(dispatch_get_main_queue(), ^{
         completion(jsonApi, error);
       });
       return;
     }
     
     dispatch_async(dispatch_get_main_queue(), ^{
       completion(jsonApi, error);
     });
   }];
  [task resume];
  return task;
}

- (void)checkHeaders:(NSDictionary *)headers {
  NSString *ephemeralId = [headers objectForKey:EPHEMERAL_ID_HEADER];
  if (ephemeralId != nil && _delegate != nil) {
    [_delegate gotEphemeralId:ephemeralId];
  }
  
  NSString *authorizationId = [headers objectForKey:AUTHORIZATION_ID_HEADER];
  if (authorizationId != nil && _delegate != nil) {
    [_delegate gotAuthorizationId:authorizationId];
  }
}

- (JSONAPI *)jsonApiFromData:(NSData *)data {
  NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
  NSError *jsonError;
  NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
  JSONAPI *jsonApi = [JSONAPI jsonAPIWithDictionary:jsonDict];
  return jsonApi;
}

@end
