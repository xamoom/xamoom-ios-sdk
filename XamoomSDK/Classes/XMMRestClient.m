//
//  XMMRestClient.m
//  XamoomSDK
//
//  Created by Raphael Seher on 15/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMRestClient.h"
@implementation XMMRestClient

- (instancetype)initWithBaseUrl:(NSURL *)baseUrl session:(NSURLSession *)session {
  self = [super init];
  self.query = [[XMMQuery alloc] initWithBaseUrl:baseUrl];
  self.session = session; 
  return self;
}

- (void)fetchResource:(Class)resourceClass completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSURL *requestUrl = [self.query urlWithResource:resourceClass];
  [self makeRestCall:requestUrl completion:completion];
}

- (void)fetchResource:(Class)resourceClass parameters:(NSDictionary *)parameters completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSURL *requestUrl = [self.query urlWithResource:resourceClass];
  requestUrl = [self.query addQueryParametersToUrl:requestUrl parameters:parameters];
  [self makeRestCall:requestUrl completion:completion];
}

- (void)fetchResource:(Class)resourceClass id:(NSString *)resourceId parameters:(NSDictionary *)parameters completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSURL *requestUrl = [self.query urlWithResource:resourceClass id:resourceId];
  requestUrl = [self.query addQueryParametersToUrl:requestUrl parameters:parameters];
  [self makeRestCall:requestUrl completion:completion];
}

- (void)makeRestCall:(NSURL *)url completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSLog(@"RestCall with url: %@", url.absoluteString);
  [[self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    JSONAPI *jsonApi;
    
    if (error) {
      NSLog(@"Error: %@", error);
      completion(jsonApi, error);
      return;
    }
    
    jsonApi = [self jsonApiFromData:data];
    completion(jsonApi, error);
  }] resume];
}

- (JSONAPI *)jsonApiFromData:(NSData *)data {
  NSError *jsonError;
  NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
  JSONAPI *jsonApi = [JSONAPI jsonAPIWithDictionary:jsonDict];
  return jsonApi;
}

@end
