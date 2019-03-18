//
//  PushHelper.h
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 05.03.19.
//  Copyright © 2019 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import "Firebase.h"

extern NSString *const XAMOOM_NOTIFICATION_RECEIVE;

@interface PushHelper : NSObject<UNUserNotificationCenterDelegate, FIRMessagingDelegate>

@property (nonatomic, retain) id<FIRMessagingDelegate> messagingDelegate;
@property (nonatomic, retain) id <UNUserNotificationCenterDelegate> notificationDelegate;
@property (nonatomic, strong, readonly) NSString *apikey;

- (instancetype)initWithApiKey:(NSString *)apiKey;

@end
