//
//  XMMCDStyleTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMOfflineStorageManager.h"
#import "XMMStyle.h"
#import "XMMCDStyle.h"

@interface XMMCDStyleTest : XCTestCase

@end

@implementation XMMCDStyleTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCoreDataEntityName {
  XCTAssertTrue([[XMMCDStyle coreDataEntityName] isEqualToString:@"XMMCDStyle"]);
}

- (void)testInsertNewObjectFromEntityWithNoExistingEntry {
  XMMStyle *style = [[XMMStyle alloc] init];
  style.ID = @"1";
  style.backgroundColor = @"#111111";
  style.highlightFontColor = @"#222222";
  style.foregroundFontColor = @"#333333";
  style.chromeHeaderColor = @"#4444444";
  style.customMarker = @"#555555";
  style.icon = @"#666666";
  
  XMMCDStyle *offlineStyle = [XMMCDStyle insertNewObjectFrom:style];
  
  XCTAssertTrue([offlineStyle.jsonID isEqualToString:style.ID]);
  XCTAssertTrue([offlineStyle.backgroundColor isEqualToString:style.backgroundColor]);
  XCTAssertTrue([offlineStyle.highlightFontColor isEqualToString:style.highlightFontColor]);
  XCTAssertTrue([offlineStyle.foregroundFontColor isEqualToString:style.foregroundFontColor]);
  XCTAssertTrue([offlineStyle.chromeHeaderColor isEqualToString:style.chromeHeaderColor]);
  XCTAssertTrue([offlineStyle.customMarker isEqualToString:style.customMarker]);
  XCTAssertTrue([offlineStyle.icon isEqualToString:style.icon]);
}


@end
