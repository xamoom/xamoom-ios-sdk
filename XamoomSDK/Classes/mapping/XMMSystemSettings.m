//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMSystemSettings.h"
#import "XMMCDSystemSettings.h"

@implementation XMMSystemSettings

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (NSString *)resourceName {
  return @"consumer/settings";
}

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"settings"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor addProperty:@"googlePlayAppId" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"app-id-google-play"]];
    [__descriptor addProperty:@"itunesAppId" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"app-id-itunes"]];
    [__descriptor addProperty:@"socialSharingEnabled" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"is-social-sharing-active"]];
    [__descriptor addProperty:@"cookieWarningEnabled" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"is-cookie-warning-enabled"]];
    [__descriptor addProperty:@"recommendationEnabled" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"is-recommendations-active"]];
    [__descriptor addProperty:@"eventPackageEnabled" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"is-event-package-active"]];
    [__descriptor addProperty:@"languagePickerEnabled" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"is-language-switcher-enabled"]];
    [__descriptor addProperty:@"languages" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"languages"]];

  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDSystemSettings *savedSettings = (XMMCDSystemSettings *)object;
    self.ID = savedSettings.jsonID;
    self.googlePlayAppId = savedSettings.googlePlayId;
    self.itunesAppId = savedSettings.itunesAppId;
    self.socialSharingEnabled = savedSettings.socialSharingEnabled.boolValue;
    self.cookieWarningEnabled = savedSettings.cookieWarningEnabled.boolValue;
    self.recommendationEnabled = savedSettings.recommendationEnabled.boolValue;
    self.eventPackageEnabled = savedSettings.eventPackageEnabled.boolValue;
    self.languagePickerEnabled = savedSettings.languagePickerEnabled.boolValue;
    self.languages = savedSettings.languages;
  }
  
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDSystemSettings insertNewObjectFrom:self];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDSystemSettings class] ID:self.ID];
}

@end
