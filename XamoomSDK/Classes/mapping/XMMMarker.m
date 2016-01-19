//
//  XMMMarker.m
//  XamoomSDK
//
//  Created by Raphael Seher on 19/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMMarker.h"

@implementation XMMMarker

+ (NSString *)resourceName {
  return @"markers";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"markers"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor addProperty:@"qr"];
    [__descriptor addProperty:@"nfc"];
    [__descriptor addProperty:@"beaconMajor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"ibacon-region-uid"]];
    [__descriptor addProperty:@"beaconMajor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"ibacon-major"]];
    [__descriptor addProperty:@"beaconMinor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"ibacon-minor"]];
    [__descriptor addProperty:@"beaconMinor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"ibacon-minor"]];
  });
  
  return __descriptor;
}

@end
