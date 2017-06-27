//
//  XMMPushManager.h
//  XamoomSDK
//
//  Created by Raphael Seher on 27/06/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMMPushNotificationDelegate <NSObject>

- (void)didClickPushNotification:(NSString *)contentId;

@end

@interface XMMPushManager : NSObject

@property (weak) id<XMMPushNotificationDelegate> delegate;

- (instancetype)init;
- (void)handlePushRegistration:(NSData *)devToken;
- (BOOL)handlePushReceived:(NSDictionary *)userInfo;
- (void)handlePushRegistrationFailure:(NSError *)error;

@end
