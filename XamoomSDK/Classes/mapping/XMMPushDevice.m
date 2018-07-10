//
//  XMMPushDevice.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 28.06.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import "XMMPushDevice.h"
#import "XMMCDPushDevice.h"

@implementation XMMPushDevice
- (instancetype)init {
  self = [super init];
  self.os = @"iOS";
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
  [dateFormatter setLocale:enUSPOSIXLocale];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
  
  NSDate *now = [NSDate date];
  self.lastAppOpen = [dateFormatter stringFromDate:now];
  self.updatedAt = @"";
  self.createdAt = @"";
  return self;
}

+ (NSString *)resourceName {
  return @"push-register";
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDPushDevice *savedPushDevice = (XMMCDPushDevice *)object;
    //self.ID = savedPushDevice.jsonID;
    self.uid = savedPushDevice.uid;
    self.os = savedPushDevice.os;
    self.appVersion = savedPushDevice.appVersion;
    self.appId = savedPushDevice.appId;
    self.location = savedPushDevice.location;
    self.lastAppOpen = savedPushDevice.lastAppOpen;
    self.updatedAt = savedPushDevice.updatedAt;
    self.createdAt = savedPushDevice.createdAt;
  }
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDPushDevice insertNewObjectFrom:self];
}

- (id<XMMCDResource>)saveOffline:(void (^)(NSString *url, NSData *, NSError *))downloadCompletion {
  return [XMMCDPushDevice insertNewObjectFrom:self
                                  fileManager:[[XMMOfflineFileManager alloc] init]
                                   completion:downloadCompletion];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDPushDevice class] ID:self.ID];
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"push-device"];
    
    [__descriptor setIdProperty:@"ID"];
    
    //[__descriptor addProperty:@"uid" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"id"]];
    [__descriptor addProperty:@"os" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"os"]];
    [__descriptor addProperty:@"appVersion" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"app-version"]];
    [__descriptor addProperty:@"appId" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"app-id"]];
    [__descriptor addProperty:@"location" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"location"]];
    [__descriptor addProperty:@"lastAppOpen" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"last-app-open"]];
    [__descriptor addProperty:@"updatedAt" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"updated-at"]];
    [__descriptor addProperty:@"createdAt" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"created-at"]];
  });
  
  return __descriptor;
}

@end

