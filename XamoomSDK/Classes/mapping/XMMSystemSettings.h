//
//  XMMSystemSettings.h
//  XamoomSDK
//
//  Created by Raphael Seher on 18/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONAPI/JSONAPIResourceBase.h>
#import <JSONAPI/JSONAPIResourceDescriptor.h>
#import <JSONAPI/JSONAPIPropertyDescriptor.h>
#import "XMMRestResource.h"

@interface XMMSystemSettings : JSONAPIResourceBase  <XMMRestResource>

@property (strong, nonatomic) NSString *googlePlayAppId;
@property (strong, nonatomic) NSString *itunesAppId;

@end
