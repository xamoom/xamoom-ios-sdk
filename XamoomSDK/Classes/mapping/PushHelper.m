//
//  PushHelper.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 05.03.19.
//  Copyright © 2019 xamoom GmbH. All rights reserved.
//

#import "PushHelper.h"
#import "Firebase.h"
#import "XMMSimpleStorage.h"
#import "XMMEnduserApi.h"

@implementation PushHelper

NSString *const XAMOOM_NOTIFICATION_RECEIVE = @"xamoom-push-notification";

- (instancetype)initWithApi:(XMMEnduserApi *)api {
  self = [super init];
  if (self) {
    self.messagingDelegate = self;
    self.notificationDelegate = self;
    self.api = api;
  }
  return self;
}

//- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
//  NSLog(@"Remote Message Received");
//}
  - (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    
    XMMSimpleStorage *storage = [XMMSimpleStorage new];
    [storage saveUserToken:fcmToken];
    [self.api pushDevice:YES];
  }

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)) {
  NSDictionary *userInfo = notification.request.content.userInfo;
  NSString *wakeup = [userInfo valueForKey:@"wake-up"];
  
  if (wakeup != nil) {
    [self.api pushDevice:NO];
  } else {
    [self.api pushDevice:YES];
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
  }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
  NSDictionary *userInfo = response.notification.request.content.userInfo;
  NSString * contentId = [userInfo valueForKey:@"contentId"];
  
  if (contentId != nil || ![contentId isEqualToString:@""]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:XAMOOM_NOTIFICATION_RECEIVE object:nil userInfo:userInfo];
  }
  
  completionHandler();
}
@end
