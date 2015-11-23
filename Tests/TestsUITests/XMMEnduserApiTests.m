//
//  XMMEnduserApiTests.m
//  xamoom-ios-sdk
//
//  Created by Raphael Seher on 23.11.15.
//  Copyright © 2015 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XMMEnduserApiTests : XCTestCase

@end

@implementation XMMEnduserApiTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSystemLanguage {
  NSLog(@"Test Suite - testSystemLanguage");
  
  XCTAssertNotNil([XMMEnduserApi sharedInstance].systemLanguage, @"api.systemLanguage should not be nil");
}


@end
