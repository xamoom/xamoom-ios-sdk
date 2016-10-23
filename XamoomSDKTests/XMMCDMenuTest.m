//
//  XMMCDMenuTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMMenu.h"
#import "XMMContent.h"
#import "XMMCDMenu.h"
#import "XMMOfflineStorageManager.h"

@interface XMMCDMenuTest : XCTestCase

@end

@implementation XMMCDMenuTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCoreDataEntityName {
  XCTAssertTrue([[XMMCDMenu coreDataEntityName] isEqualToString:@"XMMCDMenu"]);
}

- (void)testInsertNewObjectFromEntityWithNoExistingEntry {
  XMMMenu *menu = [[XMMMenu alloc] init];
  menu.ID = @"1";
  XMMContent *testItem = [[XMMContent alloc] init];
  testItem.title = @"Test";
  testItem.category = 2;
  menu.items = @[testItem];
  
  XMMCDMenu *offlineMenu = [XMMCDMenu insertNewObjectFrom:menu];
  XMMCDMenuItem *savedMenuItem = offlineMenu.items.firstObject;

  XCTAssertTrue([offlineMenu.jsonID isEqualToString:menu.ID]);
  XCTAssertNotNil(offlineMenu.items);
  XCTAssertTrue([savedMenuItem.contentTitle isEqualToString:testItem.title]);
  XCTAssertEqual([savedMenuItem.category intValue], testItem.category);
}

@end
