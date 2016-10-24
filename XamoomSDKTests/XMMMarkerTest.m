//
//  XMMMarkerTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 07/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMMarker.h"
#import "XMMCDMarker.h"

@interface XMMMarkerTest : XCTestCase

@end

@implementation XMMMarkerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMarkerBlocksResourceName {
  XCTAssertTrue([[XMMMarker resourceName] isEqualToString:@"markers"]);
}

- (void)testInitWithCoreDataObject {
  XMMMarker *marker = [[XMMMarker alloc] init];
  marker.ID = @"1";
  marker.qr = @"qr";
  marker.nfc = @"nfc";
  marker.beaconUUID = @"uuid";
  marker.beaconMajor = @"major";
  marker.beaconMinor = @"minor";
  marker.eddyStoneUrl = @"eddystone";
  
  XMMCDMarker *savedMarker = [XMMCDMarker insertNewObjectFrom:marker];
  XMMMarker *newMarker = [[XMMMarker alloc] initWithCoreDataObject:savedMarker];
  
  XCTAssertTrue([newMarker.ID isEqualToString:marker.ID]);
  XCTAssertTrue([newMarker.qr isEqualToString:marker.qr]);
  XCTAssertTrue([newMarker.nfc isEqualToString:marker.nfc]);
  XCTAssertTrue([newMarker.beaconUUID isEqualToString:marker.beaconUUID]);
  XCTAssertTrue([newMarker.beaconMajor isEqualToString:marker.beaconMajor]);
  XCTAssertTrue([newMarker.beaconMinor isEqualToString:marker.beaconMinor]);
  XCTAssertTrue([newMarker.eddyStoneUrl isEqualToString:marker.eddyStoneUrl]);
}

- (void)testSaveOffline {
  XMMMarker *marker = [[XMMMarker alloc] init];
  marker.ID = @"1";
  
  XMMCDMarker *savedMarker = [marker saveOffline];
  
  XCTAssertNotNil(savedMarker);
}

@end
