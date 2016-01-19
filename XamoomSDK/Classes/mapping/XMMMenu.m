//
//  XMMMenu.m
//  XamoomSDK
//
//  Created by Raphael Seher on 19/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMMenu.h"

@implementation XMMMenu

+ (NSString *)resourceName {
  return @"menus";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"menus"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor hasMany:[XMMMenuItem class] withName:@"items"];

  });
  
  return __descriptor;
}

@end
