//
//  XMMSystem.m
//  XamoomSDK
//
//  Created by Raphael Seher on 16/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMSystem.h"

@implementation XMMSystem

+ (NSString *)resourceName {
  return @"systems";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"systems"];
    
    [__descriptor setIdProperty:@"ID"];
    
    
    [__descriptor addProperty:@"name" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"display-name"]];
    [__descriptor addProperty:@"url"];
    [__descriptor addProperty:@"demo" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"is-demo"]];
    [__descriptor hasOne:[XMMSystemSettings class] withName:@"settings"];
    [__descriptor hasOne:[XMMStyle class] withName:@"style"];
  });
  
  return __descriptor;
}

@end
