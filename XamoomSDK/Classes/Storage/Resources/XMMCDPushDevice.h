//
//  XMMCDPushDevice.h
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 28.06.18.
//

#import <Foundation/Foundation.h>
#import "XMMOfflineStorageManager.h"
#import "XMMCDResource.h"

@interface XMMCDPushDevice  : NSManagedObject <XMMCDResource>

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *os;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *lastAppOpen;
@property (nonatomic) NSString *updatedAt;
@property (nonatomic) NSString *createdAt;
@property (nonatomic) NSDictionary *location;
@property (nonatomic) NSString* language;
@end
