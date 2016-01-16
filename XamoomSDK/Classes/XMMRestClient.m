//
//  XMMRestClient.m
//  XamoomSDK
//
//  Created by Raphael Seher on 15/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMRestClient.h"

@implementation XMMRestClient

- (instancetype)initWithBaseUrl:(NSString *)baseUrl {
  self = [super init];
  self.query = [[XMMQuery alloc] initWithBaseUrl:baseUrl];
  return self;
}

- (void)fetchResource:(Class)resourceClass {
  NSURL *requestUrl = [self.query urlWithResource:resourceClass];
}

@end
