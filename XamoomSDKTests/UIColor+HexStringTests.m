//
//  UIColor+HexStringTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 25/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIColor+HexString.h"

@interface UIColor_HexStringTests : XCTestCase

@end

@implementation UIColor_HexStringTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testRRGGBB {
  UIColor *result = [UIColor colorWithHexString:@"#000000"];
  XCTAssert([result isEqual:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]]);
}

- (void)testAARRGGBB {
  UIColor *result = [UIColor colorWithHexString:@"#00000000"];
  XCTAssert([result isEqual:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]]);
}

- (void)testRGB {
  UIColor *result = [UIColor colorWithHexString:@"#000"];
  XCTAssert([result isEqual:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]]);
}

- (void)testARGB {
  UIColor *result = [UIColor colorWithHexString:@"#0000"];
  XCTAssert([result isEqual:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]]);
}

- (void)testException {
  XCTAssertThrows([UIColor colorWithHexString:@"#000000000"]);
}

@end
