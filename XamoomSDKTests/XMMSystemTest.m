//
//  XMMSystemTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 07/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMSystem.h"
#import "XMMCDSystem.h"

@interface XMMSystemTest : XCTestCase

@end

@implementation XMMSystemTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSystemResourceName {
  XCTAssertTrue([[XMMSystem resourceName] isEqualToString:@"systems"]);
}

- (void)testInitWithCoreDataObject {
  XMMSystem *system = [[XMMSystem alloc] init];
  system.ID = @"1";
  system.name = @"name";
  system.url = @"url";
  
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
  
  XMMSystem *newSystem = [[XMMSystem alloc] initWithCoreDataObject:savedSystem];
  
  XCTAssertTrue([newSystem.ID isEqualToString:system.ID]);
  XCTAssertTrue([newSystem.name isEqualToString:system.name]);
  XCTAssertTrue([newSystem.url isEqualToString:system.url]);
  XCTAssertTrue([newSystem.setting.ID isEqualToString:settings.ID]);
  XCTAssertTrue([newSystem.menu.ID isEqualToString:menu.ID]);
  XCTAssertTrue([newSystem.style.ID isEqualToString:style.ID]);
}

- (void)testSaveOffline {
  XMMSystem *system = [[XMMSystem alloc] init];
  system.ID = @"1";
  
  XMMCDSystem *savedSystem = [system saveOffline];
  
  XCTAssertNotNil(savedSystem);
}

@end
