//
//  XMMRestResourceTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 22/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMMenu.h"
#import "XMMSystem.h"
#import "XMMContent.h"

@interface XMMRestResourceTests : XCTestCase

@end

@implementation XMMRestResourceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMenuResourceName {
  XCTAssertTrue([[XMMMenu resourceName] isEqualToString:@"menus"]);
}

- (void)testMenuItemResourceName {
  XCTAssertTrue([[XMMMenuItem resourceName] isEqualToString:@"content"]);
}

- (void)testSystemResourceName {
  XCTAssertTrue([[XMMSystem resourceName] isEqualToString:@"systems"]);
}

- (void)testSystemSettingsResourceName {
  XCTAssertTrue([[XMMSystemSettings resourceName] isEqualToString:@"settings"]);
}

- (void)testStyleResourceName {
  XCTAssertTrue([[XMMStyle resourceName] isEqualToString:@"styles"]);
}

- (void)testContentResourceName {
  XCTAssertTrue([[XMMContent resourceName] isEqualToString:@"contents"]);
}

- (void)testContentBlocksResourceName {
  XCTAssertTrue([[XMMContentBlock resourceName] isEqualToString:@"contentblocks"]);
}

- (void)testSpotBlocksResourceName {
  XCTAssertTrue([[XMMSpot resourceName] isEqualToString:@"spots"]);
}

- (void)testMarkerBlocksResourceName {
  XCTAssertTrue([[XMMMarker resourceName] isEqualToString:@"markers"]);
}

@end
