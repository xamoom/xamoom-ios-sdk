//
//  XMMCDMenuItemTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMMenuItem.h"
#import "XMMCDMenuItem.h"
#import "XMMOfflineStorageManager.h"

@interface XMMCDMenuItemTest : XCTestCase

@end

@implementation XMMCDMenuItemTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCoreDataEntityName {
  XCTAssertTrue([[XMMCDMenuItem coreDataEntityName] isEqualToString:@"XMMCDMenuItem"]);
}

- (void)testInsertNewObjectFromEntityWithNoExistingEntry {
  XMMMenuItem *testItem = [[XMMMenuItem alloc] init];
  testItem.ID = @"1";
  testItem.contentTitle = @"Test";
  testItem.category = 2;
  
  XMMCDMenuItem *savedMenuItem = [XMMCDMenuItem insertNewObjectFrom:testItem];
  
  XCTAssertTrue([savedMenuItem.jsonID isEqualToString:testItem.ID]);
  XCTAssertTrue([savedMenuItem.contentTitle isEqualToString:testItem.contentTitle]);
  XCTAssertEqual([savedMenuItem.category intValue], testItem.category);
}

@end
