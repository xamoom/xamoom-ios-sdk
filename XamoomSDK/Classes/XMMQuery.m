//
//  XMMQuery.m
//  XamoomSDK
//
//  Created by Raphael Seher on 15/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMQuery.h"

@implementation XMMQuery

- (instancetype)initWithBaseUrl:(NSURL *)url {
  self = [super init];
  self.baseUrl = url;
  return self;
}

@end
