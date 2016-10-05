//
//  XMMCDSystemTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 05/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMCDSystem.h"
#import "XMMSystem.h"
#import "XMMCDSystemSettings.h"
#import "XMMCDMenu.h"
#import "XMMCDStyle.h"

@interface XMMCDSystemTest : XCTestCase

@end

@implementation XMMCDSystemTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCoreDataEntityName {
  XCTAssertTrue([[XMMCDSystem coreDataEntityName] isEqualToString:@"XMMCDSystem"]);
}

- (void)testInsertNewObjectFromEntityWithNoExistingEntry {
  XMMSystem *system = [[XMMSystem alloc] init];
  system.ID = @"1";
  
  XMMStyle *style = [[XMMStyle alloc] init];
  style.ID = @"2";
  system.style = style;
  
  XMMMenu *menu = [[XMMMenu alloc] init];
  menu.ID = @"3";
  system.menu = menu;
  
  XMMSystemSettings *settings = [[XMMSystemSettings alloc] init];
  settings.ID = @"4";
  system.setting = settings;
  
  XMMCDSystem *savedSystem = [XMMCDSystem insertNewObjectFrom:system];
  
  XCTAssertTrue([savedSystem.jsonID isEqualToString:system.ID]);
  XCTAssertTrue([savedSystem.setting.jsonID isEqualToString:settings.ID]);
  XCTAssertTrue([savedSystem.menu.jsonID isEqualToString:menu.ID]);
  XCTAssertTrue([savedSystem.style.jsonID isEqualToString:style.ID]);
}

@end
