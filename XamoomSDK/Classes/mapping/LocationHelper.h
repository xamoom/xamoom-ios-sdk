//
//  LocationHelper.h
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 18.03.19.
//  Copyright © 2019 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XMMEnduserApi.h"

extern NSString *const LOCATION_UPDATE;
extern NSString *const BEACON_ENTER;
extern NSString *const BEACON_EXIT;
extern NSString *const BEACON_RANGE;
extern NSString *const BEACON_CONTENTS;
extern NSString *const XAMOOM_BEACONS_KEY;
extern NSString *const XAMOOM_CONTENTS_KEY;

@interface LocationHelper : NSObject

  @property (nonatomic, strong) CLLocationManager *locationManager;
  @property (nonatomic, strong) CLBeaconRegion *beaconRegion;
  @property (nonatomic, strong) CLLocation *userLocation;
  @property (nonatomic, strong) NSArray *beacons;
  @property (nonatomic, strong) NSArray *contents;
  @property (nonatomic, assign) BOOL firstTimeStart;
  @property (nonatomic, assign) BOOL filterSameBeaconScans;
  @property (nonatomic, assign) BOOL beaconsLoading;
  @property (nonatomic, assign) BOOL pushSound;
  @property (nonatomic, strong) NSString *majorBeaconID;
  @property (nonatomic, strong) XMMEnduserApi *api;

  + (instancetype _Nonnull)sharedInstance;

  - (id)initWithBeaconRegion:(NSUUID *)uuid beaconMajor:(NSNumber *)major beaconIdentifier:(NSString *)identifier api:(XMMEnduserApi *)api;
  
  - (void)startLocationUpdateing;
  
  - (void)stopLocationUpdating;
  
  - (void)sendLocationNotificationWithLocation:(CLLocation*)location;
  
  - (void)sendBeaconNotificationWithRegion:(CLRegion*)region isEnter:(BOOL)isEnter;
  
  - (void)sendNotificationWithName:(NSString *)name userInfo:(NSDictionary *)userInfo;
  
  - (void)removeDuplicateBeacons:(NSArray *)beacons contents:(NSArray *)contents completion:(void (^)(NSArray *beacons, NSArray *contents))completion;
  
  - (BOOL)sameBeaconsForBeacons:(NSArray *)newBeacons;
@end

