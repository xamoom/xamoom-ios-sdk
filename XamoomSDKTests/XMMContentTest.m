//
//  XMMContentTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 07/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMContent.h"
#import "XMMCDContent.h"

@interface XMMContentTest : XCTestCase

@end

@implementation XMMContentTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testContentResourceName {
  XCTAssertTrue([[XMMContent resourceName] isEqualToString:@"contents"]);
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
  
  NSMutableArray *contentBlocks = [[NSMutableArray alloc] init];
  XMMContentBlock *contentBlock = [[XMMContentBlock alloc] init];
  contentBlock.ID = @"1";
  [contentBlocks addObject:contentBlock];
  XMMContentBlock *contentBlock2 = [[XMMContentBlock alloc] init];
  contentBlock2.ID = @"2";
  [contentBlocks addObject:contentBlock2];
  content.contentBlocks = contentBlocks;
  
  XMMCDContent *savedContent = [XMMCDContent insertNewObjectFrom:content];
  XMMContent *newContent = [[XMMContent alloc] initWithCoreDataObject:savedContent];
  
  XCTAssertTrue([newContent.ID isEqualToString:content.ID]);
  XCTAssertTrue([newContent.system.ID isEqualToString:content.system.ID]);
  XCTAssertNotNil(newContent.contentBlocks);
  for (int i = 0; i < newContent.contentBlocks.count; i++) {
    XMMContentBlock *block = contentBlocks[i];
    XMMContentBlock *savedBlock = newContent.contentBlocks[i];
    XCTAssertTrue([savedBlock.ID isEqualToString:block.ID]);
  }
  
  XCTAssertTrue([newContent.title isEqualToString:content.title]);
  XCTAssertTrue([newContent.imagePublicUrl isEqualToString:content.imagePublicUrl]);
  XCTAssertTrue([newContent.contentDescription isEqualToString:content.contentDescription]);
  XCTAssertTrue([newContent.language isEqualToString:content.language]);
  XCTAssertTrue(newContent.category == content.category);
  XCTAssertEqual(newContent.tags, content.tags);
}

- (void)testSaveOffline {
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"1";
  
  XMMCDMenuItem *savedMenuItem = [content saveOffline];
  
  XCTAssertNotNil(savedMenuItem);
}

@end
