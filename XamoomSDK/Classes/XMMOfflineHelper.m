//
//  XMMOfflineHelper.m
//  XamoomSDK
//
//  Created by Raphael Seher on 21/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMOfflineHelper.h"
#import "XMMCDSpot.h"
#import "XMMOfflineApiHelper.h"
#import "XMMCDContent.h"

int const kPageSize = 100;

@interface XMMOfflineHelper()

@property NSMutableArray *allSpots;

@end

@implementation XMMOfflineHelper

- (instancetype)initWithApi:(XMMEnduserApi *)api {
  self = [super init];
  if (self) {
    self.api = api;
  }
  return self;
}

- (void)downloadAndSaveWithTags:(NSArray *)tags completion:(void (^)(NSArray *, NSError *))completion {
  self.allSpots = [[NSMutableArray alloc] init];
  
  [self downloadAllSpots:tags cursor:nil completion:^(NSArray *spots, NSError *error) {
    if (error) {
      completion(nil, error);
    }
    
    for (XMMSpot *spot in self.allSpots) {
      [XMMCDSpot insertNewObjectFrom:spot];
    }
    
    completion(self.allSpots, error);
  }];
}

- (void)downloadAllSpots:(NSArray *)tags cursor:(NSString *)cursor
                     completion:(void(^)(NSArray *spots, NSError *error))completion {
  self.api.offline = NO;
  [self.api spotsWithTags:tags pageSize:kPageSize cursor:cursor options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker sort:XMMSpotSortOptionsNone completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    if (error) {
      completion(nil, error);
    }
    
    [self.allSpots addObjectsFromArray:spots];
    
    if (hasMore) {
      [self downloadAllSpots:tags cursor:cursor completion:completion];
    } else {
      completion(self.allSpots, nil);
    }
  }];
}

- (NSError *)deleteSavedDataWithTags:(NSArray *)tags ignoreTags:(NSArray *)ignoreTags {
  NSArray *allSpots = [self.storeManager fetchAll:[XMMCDSpot coreDataEntityName]];
  XMMOfflineApiHelper* offlineApiHelper = [[XMMOfflineApiHelper alloc] init];
  NSMutableArray *spotsToDelete = [[offlineApiHelper entitiesWithTags:allSpots tags:tags] mutableCopy];
  NSArray *spotsToKeep = [offlineApiHelper entitiesWithTags:spotsToDelete tags:ignoreTags];
  [spotsToDelete removeObjectsInArray:spotsToKeep];
  
  NSMutableArray *contentsToDelete = [[NSMutableArray alloc] init];
  for (XMMCDSpot *spot in spotsToDelete) {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"spot.content.jsonID == %@", spot.content.jsonID];
    NSArray *spotsWithThatContent = [self.storeManager fetch:[XMMCDSpot coreDataEntityName] predicate:predicate];
    
    
    
  }
  
  
  for (XMMCDSpot *spot in spotsToDelete) {
    [self.storeManager.managedObjectContext deleteObject:spot];
  }
  
  NSError *error;
  [self.storeManager.managedObjectContext save:&error];
  return error;
}

- (XMMOfflineStorageManager *)storeManager {
  if (_storeManager == nil) {
    _storeManager = [XMMOfflineStorageManager sharedInstance];
  }
  return _storeManager;
}

@end
