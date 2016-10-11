//
//  XMMOfflineApiTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 10/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "XMMOfflineApi.h"
#import "XMMCDContent.h"
#import "XMMCDSpot.h"

@interface XMMOfflineApiTest : XCTestCase

@property XMMOfflineApi *offlineApi;

@end

@implementation XMMOfflineApiTest

- (void)setUp {
  [super setUp];
  [[XMMOfflineStorageManager sharedInstance] deleteAllEntities];
  self.offlineApi = [[XMMOfflineApi alloc] init];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testInit {
  XMMOfflineApi *api = [[XMMOfflineApi alloc] init];
  XCTAssertNotNil(api);
}

- (void)testContentWithID {
  XMMContent *newContent = [[XMMContent alloc] init];
  newContent.ID = @"Some id";
  
  [XMMCDContent insertNewObjectFrom:newContent];
  
  [self.offlineApi contentWithID:newContent.ID completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertEqual(newContent.ID, content.ID);
  }];
}

- (void)testContentWithIDNothingFoundError {
  [self.offlineApi contentWithID:@"" completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 100);
  }];
}

- (void)testContentWithIDTooManyResultsError {
  XMMCDContent *content = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDContent coreDataEntityName] inManagedObjectContext: [XMMOfflineStorageManager sharedInstance].managedObjectContext];
  
  content.jsonID = @"1";
  [[XMMOfflineStorageManager sharedInstance] save];
  
  content = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDContent coreDataEntityName] inManagedObjectContext: [XMMOfflineStorageManager sharedInstance].managedObjectContext];
  content.jsonID = @"1";
  [[XMMOfflineStorageManager sharedInstance] save];
  
  [self.offlineApi contentWithID:@"1" completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 101);
  }];
}

- (void)testContentWithLocationIdentifier {
  XMMContent *newContent = [[XMMContent alloc] init];
  newContent.ID = @"1";
  
  XMMMarker *newMarker = [[XMMMarker alloc] init];
  newMarker.ID = @"2";
  newMarker.qr = @"0ana0";
  
  XMMSpot *newSpot = [[XMMSpot alloc] init];
  newSpot.ID = @"3";
  newSpot.content = newContent;
  newSpot.markers = @[newMarker];
  
  [XMMCDSpot insertNewObjectFrom:newSpot];
  
  [self.offlineApi contentWithLocationIdentifier:@"0ana0" completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertEqual(newContent.ID, content.ID);
  }];
}

- (void)testContentWithLocationIdentifierNothingFound {
  [self.offlineApi contentWithLocationIdentifier:@"" completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 100);
  }];
}

- (void)testContentWithLocationIdentifierTooManyResultsError {
  XMMMarker *newMarker = [[XMMMarker alloc] init];
  newMarker.ID = @"2";
  newMarker.qr = @"0ana0";
  
  XMMSpot *newSpot = [[XMMSpot alloc] init];
  newSpot.ID = @"4";
  newSpot.markers = @[newMarker];
  [XMMCDSpot insertNewObjectFrom:newSpot];
  
  XMMMarker *newMarker2 = [[XMMMarker alloc] init];
  newMarker2.ID = @"3";
  newMarker2.qr = @"0ana0";
  
  XMMSpot *newSpot2 = [[XMMSpot alloc] init];
  newSpot2.ID = @"3";
  newSpot2.markers = @[newMarker2];
  [XMMCDSpot insertNewObjectFrom:newSpot2];
  
  [self.offlineApi contentWithLocationIdentifier:@"0ana0" completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 101);
  }];
}

- (void)testContentsWithLocation {
  
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"5";
  
  XMMContent *content1 = [[XMMContent alloc] init];
  content1.ID = @"6";
  
  XMMContent *content2 = [[XMMContent alloc] init];
  content2.ID = @"7";
  
  XMMSpot *newSpot = [[XMMSpot alloc] init];
  newSpot.ID = @"1";
  newSpot.latitude = 46.6247222;
  newSpot.longitude = 14.3052778;
  newSpot.content = content;
  [XMMCDSpot insertNewObjectFrom:newSpot];
  
  XMMSpot *newSpot1 = [[XMMSpot alloc] init];
  newSpot1.ID = @"2";
  newSpot1.latitude = 46.6247232;
  newSpot1.longitude = 14.3052788;
  newSpot1.content = content1;
  [XMMCDSpot insertNewObjectFrom:newSpot1];
  
  XMMSpot *newSpot2 = [[XMMSpot alloc] init];
  newSpot2.ID = @"3";
  newSpot2.latitude = 46.6247212;
  newSpot2.longitude = 14.3052768;
  newSpot2.content = content2;
  [XMMCDSpot insertNewObjectFrom:newSpot2];
  
  XMMSpot *newSpot3 = [[XMMSpot alloc] init];
  newSpot3.ID = @"4";
  newSpot3.latitude = 45.6247221;
  newSpot3.longitude = 13.3052777;
  [XMMCDSpot insertNewObjectFrom:newSpot3];
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6247222 longitude:14.3052778];
  
  [self.offlineApi contentsWithLocation:location pageSize:2 cursor:nil sort:XMMContentSortOptionsNone completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertEqual(contents.count, 2);
    XMMContent *savedContent = contents[0];
    XCTAssertEqual(savedContent.ID, @"5");
    XCTAssertTrue(hasMore);
    XCTAssertTrue([cursor isEqualToString:@"1"]);
    XCTAssertNil(error);
    
    [self.offlineApi contentsWithLocation:location pageSize:2 cursor:cursor sort:XMMContentSortOptionsNone completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
      XCTAssertEqual(contents.count, 1);
      XCTAssertFalse(hasMore);
      XCTAssertTrue([cursor isEqualToString:@"2"]);
      XCTAssertNil(error);
    }];
  }];
}

- (void)testContentsWithLocationWithoutElements {
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6247222 longitude:14.3052778];

  [self.offlineApi contentsWithLocation:location pageSize:2 cursor:nil sort:XMMContentSortOptionsNone completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertEqual(contents.count, 0);
    XCTAssertFalse(hasMore);
    XCTAssertNotNil(cursor);
    XCTAssertNil(error);
  }];
}

- (void)testContentsWithLocationWithoutLocation {
  [self.offlineApi contentsWithLocation:nil pageSize:2 cursor:nil sort:XMMContentSortOptionsNone completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertEqual(error.code, 102);
  }];
}

@end
