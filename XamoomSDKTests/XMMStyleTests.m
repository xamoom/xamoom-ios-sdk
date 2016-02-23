//
//  XMMStyleTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 23/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMStyle.h"

@interface XMMStyleTests : XCTestCase

@end

@implementation XMMStyleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
  XMMStyle *style = [[XMMStyle alloc] init];
  
  XCTAssertNotNil(style);
  XCTAssertTrue([style.foregroundFontColor isEqualToString:@"#000000"]);
  XCTAssertTrue([style.highlightFontColor isEqualToString:@"#0000FF"]);
  XCTAssertTrue([style.backgroundColor isEqualToString:@"#FFFFFF"]);
}

- (void)testInitWithColors {
  XMMStyle *style = [[XMMStyle alloc] initWithBackgroundColor:@"#FF0000" highlightTextColor:@"#00FF00" textColor:@"#0000FF"];
  
  XCTAssertNotNil(style);
  XCTAssertTrue([style.foregroundFontColor isEqualToString:@"#0000FF"]);
  XCTAssertTrue([style.highlightFontColor isEqualToString:@"#00FF00"]);
  XCTAssertTrue([style.backgroundColor isEqualToString:@"#FF0000"]);
}

@end
