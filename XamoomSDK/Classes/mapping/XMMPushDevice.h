//
//  XMMPushDevice.h
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 28.06.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONAPI/JSONAPIResourceBase.h>
#import <JSONAPI/JSONAPIResourceDescriptor.h>
#import <JSONAPI/JSONAPIPropertyDescriptor.h>
#import <CoreLocation/CoreLocation.h>
#import "XMMRestResource.h"

@interface XMMPushDevice : JSONAPIResourceBase  <XMMRestResource>
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *os;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *lastAppOpen;
@property (nonatomic) NSString *updatedAt;
@property (nonatomic) NSString *createdAt;
@property (nonatomic) NSDictionary *location;
@property (nonatomic) NSString *language;
@property (nonatomic) NSString *sdkVersion;
@property(nonatomic) BOOL sound;
@end
