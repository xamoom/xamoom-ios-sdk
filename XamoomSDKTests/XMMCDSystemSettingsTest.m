//
//  XMMCDSystemSettingsTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMCDSystemSettings.h"
#import "XMMSystemSettings.h"
#import "XMMCDSystemSettings.h"

@interface XMMCDSystemSettingsTest : XCTestCase

@end

@implementation XMMCDSystemSettingsTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCoreDataEntityName {
  XCTAssertTrue([[XMMCDSystemSettings coreDataEntityName] isEqualToString:@"XMMCDSystemSettings"]);
}

- (void)testInsertNewObjectFromEntityWithNoExistingEntry {
  XMMSystemSettings *settings = [[XMMSystemSettings alloc] init];
  settings.ID = @"1";
  settings.googlePlayAppId = @"play";
  settings.itunesAppId = @"itunes";
  settings.socialSharingEnabled = YES;
  
  XMMCDSystemSettings *offlineSettings = [XMMCDSystemSettings insertNewObjectFrom:settings];
  
  XCTAssertTrue([offlineSettings.jsonID isEqualToString:settings.ID]);
  XCTAssertTrue([offlineSettings.googlePlayId isEqualToString:settings.googlePlayAppId]);
  XCTAssertTrue([offlineSettings.itunesAppId isEqualToString:settings.itunesAppId]);
  XCTAssertTrue(offlineSettings.socialSharingEnabled);
}

@end
