//
//  XMMMenuTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 06/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMMenu.h"
#import "XMMCDMenu.h"
#import "XMMContent.h"

@interface XMMMenuTest : XCTestCase

@end

@implementation XMMMenuTest

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

- (void)testInitWithCoreDataObject {
  XMMMenu *menu = [[XMMMenu alloc] init];
  menu.ID = @"1";
  XMMContent *testItem = [[XMMContent alloc] init];
  testItem.title = @"Test";
  testItem.category = 2;
  menu.items = @[testItem];
  
  XMMCDMenu *offlineMenu = [XMMCDMenu insertNewObjectFrom:menu];
  
  XMMMenu *newMenu = [[XMMMenu alloc] initWithCoreDataObject:offlineMenu];
  XMMMenuItem *newMenuItem = newMenu.items.firstObject;
  
  XCTAssertTrue([newMenu.ID isEqualToString:menu.ID]);
  XCTAssertNotNil(newMenu.items);
  XCTAssertTrue([newMenuItem.contentTitle isEqualToString:testItem.title]);
  XCTAssertEqual(newMenuItem.category, testItem.category);
}

- (void)testSaveOffline {
  XMMMenu *menu = [[XMMMenu alloc] init];
  menu.ID = @"1";
  
  XMMCDMenu *savedMenu = (XMMCDMenu *)[menu saveOffline];

  XCTAssertNotNil(savedMenu);
}

@end
