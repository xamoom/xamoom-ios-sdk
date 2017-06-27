//
//  XMMPushManager.m
//  XamoomSDK
//
//  Created by Raphael Seher on 27/06/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import "XMMPushManager.h"
#import <Pushwoosh/PushNotificationManager.h>

@interface XMMPushManager() <PushNotificationDelegate>

@end

@implementation XMMPushManager

NSString *CONTENT_ID_NAME = @"content_id";

- (instancetype)init {
  if (self == nil) {
    self = [super init];
  }
  
  [self initPush];
  
  return self;
}

- (void)initPush {
  PushNotificationManager *pushManager = [PushNotificationManager pushManager];
  pushManager.delegate = self;
  
  [UNUserNotificationCenter currentNotificationCenter].delegate = [PushNotificationManager pushManager].notificationCenterDelegate;
  
  [[PushNotificationManager pushManager] sendAppOpen];
  [[PushNotificationManager pushManager] registerForPushNotifications];
}

- (void)handlePushRegistration:(NSData *)devToken {
  [[PushNotificationManager pushManager] handlePushRegistration:devToken];
}

- (void)handlePushRegistrationFailure:(NSError *)error {
  [[PushNotificationManager pushManager] handlePushRegistrationFailure:error];
}

- (BOOL)handlePushReceived:(NSDictionary *)userInfo {
  return [[PushNotificationManager pushManager] handlePushReceived:userInfo];
}

- (void)onPushAccepted:(PushNotificationManager *)pushManager
      withNotification:(NSDictionary *)pushNotification onStart:(BOOL)onStart {
  NSString *customDataString = [pushManager getCustomPushData:pushNotification];
  NSDictionary *jsonData = nil;
  NSString *contentId = nil;
  
  if (customDataString) {
    jsonData = [NSJSONSerialization
                JSONObjectWithData:[customDataString dataUsingEncoding:NSUTF8StringEncoding]
                options:NSJSONReadingMutableContainers error:nil];
    
    contentId = [jsonData objectForKey:CONTENT_ID_NAME];
  }
  
  if ([self.delegate respondsToSelector:@selector(didClickPushNotification:)]) {
    [self.delegate didClickPushNotification:contentId];
  }
}

@end
