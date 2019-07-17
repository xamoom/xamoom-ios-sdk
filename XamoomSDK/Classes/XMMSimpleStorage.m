//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMSimpleStorage.h"
#import <CoreLocation/CoreLocation.h>

@implementation XMMSimpleStorage

- (instancetype)init {
  self = [super init];
  if (self) {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
  }
  return self;
}

- (void)saveTags:(NSArray *)tags {
  [self.userDefaults setObject:tags
                        forKey:@"com.xamoom.ios.offlineTags"];
  [self.userDefaults synchronize];
}

- (NSMutableArray *)readTags {
  NSMutableArray *tags = [[self.userDefaults
                           arrayForKey:@"com.xamoom.ios.offlineTags"] mutableCopy];
  if (tags == nil) {
    tags = [[NSMutableArray alloc] init];
  }
  
  return tags;
}

- (void)saveLocation:(NSDictionary *)location {
  [self.userDefaults setObject:location forKey:@"com.xamoom.ios.location"];
  [self.userDefaults synchronize];
}

- (CLLocation *)getLocation {
  NSDictionary *location = [self.userDefaults dictionaryForKey:@"com.xamoom.ios.location"];
  
  if (location == nil) {
    return nil;
  }
  
  double lat = [location[@"lat"] doubleValue];
  double lon = [location[@"lon"] doubleValue];
  CLLocation *l = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
  return l;
}

- (void)saveUserToken:(NSString *)token {
  [self.userDefaults setObject:token forKey:@"com.xamoom.ios.userToken"];
  [self.userDefaults synchronize];
}

- (NSString *)getUserToken {
  NSString *token = [self.userDefaults stringForKey:@"com.xamoom.ios.userToken"];
  
  if (token == nil) {
    return nil;
  }
  
  return token;
}


@end
