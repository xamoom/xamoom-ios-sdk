//
//  XMMCDContentTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 05/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMCDContent.h"
#import "XMMContent.h"
#import "XMMContentBlock.h"
#import "XMMSpot.h"
#import "XMMCDSpot.h"

@interface XMMCDContentTest : XCTestCase

@end

@implementation XMMCDContentTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCoreDataEntityName {
  XCTAssertTrue([[XMMCDContent coreDataEntityName] isEqualToString:@"XMMCDContent"]);
}

- (void)testInsertNewObjectFromEntityWithNoExistingEntry {
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"1";
  content.title = @"title";
  content.imagePublicUrl = @"imagePublicUrl";
  content.contentDescription = @"description";
  content.language = @"en";
  content.category = 1;
  content.tags = @[@"tag1", @"tag2"];
  
  XMMSystem *system = [[XMMSystem alloc] init];
  system.ID = @"2";
  content.system = system;
  
  XMMSpot *spot = [[XMMSpot alloc] init];
  spot.ID = @"3";
  content.spot = spot;
  
  XMMCDContent *savedContent = [XMMCDContent insertNewObjectFrom:content];
  
  XCTAssertTrue([savedContent.jsonID isEqualToString:content.ID]);
  XCTAssertTrue([savedContent.spot.jsonID isEqualToString:content.spot.ID]);
  XCTAssertTrue([savedContent.system.jsonID isEqualToString:content.system.ID]);
  XCTAssertTrue([savedContent.title isEqualToString:content.title]);
  XCTAssertTrue([savedContent.imagePublicUrl isEqualToString:content.imagePublicUrl]);
  XCTAssertTrue([savedContent.contentDescription isEqualToString:content.contentDescription]);
  XCTAssertTrue([savedContent.language isEqualToString:content.language]);
  XCTAssertTrue([savedContent.category intValue] == content.category);
  XCTAssertEqual(savedContent.tags, content.tags);
}

@end
