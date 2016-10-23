//
//  XMMOfflineHelper.m
//  XamoomSDK
//
//  Created by Raphael Seher on 21/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMOfflineStorageTagModule.h"
#import "XMMCDSpot.h"
#import "XMMOfflineApiHelper.h"
#import "XMMCDContent.h"

int const kPageSize = 100;

@interface XMMOfflineStorageTagModule()

@property NSMutableArray *allSpots;

@end

@implementation XMMOfflineStorageTagModule

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
    // get all spots with
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"content.jsonID == %@", spot.content.jsonID];
    NSArray *spotsWithThatContent = [self.storeManager fetch:[XMMCDSpot coreDataEntityName] predicate:predicate];
    
    BOOL deleteableContent = YES;
    for (XMMCDSpot *queriedSpot in spotsWithThatContent) {
      if (![spotsToDelete containsObject:queriedSpot]) {
        deleteableContent = NO;
      }
    }
    
    if (deleteableContent) {
      [contentsToDelete addObject:spot.content];
    }
  }
  
  for (XMMCDSpot *spot in spotsToDelete) {
    [self.storeManager.managedObjectContext deleteObject:spot];
  }
  
  for (XMMCDContent *content in contentsToDelete) {
    [self.storeManager.managedObjectContext deleteObject:content];
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
