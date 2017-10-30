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
#import "NSDateFormatter+ISODate.h"

@interface XMMOfflineApiTest : XCTestCase

@property XMMOfflineApi *offlineApi;
@property float timeout;

@end

@implementation XMMOfflineApiTest

- (void)setUp {
  [super setUp];
  self.timeout = 1.0;
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
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentWithID:newContent.ID completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertEqual(newContent.ID, content.ID);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentWithIDNothingFoundError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentWithID:@"" completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 100);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentWithIDTooManyResultsError {
  XMMCDContent *content = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDContent coreDataEntityName] inManagedObjectContext: [XMMOfflineStorageManager sharedInstance].managedObjectContext];
  
  content.jsonID = @"1";
  [[XMMOfflineStorageManager sharedInstance] save];
  
  content = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDContent coreDataEntityName] inManagedObjectContext: [XMMOfflineStorageManager sharedInstance].managedObjectContext];
  content.jsonID = @"1";
  [[XMMOfflineStorageManager sharedInstance] save];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentWithID:@"1" completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 101);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
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
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentWithLocationIdentifier:@"0ana0" completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertEqual(newContent.ID, content.ID);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentWithLocationIdentifierNfc {
  XMMContent *newContent = [[XMMContent alloc] init];
  newContent.ID = @"1";
  
  XMMMarker *newMarker = [[XMMMarker alloc] init];
  newMarker.ID = @"2";
  newMarker.nfc = @"0ana0";
  
  XMMSpot *newSpot = [[XMMSpot alloc] init];
  newSpot.ID = @"3";
  newSpot.content = newContent;
  newSpot.markers = @[newMarker];
  [XMMCDSpot insertNewObjectFrom:newSpot];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentWithLocationIdentifier:@"0ana0" completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertEqual(newContent.ID, content.ID);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentWithLocationIdentifierBeacon {
  XMMContent *newContent = [[XMMContent alloc] init];
  newContent.ID = @"1";
  
  XMMMarker *newMarker = [[XMMMarker alloc] init];
  newMarker.ID = @"2";
  newMarker.beaconMinor = @"0ana0";
  newMarker.beaconMajor = @"52196";
  
  XMMSpot *newSpot = [[XMMSpot alloc] init];
  newSpot.ID = @"3";
  newSpot.content = newContent;
  newSpot.markers = @[newMarker];
  [XMMCDSpot insertNewObjectFrom:newSpot];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentWithLocationIdentifier:@"52196|0ana0" completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertEqual(newContent.ID, content.ID);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentWithLocationIdentifierNothingFound {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentWithLocationIdentifier:@"" completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 100);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
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
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentWithLocationIdentifier:@"0ana0" completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 101);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentsWithLocation {
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"5";
  content.title = @"d";
  
  XMMContent *content1 = [[XMMContent alloc] init];
  content1.ID = @"6";
  content1.title = @"s";
  
  XMMContent *content2 = [[XMMContent alloc] init];
  content2.ID = @"7";
  content2.title = @"a";
  
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
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentsWithLocation:location pageSize:2 cursor:nil sort:XMMContentSortOptionsTitleDesc completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertEqual(contents.count, 2);
    XMMContent *savedContent = contents[0];
    XCTAssertEqual(savedContent.ID, @"6");
    XCTAssertTrue([savedContent.title isEqualToString:@"s"]);
    XCTAssertTrue(hasMore);
    XCTAssertTrue([cursor isEqualToString:@"1"]);
    XCTAssertNil(error);
    
    [self.offlineApi contentsWithLocation:location pageSize:2 cursor:cursor sort:XMMContentSortOptionsNone completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
      XCTAssertEqual(contents.count, 1);
      XCTAssertFalse(hasMore);
      XCTAssertTrue([cursor isEqualToString:@"2"]);
      XCTAssertNil(error);
      [expectation fulfill];
    }];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentsWithLocationWithoutElements {
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6247222 longitude:14.3052778];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentsWithLocation:location pageSize:2 cursor:nil sort:XMMContentSortOptionsNone completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertEqual(contents.count, 0);
    XCTAssertFalse(hasMore);
    XCTAssertNotNil(cursor);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentsWithLocationWithoutLocation {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentsWithLocation:nil pageSize:2 cursor:nil sort:XMMContentSortOptionsNone completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertEqual(error.code, 102);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


- (void)testContentsWithTags {
  XMMContent *newContent = [[XMMContent alloc] init];
  newContent.ID = @"1";
  newContent.title = @"b";
  newContent.tags = @[@"tag1", @"tag2"];
  [XMMCDContent insertNewObjectFrom:newContent];
  
  XMMContent *newContent2 = [[XMMContent alloc] init];
  newContent2.ID = @"2";
  newContent2.title = @"a";
  newContent2.tags = @[@"tag2"];
  [XMMCDContent insertNewObjectFrom:newContent2];
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentsWithTags:@[@"tag1", @"tag2"] pageSize:10 cursor:nil sort:XMMContentSortOptionsTitle filter:nil completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNotNil(contents);
    XCTAssertEqual(contents.count, 2);
    XMMContent *content = contents[0];
    XCTAssertEqual(content.title, @"a");
    XCTAssertFalse(hasMore);
    XCTAssertTrue([cursor isEqualToString:@"1"]);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentsWithTagsNil {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentsWithTags:nil pageSize:10 cursor:nil sort:XMMContentSortOptionsNone filter:nil  completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertEqual(error.code, 102);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentsWithName {
  XMMContent *newContent = [[XMMContent alloc] init];
  newContent.ID = @"1";
  newContent.title = @"Ab";
  [XMMCDContent insertNewObjectFrom:newContent];
  
  XMMContent *newContent2 = [[XMMContent alloc] init];
  newContent2.ID = @"2";
  newContent2.title = @"a";
  [XMMCDContent insertNewObjectFrom:newContent2];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentsWithName:@"A" pageSize:10 cursor:nil sort:XMMContentSortOptionsTitleDesc filter:nil  completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNotNil(contents);
    XCTAssertEqual(contents.count, 2);
    XMMContent *content = contents[0];
    XCTAssertEqual(content.title, @"a");
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentsWithNameNil {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentsWithName:nil pageSize:10 cursor:nil sort:XMMContentSortOptionsTitleDesc filter:nil  completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNil(contents);
    XCTAssertEqual(error.code, 102);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentsFromDateToDate {
  XMMContent *newContent = [[XMMContent alloc] init];
  newContent.ID = @"1";
  newContent.title = @"Ab";
  newContent.fromDate = [[NSDateFormatter ISO8601Formatter] dateFromString:@"2017-10-20T07:02:01Z"];
  newContent.toDate = [[NSDateFormatter ISO8601Formatter] dateFromString:@"2017-10-20T08:02:01Z"];
  [XMMCDContent insertNewObjectFrom:newContent];
  
  NSDate *fromDate = [[NSDateFormatter ISO8601Formatter] dateFromString:@"2017-10-20T07:00:01Z"];
  NSDate *toDate = [[NSDateFormatter ISO8601Formatter] dateFromString:@"2017-10-20T08:10:01Z"];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentsFrom:fromDate to:toDate pageSize:10 cursor:nil sort:0 filter:nil completion:^(NSArray * _Nullable contents, bool hasMore, NSString * _Nullable cursor, NSError * _Nullable error) {
    XCTAssertNotNil(contents);
    XCTAssertEqual(contents.count, 1);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentsFromDate {
  XMMContent *newContent = [[XMMContent alloc] init];
  newContent.ID = @"1";
  newContent.title = @"Ab";
  newContent.fromDate = [[NSDateFormatter ISO8601Formatter] dateFromString:@"2017-10-20T07:02:01Z"];
  newContent.toDate = [[NSDateFormatter ISO8601Formatter] dateFromString:@"2017-10-20T08:02:01Z"];
  [XMMCDContent insertNewObjectFrom:newContent];
  
  NSDate *fromDate = [[NSDateFormatter ISO8601Formatter] dateFromString:@"2017-10-20T07:00:01Z"];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentsFrom:fromDate to:nil pageSize:10 cursor:nil sort:0 filter:nil  completion:^(NSArray * _Nullable contents, bool hasMore, NSString * _Nullable cursor, NSError * _Nullable error) {
    XCTAssertNotNil(contents);
    XCTAssertEqual(contents.count, 1);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentsToDate {
  XMMContent *newContent = [[XMMContent alloc] init];
  newContent.ID = @"1";
  newContent.title = @"Ab";
  newContent.fromDate = [[NSDateFormatter ISO8601Formatter] dateFromString:@"2017-10-20T07:02:01Z"];
  newContent.toDate = [[NSDateFormatter ISO8601Formatter] dateFromString:@"2017-10-20T08:02:01Z"];
  [XMMCDContent insertNewObjectFrom:newContent];
  
  NSDate *toDate = [[NSDateFormatter ISO8601Formatter] dateFromString:@"2017-10-20T08:10:01Z"];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi contentsFrom:nil to:toDate pageSize:10 cursor:nil sort:0 filter:nil completion:^(NSArray * _Nullable contents, bool hasMore, NSString * _Nullable cursor, NSError * _Nullable error) {
    XCTAssertNotNil(contents);
    XCTAssertEqual(contents.count, 1);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSpotWithId {
  XMMSpot *checkSpot = [[XMMSpot alloc] init];
  checkSpot.ID = @"1";
  [XMMCDSpot insertNewObjectFrom:checkSpot];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi spotWithID:@"1" completion:^(XMMSpot *spot, NSError *error) {
    XCTAssertNotNil(spot);
    XCTAssertNil(error);
    XCTAssertEqual(spot.ID, checkSpot.ID);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSpotWithoutResult {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi spotWithID:@"1" completion:^(XMMSpot *spot, NSError *error) {
    XCTAssertEqual(error.code, 100);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSpotWithTooManyResults {
  XMMSpot *checkSpot = [[XMMSpot alloc] init];
  checkSpot.ID = @"1";
  [XMMCDSpot insertNewObjectFrom:checkSpot];
  
  XMMCDSpot *checkSpot2 = [NSEntityDescription
                           insertNewObjectForEntityForName:[XMMCDSpot coreDataEntityName]
                           inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  checkSpot2.jsonID = @"1";
  [[XMMOfflineStorageManager sharedInstance] save];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi spotWithID:@"1" completion:^(XMMSpot *spot, NSError *error) {
    XCTAssertEqual(error.code, 101);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSpotsWithLocation {
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"5";
  content.title = @"d";
  
  XMMContent *content1 = [[XMMContent alloc] init];
  content1.ID = @"6";
  content1.title = @"s";
  
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
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6247222 longitude:14.3052778];

  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi spotsWithLocation:location radius:60 pageSize:1 cursor:nil completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNotNil(spots);
    XCTAssertEqual(spots.count, 1);
    XCTAssertTrue(hasMore);
    XCTAssertTrue([cursor isEqualToString:@"1"]);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSpotsWithLocationNil {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi spotsWithLocation:nil radius:60 pageSize:1 cursor:nil completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertEqual(error.code, 102);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSpotsWithTags {
  XMMSpot *newSpot = [[XMMSpot alloc] init];
  newSpot.ID = @"1";
  newSpot.name = @"b";
  newSpot.tags = @[@"tag1", @"tag2"];
  [XMMCDSpot insertNewObjectFrom:newSpot];
  
  XMMSpot *newSpot1 = [[XMMSpot alloc] init];
  newSpot1.ID = @"2";
  newSpot1.name = @"a";
  newSpot1.tags = @[@"tag2"];
  [XMMCDSpot insertNewObjectFrom:newSpot1];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi spotsWithTags:@[@"tag1", @"tag2"] pageSize:1 cursor:nil sort:XMMSpotSortOptionsName completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNotNil(spots);
    XMMSpot *savedSpot = spots[0];
    XCTAssertTrue([savedSpot.name isEqualToString:@"a"]);
    XCTAssertTrue(hasMore);
    XCTAssertTrue([cursor isEqualToString:@"1"]);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSpotsWithTagsSortNameDesc {
  XMMSpot *newSpot = [[XMMSpot alloc] init];
  newSpot.ID = @"1";
  newSpot.name = @"b";
  newSpot.tags = @[@"tag1", @"tag2"];
  [XMMCDSpot insertNewObjectFrom:newSpot];
  
  XMMSpot *newSpot1 = [[XMMSpot alloc] init];
  newSpot1.ID = @"2";
  newSpot1.name = @"a";
  newSpot1.tags = @[@"tag2"];
  [XMMCDSpot insertNewObjectFrom:newSpot1];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi spotsWithTags:@[@"tag1", @"tag2"] pageSize:1 cursor:nil sort:XMMSpotSortOptionsNameDesc completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNotNil(spots);
    XMMSpot *savedSpot = spots[0];
    XCTAssertTrue([savedSpot.name isEqualToString:@"b"]);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSpotsWithTagsNil {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi spotsWithTags:nil pageSize:1 cursor:nil sort:XMMSpotSortOptionsName completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNil(spots);
    XCTAssertEqual(error.code, 102);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSpotsWithName {
  XMMSpot *newSpot = [[XMMSpot alloc] init];
  newSpot.ID = @"1";
  newSpot.name = @"b";
  [XMMCDSpot insertNewObjectFrom:newSpot];

  XMMSpot *newSpot2 = [[XMMSpot alloc] init];
  newSpot2.ID = @"2";
  newSpot2.name = @"aB";
  [XMMCDSpot insertNewObjectFrom:newSpot2];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi spotsWithName:@"b" pageSize:2 cursor:nil sort:XMMSpotSortOptionsNone completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNotNil(spots);
    XCTAssertEqual(spots.count, 2);
    XMMSpot *spot = spots[0];
    XCTAssertEqual(spot.name, newSpot.name);
    XCTAssertFalse(hasMore);
    XCTAssertTrue([cursor isEqualToString:@"1"]);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSpotsWithNameNil {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi spotsWithName:nil pageSize:2 cursor:nil sort:XMMSpotSortOptionsNone completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertEqual(error.code, 102);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystemWithCompletion {
  XMMSystem *system = [[XMMSystem alloc] init];
  system.ID = @"1";
  
  [XMMCDSystem insertNewObjectFrom:system];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi systemWithCompletion:^(XMMSystem *system, NSError *error) {
    XCTAssertTrue([system.ID isEqualToString:@"1"]);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystemWithTooManyResults {
  XMMSystem *system = [[XMMSystem alloc] init];
  system.ID = @"1";
  [XMMCDSystem insertNewObjectFrom:system];

  XMMCDSystem *system2 = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDSystem coreDataEntityName] inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  system2.jsonID = @"1";
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi systemWithCompletion:^(XMMSystem *system, NSError *error) {
    XCTAssertEqual(error.code, 101);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystemWithNoResults {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi systemWithCompletion:^(XMMSystem *system, NSError *error) {
    XCTAssertEqual(error.code, 100);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystemWithID {
  XMMSystem *system = [[XMMSystem alloc] init];
  system.ID = @"1";
  
  [XMMCDSystem insertNewObjectFrom:system];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi systemWithID:@"1" completion:^(XMMSystem *system, NSError *error) {
    XCTAssertTrue([system.ID isEqualToString:@"1"]);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystemWithIDTooManyResults {
  XMMSystem *system = [[XMMSystem alloc] init];
  system.ID = @"1";
  [XMMCDSystem insertNewObjectFrom:system];
  
  XMMCDSystem *system2 = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDSystem coreDataEntityName] inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  system2.jsonID = @"1";
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi systemWithID:@"1" completion:^(XMMSystem *system, NSError *error) {
    XCTAssertEqual(error.code, 101);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystemWithIDNoResults {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi systemWithID:@"1" completion:^(XMMSystem *system, NSError *error) {
    XCTAssertEqual(error.code, 100);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystemSettingsWithID {
  XMMSystemSettings *newSettings = [[XMMSystemSettings alloc] init];
  newSettings.ID = @"1";
  newSettings.itunesAppId = @"itunes";
  newSettings.googlePlayAppId = @"play";
  [XMMCDSystemSettings insertNewObjectFrom:newSettings];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi systemSettingsWithID:@"1" completion:^(XMMSystemSettings *settings, NSError *error) {
    XCTAssertNil(error);
    XCTAssertNotNil(settings);
    XCTAssertTrue([newSettings.itunesAppId isEqualToString:settings.itunesAppId]);
    XCTAssertTrue([newSettings.googlePlayAppId isEqualToString:settings.googlePlayAppId]);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystemSettingsWithIDTooManyResults {
  XMMSystemSettings *newSettings = [[XMMSystemSettings alloc] init];
  newSettings.ID = @"1";
  [XMMCDSystemSettings insertNewObjectFrom:newSettings];
  
  XMMCDSystemSettings *newSettings2 = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDSystemSettings coreDataEntityName] inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  newSettings2.jsonID = @"1";
  [[XMMOfflineStorageManager sharedInstance] save];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi systemSettingsWithID:@"1" completion:^(XMMSystemSettings *settings, NSError *error) {
    XCTAssertEqual(error.code, 101);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystemSettingsWithNil {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi systemSettingsWithID:nil completion:^(XMMSystemSettings *settings, NSError *error) {
    XCTAssertEqual(error.code, 100);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testStyleWithID {
  XMMStyle *newStyle = [[XMMStyle alloc] init];
  newStyle.ID = @"1";
  newStyle.backgroundColor = @"#000000";
  [XMMCDStyle insertNewObjectFrom:newStyle];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi styleWithID:@"1" completion:^(XMMStyle *style, NSError *error) {
    XCTAssertNil(error);
    XCTAssertNotNil(style);
    XCTAssertTrue([newStyle.backgroundColor isEqualToString:style.backgroundColor]);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testStyleWithIDTooManyResults {
  XMMStyle *newStyle = [[XMMStyle alloc] init];
  newStyle.ID = @"1";
  newStyle.backgroundColor = @"#000000";
  [XMMCDStyle insertNewObjectFrom:newStyle];
  
  XMMCDStyle *newStyle2 = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDStyle coreDataEntityName] inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  newStyle2.jsonID = @"1";
  [[XMMOfflineStorageManager sharedInstance] save];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi styleWithID:@"1" completion:^(XMMStyle *style, NSError *error) {
    XCTAssertEqual(error.code, 101);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testStyleWithNil {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi styleWithID:nil completion:^(XMMStyle *style, NSError *error) {
    XCTAssertEqual(error.code, 100);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testMenuWithId {
  XMMContent *menuItem = [[XMMContent alloc] init];
  menuItem.ID = @"2";
 
  XMMMenu *newMenu = [[XMMMenu alloc] init];
  newMenu.ID = @"1";
  newMenu.items = @[menuItem];
  [XMMCDMenu insertNewObjectFrom:newMenu];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi menuWithID:@"1" completion:^(XMMMenu *menu, NSError *error) {
    XCTAssertNotNil(menu);
    XCTAssertNil(error);
    XMMContent *savedMenuItem = menu.items[0];
    XCTAssertEqual(savedMenuItem.ID, @"2");
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testMenuWithIdTooManyResults {
  XMMContent *menuItem = [[XMMContent alloc] init];
  menuItem.ID = @"2";
  
  XMMMenu *newMenu = [[XMMMenu alloc] init];
  newMenu.ID = @"1";
  newMenu.items = @[menuItem];
  [XMMCDMenu insertNewObjectFrom:newMenu];
  
  XMMCDMenu *newMenu2 = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDMenu coreDataEntityName] inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  newMenu2.jsonID = @"1";
  [[XMMOfflineStorageManager sharedInstance] save];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi menuWithID:@"1" completion:^(XMMMenu *menu, NSError *error) {
    XCTAssertEqual(error.code, 101);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testMenuWithNil {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineApi menuWithID:nil completion:^(XMMMenu *menu, NSError *error) {
    XCTAssertEqual(error.code, 100);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

@end
