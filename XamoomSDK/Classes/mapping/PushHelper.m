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

- (instancetype)initWithApiKey:(NSString *)apiKey {
  self = [super init];
  if (self) {
    _messagingDelegate = self;
    _notificationDelegate = self;
    _apikey = apiKey;
  }
  return self;
}

- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
  NSLog(@"Remote Message Received");
}
  - (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    
    XMMSimpleStorage *storage = [XMMSimpleStorage new];
    [storage saveUserToken:fcmToken];
    [[XMMEnduserApi sharedInstanceWithKey:_apikey] pushDevice];
  }

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)) {
  NSDictionary *userInfo = notification.request.content.userInfo;
  NSString *wakeup = [userInfo valueForKey:@"wake-up"];
  
  if (wakeup != nil) {
    [[XMMEnduserApi sharedInstanceWithKey:_apikey] pushDevice];
  } else {
    completionHandler(UNNotificationPresentationOptionAlert);
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
