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

@synthesize offlineTags;

- (instancetype)initWithApi:(XMMEnduserApi *)api {
  self = [super init];
  if (self) {
    self.api = api;
    offlineTags = [[NSMutableArray alloc] init];
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
      [spot saveOffline];
    }
    
    [self downloadAllContentsFromSpots:self.allSpots completion:^(NSArray *contents, NSError *error) {
      if (error) {
        completion(nil, error);
      }
      
      for (XMMContent *content in contents) {
        [content saveOffline];
      }
      
      [self.offlineTags addObjectsFromArray:tags];
      completion(self.allSpots, error);
    }];
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

- (void) downloadAllContentsFromSpots:(NSArray *)spots completion:(void (^)(NSArray *contents, NSError *error))completion {
  NSMutableArray *allContents = [[NSMutableArray alloc] init];
  int count = 0;
  
  for (XMMSpot *spot in spots) {
    if (spot.content != nil) {
      count++;
    }
  }
  
  for (XMMSpot *spot in spots) {
    if (spot.content != nil) {
      [self.api contentWithID:spot.content.ID completion:^(XMMContent *content, NSError *error) {
        if (error) {
          completion(nil, error);
          return;
        }
        
        [allContents addObject:content];
        
        if (allContents.count == count) {
          completion(allContents, nil);
        }
      }];
    }
  }
}

- (NSError *)deleteSavedDataWithTags:(NSArray *)tags {
  [offlineTags removeObjectsInArray:tags];

  NSArray *allSpots = [self.storeManager fetchAll:[XMMCDSpot coreDataEntityName]];
  XMMOfflineApiHelper* offlineApiHelper = [[XMMOfflineApiHelper alloc] init];
  NSMutableArray *spotsToDelete = [[offlineApiHelper entitiesWithTags:allSpots tags:tags] mutableCopy];
  NSArray *spotsToKeep = [offlineApiHelper entitiesWithTags:spotsToDelete tags:offlineTags];
  [spotsToDelete removeObjectsInArray:spotsToKeep];
  
  NSMutableArray *contentsToDelete = [[NSMutableArray alloc] init];
  for (XMMCDSpot *spot in spotsToDelete) {
    // get all spots with that content
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
    [self.storeManager deleteEntity:[XMMCDSpot class] ID:spot.jsonID];
  }
  
  for (XMMCDContent *content in contentsToDelete) {
    NSLog(@"test: %@", content.jsonID);
    [self.storeManager deleteEntity:[XMMCDContent class] ID:content.jsonID];
  }
  
  [self.storeManager deleteLocalFilesWithSafetyCheck];
  
  NSError *error;
  [self.storeManager.managedObjectContext save:&error];
  return error;
}

- (void)addOfflineTag:(NSString *)tag {
  [self.offlineTags addObject:tag];
}

- (XMMOfflineStorageManager *)storeManager {
  if (_storeManager == nil) {
    _storeManager = [XMMOfflineStorageManager sharedInstance];
  }
  return _storeManager;
}

@end
