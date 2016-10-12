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
  [self.offlineApi contentsWithLocation:location pageSize:2 cursor:nil sort:XMMContentSortOptionsNameDesc completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
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
  [self.offlineApi contentsWithTags:@[@"tag1", @"tag2"] pageSize:10 cursor:nil sort:XMMContentSortOptionsName completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
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
  [self.offlineApi contentsWithTags:nil pageSize:10 cursor:nil sort:XMMContentSortOptionsNone completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
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
  [self.offlineApi contentsWithName:@"A" pageSize:10 cursor:nil sort:XMMContentSortOptionsNameDesc completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
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
  [self.offlineApi contentsWithName:nil pageSize:10 cursor:nil sort:XMMContentSortOptionsNameDesc completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNil(contents);
    XCTAssertEqual(error.code, 102);
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


@end
