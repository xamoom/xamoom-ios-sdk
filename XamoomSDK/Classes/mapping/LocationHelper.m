//
//  LocationHelper.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 18.03.19.
//  Copyright © 2019 xamoom GmbH. All rights reserved.
//

#import "LocationHelper.h"
#import "XMMEnduserApi.h"
#import "XMMSimpleStorage.h"

NSString *const LOCATION_UPDATE = @"LocationUpdateNotification";
NSString *const BEACON_ENTER = @"BeaconEnterNotification";
NSString *const BEACON_EXIT = @"BeaconExitNotification";
NSString *const BEACON_RANGE = @"BeaconRangeNotification";
NSString *const BEACON_CONTENTS = @"BeaconRangeContents";

@interface LocationHelper () <CLLocationManagerDelegate>

@end

static LocationHelper *sharedInstance;

@implementation LocationHelper : NSObject
    
  + (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
  }
  
  - (id)initWithBeaconRegion:(NSUUID *)uuid beaconMajor:(NSNumber *)major beaconIdentifier:(NSString *)identifier apiKey:(NSString *)apiKey {
    self = [super init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.requestAlwaysAuthorization;
    
    self.majorBeaconID = [major stringValue];
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:major identifier:identifier];
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self startLocationUpdateing];
    
    self.apiKey = apiKey;
    self.contentKey = @"contents";
    self.beaconKey = @"beacons";
    return self;
  }
  
  - (void)startLocationUpdateing {
    [self.locationManager startUpdatingLocation];
    [self.locationManager startMonitoringSignificantLocationChanges];
  }
  
  - (void)stopLocationUpdating {
    [self.locationManager stopUpdatingLocation];
  }
  
  - (void)sendLocationNotificationWithLocation:(CLLocation *)location {
    NSString *locationKey = @"location";
    NSDictionary *userInfo = @{locationKey: location};
    [self sendNotificationWithName:LOCATION_UPDATE userInfo:userInfo];
  }
  
  - (void)sendBeaconNotificationWithRegion:(CLRegion *)region isEnter:(BOOL)isEnter {
    NSString *name = BEACON_EXIT;
    if (isEnter) {
      name = BEACON_ENTER;
    }
    
    NSString *regionKey = @"region";
    NSDictionary *userInfo = @{regionKey: region};
    [self sendNotificationWithName:name userInfo:userInfo];
  }
  
  - (void)sendNotificationWithName:(NSString *)name userInfo:(NSDictionary *)userInfo {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:name object:userInfo];
  }
  
  - (BOOL)sameBeaconsForBeacons:(NSArray *)newBeacons {
    if (self.beacons.count != newBeacons.count) {
      return false;
    }
    
    BOOL allSame = false;
    for (CLBeacon *newBeacon in newBeacons) {
      for (CLBeacon *beacon in self.beacons) {
        if (newBeacon.minor == beacon.minor) {
          allSame = true;
        }
      }
      
      if (!allSame) {
        return false;
      }
    }
    
    return true;
  }
  
  - (void)removeDuplicateBeacons:(NSArray *)beacons contents:(NSArray *)contents completion:(void (^)(NSArray *, NSArray *))completion {
    NSMutableArray *cleanBeacons = @[];
    NSMutableArray *cleanCotnents = @[];

    for (int i = 0; i < [beacons count]; i++) {
      CLBeacon *beacon = beacons[i];
      BOOL shouldAdd = true;
      for (CLBeacon *cleanBeacon in cleanBeacons) {
        if (beacon.minor == cleanBeacon.minor) {
          shouldAdd = false;
        }
      }
      
      if (shouldAdd) {
        [cleanBeacons addObject:beacon];
        [cleanCotnents addObject:contents[i]];
      }
    }
    
    completion(cleanBeacons, cleanCotnents);
  }
  
  - (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.firstObject;
    if (location != nil) {
      self.userLocation = location;
      NSDictionary *locationDictionary = @{@"lat": [[NSNumber alloc] initWithDouble:location.coordinate.latitude], @"lon": [[NSNumber alloc] initWithDouble:location.coordinate.longitude]};
      XMMSimpleStorage *storage = [XMMSimpleStorage new];
      [storage saveLocation:locationDictionary];
      [[XMMEnduserApi sharedInstanceWithKey:self.apiKey] pushDevice];
    }
  }
    
  - (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    [self sendBeaconNotificationWithRegion:region isEnter:YES];
    [self.locationManager startRangingBeaconsInRegion:region];
  }
  
  - (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    self.beacons = @[];
    [self sendBeaconNotificationWithRegion:region isEnter:NO];
    [self.locationManager startRangingBeaconsInRegion:region];
  }
  
  - (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    
    if (self.firstTimeStart) {
      self.firstTimeStart = NO;
      if (self.beacons.count == 0) {
        if (self.beaconRegion != nil) {
          [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
        }
      }
    }
    
    [[XMMEnduserApi sharedInstanceWithKey:self.apiKey] pushDevice];

    if (self.beacons.count == 0) {
      self.beacons = @[];
      [self sendNotificationWithName:BEACON_CONTENTS userInfo:@{self.contentKey: @[]}];
      return;
    }
    
    if (self.beaconsLoading) {
      return;
    }
    
    [self beaconLogic:beacons completion:^(NSArray *loadedBeacons, NSArray *loadedContents) {
      if (![self sameBeaconsForBeacons:loadedBeacons]) {
        [self removeDuplicateBeacons:loadedBeacons contents:loadedContents completion:^(NSArray *lBeacons, NSArray *lContents) {
          
          if (lContents != nil && lBeacons != nil) {
            NSArray *cleanBeacons = lBeacons;
            NSArray *cleanContents = lContents;
            
            cleanBeacons = lBeacons;
            cleanContents = lContents;
            
            if (self.filterSameBeaconScans) {
              if ([self sameBeaconsForBeacons:cleanBeacons]) {
                self.beaconsLoading = false;
                return;
              }
            }
            
            self.beacons = cleanBeacons;
            self.contents = cleanContents;
            [self sendNotificationWithName:BEACON_RANGE userInfo:@{self.beaconKey: cleanBeacons}];
            [self sendNotificationWithName:BEACON_CONTENTS userInfo:@{self.contentKey: cleanContents}];
            self.beaconsLoading = false;
          }
          self.beaconsLoading = false;
        }];
      }
      
      self.beaconsLoading = false;

    }];
      
    self.beaconsLoading = false;
  }
  
  - (void) beaconLogic:(NSArray *)beacons completion:(void (^)(NSArray *beacons, NSArray *contents))completion {
    self.beaconsLoading = YES;
    NSMutableArray *loadedBeacons =@[];
    NSMutableArray *loadedContents =@[];
    
    for (int index = 0; index < beacons.count; index++) {
      CLBeacon *beacon = beacons[index];
      [[XMMEnduserApi sharedInstanceWithKey:self.apiKey] contentWithBeaconMajor:self.majorBeaconID minor:beacon.minor options:nil conditions:XMMContentOptionsNone reason:XMMContentReasonBeaconShowContent completion:^(XMMContent *content, NSError *error) {
        if (content != nil && error == nil) {
          [loadedBeacons addObject:beacon];
          [loadedContents addObject:content];
        }
        
        if (index == beacons.count) {
          completion(loadedBeacons, loadedContents);
        }
      }];
    }
  }
@end
