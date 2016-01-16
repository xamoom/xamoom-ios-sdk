//
//  XMMQueryTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 15/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMQuery.h"
#import "XMMSystem.h"

@interface XMMQueryTest : XCTestCase

@property XMMQuery *query;
@property NSString *devApiUrl;

@end

@implementation XMMQueryTest

- (void)setUp {
  [super setUp];
  self.devApiUrl = @"https://22-dot-xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer";
  self.query = [[XMMQuery alloc] initWithBaseUrl:[NSURL URLWithString:self.devApiUrl]];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testInitWithBaseUrl {
  XMMQuery *query = [[XMMQuery alloc] initWithBaseUrl:[NSURL URLWithString:self.devApiUrl]];
  
  XCTAssertNotNil(query);
  XCTAssertTrue([self.devApiUrl isEqualToString:query.baseUrl.absoluteString]);
}

- (void)testUrlWithResource {
  NSString *testString = @"https://22-dot-xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer/systems";
  
  NSURL *result = [self.query urlWithResource:[XMMSystem class]];
  
  XCTAssertTrue([testString isEqualToString:result.absoluteString]);
}

@end
