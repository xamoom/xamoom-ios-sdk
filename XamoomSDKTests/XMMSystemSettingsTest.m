//
//  XMMSystemSettingsTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 06/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMSystemSettings.h"
#import "XMMCDSystemSettings.h"

@interface XMMSystemSettingsTest : XCTestCase

@end

@implementation XMMSystemSettingsTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSystemSettingsResourceName {
  XCTAssertTrue([[XMMSystemSettings resourceName] isEqualToString:@"settings"]);
}

- (void)testInitWithCoreDataObject {
  XMMSystemSettings *checkSettings = [[XMMSystemSettings alloc] init];
  checkSettings.ID = @"1";
  checkSettings.googlePlayAppId = @"play";
  checkSettings.itunesAppId = @"itunes";
  
  XMMCDSystemSettings *offlineSettings = [XMMCDSystemSettings insertNewObjectFrom:checkSettings];
  
  XMMSystemSettings *settings = [[XMMSystemSettings alloc] initWithCoreDataObject:offlineSettings];
  
  XCTAssertTrue([checkSettings.ID isEqualToString:settings.ID]);
  XCTAssertTrue([checkSettings.googlePlayAppId isEqualToString:settings.googlePlayAppId]);
  XCTAssertTrue([checkSettings.itunesAppId isEqualToString:settings.itunesAppId]);
}

@end
