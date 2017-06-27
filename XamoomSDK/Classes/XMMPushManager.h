//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import <Foundation/Foundation.h>

@protocol XMMPushNotificationDelegate <NSObject>

- (void)didClickPushNotification:(NSString *)contentId;

@end

/**
 * XMMPushManager enables you to receive Push Notifications from the xamoom
 * backend. 
 *
 * Create an instance and set the XMMPushNotificationDelegate.
 *
 * For setup instructions please visit our github page.
 * (https://github.com/xamoom/xamoom-ios-sdk)
 */
@interface XMMPushManager : NSObject

@property (weak) id<XMMPushNotificationDelegate> delegate;

/**
 * Initialize XMMPushManager and setup push notifications.
 *
 * @return PushManager instance
 */
- (instancetype)init;

/**
 * Handle push registration success.
 * Wraps [pushNotificationManager handlePushRegistration:].
 *
 * @param devToken Device token from application callback.
 */
- (void)handlePushRegistration:(NSData *)devToken;

/**
 * Handle push registration failure.
 * Wraps [pushNotificationManager handlePushRegistrationFailure:].
 *
 * @param error Registrations error.
 */
- (void)handlePushRegistrationFailure:(NSError *)error;

/**
 * Handle push received.
 * Wraps [pushNotificationManager handlePushReceived].
 *
 * @param userInfo Push notifications userData.
 */
- (BOOL)handlePushReceived:(NSDictionary *)userInfo;

@end
