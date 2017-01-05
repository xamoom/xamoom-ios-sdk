//
//  XMMCDSpotTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 06/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XMMCDSpot.h"
#import "XMMSpot.h"
#import "XMMContent.h"
#import "XMMCDContent.h"

@interface XMMCDSpotTest : XCTestCase

@property XMMOfflineFileManager *mockedFileManager;

@end

@implementation XMMCDSpotTest

- (void)setUp {
  [super setUp];
  self.mockedFileManager = OCMClassMock([XMMOfflineFileManager class]);
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testCoreDataEntityName {
  XCTAssertTrue([[XMMCDSpot coreDataEntityName] isEqualToString:@"XMMCDSpot"]);
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
  spot.customMeta = @{@"key":@"value"};
  
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"2";
  spot.content = content;
  
  XMMSystem *system = [[XMMSystem alloc] init];
  system.ID = @"3";
  spot.system = system;
  
  XMMMarker *marker = [[XMMMarker alloc] init];
  marker.ID = @"4";
  spot.markers = @[marker, marker];
  
  XMMCDSpot *savedSpot = [XMMCDSpot insertNewObjectFrom:spot fileManager:self.mockedFileManager];
  
  OCMVerify([self.mockedFileManager saveFileFromUrl:[OCMArg isEqual:spot.image] completion:[OCMArg any]]);
  
  XCTAssertTrue([savedSpot.jsonID isEqualToString:spot.ID]);
  XCTAssertTrue([savedSpot.content.jsonID isEqualToString:spot.content.ID]);
  XCTAssertTrue([savedSpot.system.jsonID isEqualToString:spot.system.ID]);
  for (int i = 0; i < savedSpot.markers.count; i++) {
    XMMCDMarker *savedMarker = savedSpot.markers.allObjects[i];
    XMMMarker *marker = spot.markers[i];
    XCTAssertTrue([savedMarker.jsonID isEqualToString:marker.ID]);
  }
  
  XCTAssertTrue([savedSpot.name isEqualToString:spot.name]);
  XCTAssertTrue([savedSpot.spotDescription isEqualToString:spot.spotDescription]);
  XCTAssertEqual(savedSpot.locationDictionary, spot.locationDictionary);
  XCTAssertTrue([savedSpot.image isEqualToString:spot.image]);
  XCTAssertTrue([savedSpot.category intValue] == spot.category);
  XCTAssertEqual(savedSpot.tags, spot.tags);
  XCTAssertTrue([savedSpot.customMeta isEqualToDictionary:spot.customMeta]);
}

@end
