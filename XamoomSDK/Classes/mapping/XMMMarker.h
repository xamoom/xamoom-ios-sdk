//
//  XMMMarker.h
//  XamoomSDK
//
//  Created by Raphael Seher on 19/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONAPI/JSONAPIResourceBase.h>
#import <JSONAPI/JSONAPIResourceDescriptor.h>
#import <JSONAPI/JSONAPIPropertyDescriptor.h>
#import "XMMRestResource.h"

@interface XMMMarker : JSONAPIResourceBase  <XMMRestResource>

@property (nonatomic) NSString *qr;
@property (nonatomic) NSString *nfc;
@property (nonatomic) NSString *beaconUUID;
@property (nonatomic) NSString *beaconMajor;
@property (nonatomic) NSString *beaconMinor;
@property (nonatomic) NSString *eddyStoneUrl;

@end
