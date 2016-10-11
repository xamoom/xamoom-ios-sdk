//
//  XMMOfflineApi.m
//  XamoomSDK
//
//  Created by Raphael Seher on 10/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMOfflineApi.h"
#import "XMMOfflineApiHelper.h"
#import "XMMOfflinePagedResult.h"
#import "XMMCDContent.h"
#import "XMMCDSpot.h"
#import "XMMCDMarker.h"
#import "XMMContent.h"

@interface XMMOfflineApi()

@property (nonatomic, strong) XMMOfflineApiHelper *apiHelper;

@end

@implementation XMMOfflineApi

- (instancetype)init {
  self = [super init];
  if (self) {
    self.apiHelper = [[XMMOfflineApiHelper alloc] init];
  }
  return self;
}

- (void)contentWithID:(NSString *)contentID completion:(void (^)(XMMContent *, NSError *))completion {
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetch:[XMMCDContent coreDataEntityName]
                                            jsonID:contentID];
  
  if (results.count == 1) {
    completion([[XMMContent alloc] initWithCoreDataObject:results[0]], nil);
    return;
  } else if (results.count > 1) {
    // smt wrong
    completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                               code:101
                                           userInfo:@{@"description":@"More than one result found."}]);
    return;
  }
  
  // nothing found
  completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                             code:100
                                         userInfo:@{@"description":@"No entry found."}]);
}

- (void)contentWithLocationIdentifier:(NSString *)locationIdentifier completion:(void (^)(XMMContent *, NSError *))completion {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY markers.qr == %@", locationIdentifier];
  NSCompoundPredicate *predicateCompound = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate]];
  
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetch:[XMMCDSpot coreDataEntityName]
                                         predicate:predicateCompound];
  
  if (results.count == 1) {
    XMMCDSpot *savedSpot = results[0];
    completion([[XMMContent alloc] initWithCoreDataObject:savedSpot.content], nil);
    return;
  } else if (results.count > 1) {
    completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                               code:101
                                           userInfo:@{@"description":@"More than one result found."}]);
    return;
  }
  
  completion(nil, [[NSError alloc] initWithDomain:@"XMMOfflineError"
                                             code:100
                                         userInfo:@{@"description":@"No entry found."}]);
}

- (void)contentsWithLocation:(CLLocation *)location pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *, bool, NSString *, NSError *))completion {
  
  if (location == nil) {
    completion(nil, nil, nil, [NSError errorWithDomain:@"XMMOfflineError"
                                                  code:102
                                              userInfo:@{@"description":@"Location cannot be null"}]);
    return;
  }
  
  NSArray *results =
  [[XMMOfflineStorageManager sharedInstance] fetchAll:[XMMCDSpot coreDataEntityName]];
  
  results = [self.apiHelper spotsInsideGeofence:results
                                       location:location
                                         radius:40];
  
  NSMutableArray *contents = [[NSMutableArray alloc] init];
  for (XMMCDSpot *savedSpot in results) {
    if (savedSpot.content != nil) {
      [contents addObject:[[XMMContent alloc] initWithCoreDataObject:savedSpot.content]];
    }
  }
  results = contents;
  
  if (sortOptions & XMMContentSortOptionsName) {
    results = [self.apiHelper sortArrayByPropertyName:results
                                         propertyName:@"name"
                                            ascending:YES];
  } else if (sortOptions & XMMContentSortOptionsNameDesc) {
    results = [self.apiHelper sortArrayByPropertyName:results
                                         propertyName:@"name"
                                            ascending:NO];
  }
  
  XMMOfflinePagedResult *pagedResult = [self.apiHelper pageResults:results
                                                          pageSize:pageSize
                                                            cursor:cursor];
  
  completion(pagedResult.items, pagedResult.hasMore, pagedResult.cursor, nil);
}

@end
