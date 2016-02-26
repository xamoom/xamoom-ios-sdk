//
//  XMMSystemSettings.m
//  XamoomSDK
//
//  Created by Raphael Seher on 18/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMSystemSettings.h"

@implementation XMMSystemSettings

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (NSString *)resourceName {
  return @"settings";
}

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"settings"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor addProperty:@"googlePlayAppId" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"app-id-google-play"]];
    [__descriptor addProperty:@"itunesAppId" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"app-id-itunes"]];
  });
  
  return __descriptor;
}

@end
