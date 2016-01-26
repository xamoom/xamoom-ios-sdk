//
//  XMMRestClientTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 15/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XMMRestClient.h"
#import "XMMSystem.h"

@interface XMMRestClientTest : XCTestCase

@property NSString *devApiUrl;

@end

@implementation XMMRestClientTest

- (void)setUp {
  [super setUp];
  self.devApiUrl = @"https://23-dot-xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer";
}

- (void)tearDown {
  [super tearDown];
}

- (void)testInitWithBaseUrl {
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:self.devApiUrl] session:[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]];
  XCTAssertNotNil(restClient);
  XCTAssertNotNil(restClient.query);
  XCTAssertNotNil(restClient.session);
}

- (void)testFetchResourceCallsCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id session = OCMPartialMock([NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]);
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:self.devApiUrl]
                                                             session:session];
  
  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(NSData *data, NSURLResponse *response, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 3];
    passedBlock([NSData new], nil, nil);
  };
  
  [[[session stub] andDo:proxyBlock] dataTaskWithURL:[OCMArg any] completionHandler:[OCMArg any]];
  
  [restClient fetchResource:[XMMSystem class] completion:^(JSONAPI *result, NSError *error) {
    XCTAssertNotNil(result);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testFetchResourceParamaterCallsCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id session = OCMPartialMock([NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]);
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:self.devApiUrl]
                                                             session:session];
  
  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(NSData *data, NSURLResponse *response, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 3];
    passedBlock([NSData new], nil, nil);
  };
  
  [[[session stub] andDo:proxyBlock] dataTaskWithURL:[OCMArg any] completionHandler:[OCMArg any]];
  
  [restClient fetchResource:[XMMSystem class] parameters:@{@"lang":@"de"} completion:^(JSONAPI *result, NSError *error) {
    XCTAssertNotNil(result);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testFetchResourceSessionIdCallsCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id session = OCMPartialMock([NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]);
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:self.devApiUrl]
                                                             session:session];
  
  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(NSData *data, NSURLResponse *response, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 3];
    passedBlock([NSData new], nil, nil);
  };
  
  [[[session stub] andDo:proxyBlock] dataTaskWithURL:[OCMArg any] completionHandler:[OCMArg any]];
  
  [restClient fetchResource:[XMMSystem class] id:@"1234" parameters:nil completion:^(JSONAPI *result, NSError *error) {
    XCTAssertNotNil(result);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testFetchResourceSessionIdCallsCallbackError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id session = OCMPartialMock([NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]);
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:self.devApiUrl]
                                                             session:session];
  
  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(NSData *data, NSURLResponse *response, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 3];
    passedBlock([NSData new], nil, [[NSError alloc] initWithDomain:@"com.xamoom.unittest" code:1 userInfo:nil]);
  };
  
  [[[session stub] andDo:proxyBlock] dataTaskWithURL:[OCMArg any] completionHandler:[OCMArg any]];
  
  [restClient fetchResource:[XMMSystem class] id:@"1234" parameters:nil completion:^(JSONAPI *result, NSError *error) {
    XCTAssertNotNil(error);
    XCTAssertNil(result);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

@end
