//
//  XMMCDMarkerTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMOfflineStorageManager.h"
#import "XMMCDMarker.h"
#import "XMMMarker.h"

@interface XMMCDMarkerTest : XCTestCase

@end

@implementation XMMCDMarkerTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCoreDataEntityName {
  XCTAssertTrue([[XMMCDMarker coreDataEntityName] isEqualToString:@"XMMCDMarker"]);
}

- (void)testInsertNewObjectFromEntityWithNoExistingEntry {
  XMMMarker *marker = [[XMMMarker alloc] init];
  marker.ID = @"1";
  marker.qr = @"qr";
  marker.nfc = @"nfc";
  marker.beaconUUID = @"uuid";
  marker.beaconMajor = @"major";
  marker.beaconMinor = @"minor";
  marker.eddyStoneUrl = @"eddystone";
  
  XMMCDMarker *savedMarker = [XMMCDMarker insertNewObjectFrom:marker];
  
  XCTAssertTrue([savedMarker.jsonID isEqualToString:marker.ID]);
  XCTAssertTrue([savedMarker.qr isEqualToString:marker.qr]);
  XCTAssertTrue([savedMarker.nfc isEqualToString:marker.nfc]);
  XCTAssertTrue([savedMarker.beaconUUID isEqualToString:marker.beaconUUID]);
  XCTAssertTrue([savedMarker.beaconMajor isEqualToString:marker.beaconMajor]);
  XCTAssertTrue([savedMarker.beaconMinor isEqualToString:marker.beaconMinor]);
  XCTAssertTrue([savedMarker.eddyStoneUrl isEqualToString:marker.eddyStoneUrl]);
}


@end
