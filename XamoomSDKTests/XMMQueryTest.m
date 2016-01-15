//
//  XMMQueryTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 15/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMQuery.h"

@interface XMMQueryTest : XCTestCase

@property XMMQuery *query;
@property NSString *devApiUrl;

@end

@implementation XMMQueryTest

- (void)setUp {
    [super setUp];
    self.devApiUrl = @"https://22-dot-xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithBaseUrl {
  self.query = [[XMMQuery alloc] initWithBaseUrl:[NSURL URLWithString:self.devApiUrl]];
  
  XCTAssertNotNil(self.query);
  XCTAssertTrue([self.devApiUrl isEqualToString:self.query.baseUrl.absoluteString]);
}

@end
