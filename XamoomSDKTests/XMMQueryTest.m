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
  self.devApiUrl = @"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer";
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
  NSString *testString = @"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer/systems";
  
  NSURL *result = [self.query urlWithResource:[XMMSystem class]];
  
  XCTAssertTrue([testString isEqualToString:result.absoluteString]);
}

- (void)testUrlWithResourceId {
  NSString *testString = @"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer/systems/5755996320301056";
  
  NSURL *result = [self.query urlWithResource:[XMMSystem class] id:@"5755996320301056"];
  
  XCTAssertTrue([testString isEqualToString:result.absoluteString]);
}

- (void)testAddQueryParameterToUrl {
  NSURL *url = [NSURL URLWithString:@"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer/systems/5755996320301056"];
  NSString *testString = [NSString stringWithFormat:@"%@?%@", @"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer/systems/5755996320301056", [@"lang=de" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
  NSURL *result = [self.query addQueryParameterToUrl:url name:@"lang" value:@"de"];
  
  XCTAssertTrue([testString isEqualToString:result.absoluteString]);
}

- (void)testAddQueryParameterToUrlWithUmlaut {
  NSURL *url = [NSURL URLWithString:@"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer/systems/5755996320301056"];
  NSString *testString = [NSString stringWithFormat:@"%@?%@", @"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer/systems/5755996320301056", [@"lang=ö" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
  
  NSURL *result = [self.query addQueryParameterToUrl:url name:@"lang" value:@"ö"];
  
  XCTAssertTrue([testString isEqualToString:result.absoluteString]);
}

- (void)testAddQueryParametersToUrl {
  NSURL *url = [NSURL URLWithString:@"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer/systems/5755996320301056"];
  NSString *testString = [NSString stringWithFormat:@"%@?%@", @"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer/systems/5755996320301056", [@"filter[sort]=asc&lang=de" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
  
  NSURL *result = [self.query addQueryParametersToUrl:url parameters:@{@"lang":@"de",@"filter[sort]":@"asc"}];
  
  XCTAssertTrue([testString isEqualToString:result.absoluteString]);
}

- (void)testAddQueryParametersWithNil {
  NSURL *url = [NSURL URLWithString:@"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer/systems/5755996320301056"];
  NSString *testString = @"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer/systems/5755996320301056?";
  
  NSURL *result = [self.query addQueryParametersToUrl:url parameters:nil];
  
  XCTAssertTrue([testString isEqualToString:result.absoluteString]);
}

@end
