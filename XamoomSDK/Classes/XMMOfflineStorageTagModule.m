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

static int kPageSize = 100;

@interface XMMOfflineStorageTagModule()

@property NSMutableArray *allSpots;
@property NSString *suiteName;

@end

@implementation XMMOfflineStorageTagModule

- (instancetype)initWithApi:(XMMEnduserApi *)api {
  self = [super init];
  if (self) {
    self.api = api;
    self.suiteName = [NSString stringWithFormat:@"xamoomsdk.%@", 
                      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
    _offlineTags = [self loadOfflineTags];
  }
  return self;
}

- (void)downloadAndSaveWithTags:(NSArray *)tags
             downloadCompletion:(void (^)(NSString *url, NSData *data, NSError *error))downloadCompletion
                     completion:(void (^)(NSArray *, NSError *))completion {
  self.allSpots = [[NSMutableArray alloc] init];
  [self.offlineTags addObjectsFromArray:tags];
  [self saveOfflineTags];

  [self downloadAllSpots:tags cursor:nil completion:^(NSArray *spots, NSError *error) {
    if (error) {
      completion(nil, error);
    }
    
    for (XMMSpot *spot in self.allSpots) {
      [spot saveOffline:downloadCompletion];
    }
    
    [self downloadAllContentsFromSpots:self.allSpots completion:^(NSArray *contents, NSError *error) {
      if (error) {
        completion(nil, error);
      }
      
      for (XMMContent *content in contents) {
        [content saveOffline:downloadCompletion];
      }
      
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
  [self.offlineTags removeObjectsInArray:tags];
  [self saveOfflineTags];

  NSArray *allSpots = [self.storeManager fetchAll:[XMMCDSpot coreDataEntityName]];
  XMMOfflineApiHelper* offlineApiHelper = [[XMMOfflineApiHelper alloc] init];
  NSMutableArray *spotsToDelete = [[offlineApiHelper entitiesWithTags:allSpots tags:tags] mutableCopy];
  NSArray *spotsToKeep = [offlineApiHelper entitiesWithTags:spotsToDelete tags:self.offlineTags];
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
    [self.storeManager deleteEntity:[XMMCDContent class] ID:content.jsonID];
  }
  
  [self.storeManager deleteLocalFilesWithSafetyCheck];
  
  NSError *error;
  [self.storeManager.managedObjectContext save:&error];
  return error;
}

- (NSMutableArray *)loadOfflineTags {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *tags = [userDefaults objectForKey:@"offlineTags"];
  if (tags == nil) {
    tags = [[NSMutableArray alloc] init];
  }
  
  return tags;
}

- (void)saveOfflineTags {
  NSUserDefaults *userDefaults = [[NSUserDefaults alloc]
                                  initWithSuiteName:self.suiteName];
  [userDefaults setObject:self.offlineTags forKey:@"offlineTags"];
  [userDefaults synchronize];
}

- (XMMOfflineStorageManager *)storeManager {
  if (_storeManager == nil) {
    _storeManager = [XMMOfflineStorageManager sharedInstance];
  }
  return _storeManager;
}

@end
