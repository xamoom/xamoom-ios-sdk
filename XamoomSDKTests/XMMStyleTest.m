//
//  XMMStyleTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 06/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMStyle.h"
#import "XMMCDStyle.h"

@interface XMMStyleTest : XCTestCase

@end

@implementation XMMStyleTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStyleResourceName {
  XCTAssertTrue([[XMMStyle resourceName] isEqualToString:@"styles"]);
}

- (void)testInitWithCoreDataObject {
  XMMStyle *style = [[XMMStyle alloc] init];
  style.ID = @"1";
  style.backgroundColor = @"#111111";
  style.highlightFontColor = @"#222222";
  style.foregroundFontColor = @"#333333";
  style.chromeHeaderColor = @"#4444444";
  style.customMarker = @"#555555";
  style.icon = @"#666666";
  
  XMMCDStyle *offlineStyle = [XMMCDStyle insertNewObjectFrom:style];
  
  XMMStyle *newStyle = [[XMMStyle alloc] initWithCoreDataObject:offlineStyle];
  
  XCTAssertTrue([newStyle.ID isEqualToString:style.ID]);
  XCTAssertTrue([newStyle.backgroundColor isEqualToString:style.backgroundColor]);
  XCTAssertTrue([newStyle.highlightFontColor isEqualToString:style.highlightFontColor]);
  XCTAssertTrue([newStyle.foregroundFontColor isEqualToString:style.foregroundFontColor]);
  XCTAssertTrue([newStyle.chromeHeaderColor isEqualToString:style.chromeHeaderColor]);
  XCTAssertTrue([newStyle.customMarker isEqualToString:style.customMarker]);
  XCTAssertTrue([newStyle.icon isEqualToString:style.icon]);
}

@end
