//
//  XMMContentBlocksCacheTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 22/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMContentBlocksCache.h"

@interface XMMContentBlocksCacheTests : XCTestCase

@end

@implementation XMMContentBlocksCacheTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharedInstance {
  XMMContentBlocksCache *cache = [XMMContentBlocksCache sharedInstance];
  XCTAssertNotNil(cache);
}

- (void)testSaveSpots {
  XMMSpot *spot = [[XMMSpot alloc] init];
  spot.name = @"Test";
  NSArray *spots = [NSArray arrayWithObject:spot];

  [[XMMContentBlocksCache sharedInstance] saveSpots:spots key:@"tag1,tag2"];
  
  XCTAssertTrue([[XMMContentBlocksCache sharedInstance] cachedSpotMap:@"tag1,tag2"]);
}

- (void)testSaveContent {
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"123456";
  
  [[XMMContentBlocksCache sharedInstance] saveContent:content key:content.ID];
  
  XCTAssertTrue([[XMMContentBlocksCache sharedInstance] cachedContent:content.ID]);
}

@end
