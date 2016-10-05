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
  
  XMMCDStyle *style = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDStyle coreDataEntityName]
                                                    inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  style.jsonID = @"2";
  
  XMMCDMenu *menu = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDMenu coreDataEntityName]
                                                    inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  menu.jsonID = @"3";
  
  XMMCDSystemSettings *settings = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDSystemSettings coreDataEntityName]
                                                    inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  settings.jsonID = @"4";
  
  XMMCDSystem *savedSystem = [XMMCDSystem insertNewObjectFrom:system];
  savedSystem.setting = settings;
  savedSystem.style = style;
  savedSystem.menu = menu;
  
  XCTAssertTrue([savedSystem.jsonID isEqualToString:system.ID]);
  XCTAssertTrue([savedSystem.setting.jsonID isEqualToString:settings.jsonID]);
  XCTAssertTrue([savedSystem.menu.jsonID isEqualToString:menu.jsonID]);
  XCTAssertTrue([savedSystem.style.jsonID isEqualToString:style.jsonID]);
}

@end
