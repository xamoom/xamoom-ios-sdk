//
//  XMMSpotTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 07/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMSpot.h"
#import "XMMCDSpot.h"

@interface XMMSpotTest : XCTestCase

@end

@implementation XMMSpotTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSpotBlocksResourceName {
  XCTAssertTrue([[XMMSpot resourceName] isEqualToString:@"spots"]);
}


- (void)testInsertNewObjectFromEntityWithNoExistingEntry {
  XMMSpot *spot = [[XMMSpot alloc] init];
  spot.ID = @"1";
  spot.name = @"name";
  spot.spotDescription = @"description";
  spot.latitude = 14.0;
  spot.longitude = 26.0;
  spot.image = @"url";
  spot.category = 1;
  spot.tags = @[@"tag1", @"tag2"];
  
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"2";
  spot.content = content;
  
  XMMSystem *system = [[XMMSystem alloc] init];
  system.ID = @"3";
  spot.system = system;
  
  XMMMarker *marker = [[XMMMarker alloc] init];
  marker.ID = @"4";
  spot.markers = @[marker, marker];
  
  XMMCDSpot *savedSpot = [XMMCDSpot insertNewObjectFrom:spot];
  XMMSpot *newSpot = [[XMMSpot alloc] initWithCoreDataObject:savedSpot];
  
  XCTAssertTrue([newSpot.ID isEqualToString:spot.ID]);
  XCTAssertTrue([newSpot.content.ID isEqualToString:spot.content.ID]);
  XCTAssertTrue([newSpot.system.ID isEqualToString:spot.system.ID]);
  XCTAssertNotNil(newSpot.markers);
  for (int i = 0; i < newSpot.markers.count; i++) {
    XMMMarker *newMarker = newSpot.markers[i];
    XMMMarker *marker = spot.markers[i];
    XCTAssertTrue([newMarker.ID isEqualToString:marker.ID]);
  }
  
  XCTAssertTrue([newSpot.name isEqualToString:spot.name]);
  XCTAssertTrue([newSpot.spotDescription isEqualToString:spot.spotDescription]);
  XCTAssertEqual(newSpot.locationDictionary, spot.locationDictionary);
  XCTAssertTrue([newSpot.image isEqualToString:spot.image]);
  XCTAssertTrue(newSpot.category == spot.category);
  XCTAssertEqual(newSpot.tags, spot.tags);
}

@end
