//
//  XMMOfflineApiHelper.m
//  XamoomSDK
//
//  Created by Raphael Seher on 11/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>
#import "XMMOfflineApiHelper.h"
#import "XMMOfflineStorageManager.h"
#import "XMMCDSpot.h"
#import "XMMOfflinePagedResult.h"
#import "XMMCDContent.h"

@interface XMMOfflineApiHelperTest : XCTestCase

@property XMMOfflineApiHelper *helper;

@end

@implementation XMMOfflineApiHelperTest

- (void)setUp {
  [super setUp];
  self.helper = [[XMMOfflineApiHelper alloc] init];
}

- (void)tearDown {
  [super tearDown];
  
}

- (void)testSpotsInsideRadius {
  XMMCDSpot *spot1 = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDSpot coreDataEntityName] inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  spot1.jsonID = @"1";
  spot1.locationDictionary = [@{@"lat":@46.6247222,
                               @"lon":@14.3052778} mutableCopy];
                
  XMMCDSpot *spot2 = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDSpot coreDataEntityName] inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  spot2.jsonID = @"2";
  spot2.locationDictionary = [@{@"lat":@45.6247222,
                               @"lon":@13.3052778} mutableCopy];
  NSArray *result = @[spot1, spot2];
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6247222
                                                    longitude:14.3052778];
  
  NSArray *spotsInsideRadius = [self.helper spotsInsideGeofence:result
                                                       location:location
                                                         radius:40];
  
  XCTAssertEqual(spotsInsideRadius.count, 1);
  XMMCDSpot *checkSpot = spotsInsideRadius[0];
  XCTAssertEqual(checkSpot.jsonID, spot1.jsonID);
}

- (void)testContentsWithTags {
  NSMutableArray *contents = [[NSMutableArray alloc] init];
  
  XMMContent *newContent = [[XMMContent alloc] init];
  newContent.ID = @"1";
  newContent.tags = @[@"tag1", @"tag2"];
  [contents addObject:[XMMCDContent insertNewObjectFrom:newContent]];
  
  XMMContent *newContent2 = [[XMMContent alloc] init];
  newContent2.ID = @"2";
  newContent2.tags = @[@"tag2"];
  [contents addObject:[XMMCDContent insertNewObjectFrom:newContent2]];
  
  NSArray *newContents = [self.helper entitiesWithTags:contents tags:@[@"tag1", @"tag2"]];
  
  XCTAssertEqual(newContents.count, 2);
}

- (void)testSortArrayByPropertyName {
  XMMCDSpot *spot1 = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDSpot coreDataEntityName] inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  spot1.jsonID = @"1";
  spot1.name = @"b";

  
  XMMCDSpot *spot2 = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDSpot coreDataEntityName] inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  spot2.jsonID = @"2";
  spot2.name= @"a";

  NSArray *result = @[spot1, spot2];
  
  NSArray *sorted = [self.helper sortArrayByPropertyName:result propertyName:@"name" ascending:YES];
  
  XCTAssertEqual(sorted[0], spot2);
  XCTAssertEqual(sorted[1], spot1);
}

- (void)testPagedResultWithPaging {
  NSArray *items = @[@1,@2,@3,@4,@5];
  
  XMMOfflinePagedResult *pagedResult = [self.helper pageResults:items pageSize:2 cursor:nil];
  
  XCTAssertEqual(pagedResult.items.count, 2);
  XCTAssertEqual(pagedResult.items[0], @1);
  XCTAssertEqual(pagedResult.items[1], @2);
  XCTAssertTrue(pagedResult.hasMore);
  XCTAssertTrue([pagedResult.cursor isEqualToString:@"1"]);
  
  pagedResult = [self.helper pageResults:items pageSize:2 cursor:@"1"];
  
  XCTAssertEqual(pagedResult.items.count, 2);
  XCTAssertEqual(pagedResult.items[0], @3);
  XCTAssertEqual(pagedResult.items[1], @4);
  XCTAssertTrue(pagedResult.hasMore);
  XCTAssertTrue([pagedResult.cursor isEqualToString:@"2"]);
  
  pagedResult = [self.helper pageResults:items pageSize:2 cursor:@"2"];
  
  XCTAssertEqual(pagedResult.items.count, 1);
  XCTAssertEqual(pagedResult.items[0], @5);
  XCTAssertFalse(pagedResult.hasMore);
  XCTAssertTrue([pagedResult.cursor isEqualToString:@"3"]);
}

- (void)testPagedResultWithoutPaging {
  NSArray *items = @[@1,@2];
  
  XMMOfflinePagedResult *pagedResult = [self.helper pageResults:items pageSize:2 cursor:nil];
  
  XCTAssertEqual(pagedResult.items.count, 2);
  XCTAssertEqual(pagedResult.items[0], @1);
  XCTAssertEqual(pagedResult.items[1], @2);
  XCTAssertFalse(pagedResult.hasMore);
  XCTAssertTrue([pagedResult.cursor isEqualToString:@"1"]);
}

- (void)testPagedResultsWithoutItems {
  XMMOfflinePagedResult *pagedResult = [self.helper pageResults:nil pageSize:2 cursor:nil];
  
  XCTAssertEqual(pagedResult.items.count, 0);
  XCTAssertFalse(pagedResult.hasMore);
  XCTAssertNil(pagedResult.cursor);
}

@end
