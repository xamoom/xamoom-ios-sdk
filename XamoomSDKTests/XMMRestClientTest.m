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
  self.devApiUrl = @"https://xamoom-cloud-dev.appspot.com/_api/v2/consumer";
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
  id mockDelegate = OCMProtocolMock(@protocol(XMMRestClientDelegate));
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockUrlResponse = OCMClassMock([NSHTTPURLResponse class]);
  [[[mockUrlResponse stub] andReturn:@{@"X-Ephemeral-Id":@"123"}] allHeaderFields];
  id session = OCMPartialMock([NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]);
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:self.devApiUrl]
                                                             session:session];
  restClient.delegate = mockDelegate;
  
  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(NSData *data, NSURLResponse *response, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 3];
    
    passedBlock([NSData new], mockUrlResponse, nil);
  };
  
  [[[session stub] andDo:proxyBlock] dataTaskWithRequest:[OCMArg checkWithBlock:^BOOL(id obj) {
    NSMutableURLRequest *request = obj;
    XCTAssertNotNil(request);
    XCTAssertTrue([[request valueForHTTPHeaderField:@"X-Ephemeral-Id"]
                   isEqualToString:@"1234"]);
    return YES;
  }] completionHandler:[OCMArg any]];
  
  [restClient fetchResource:[XMMSystem class]
                    headers:@{@"X-Ephemeral-Id":@"1234"}
                 completion:^(JSONAPI *result, NSError *error) {
    XCTAssertNotNil(result);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
  OCMVerify([mockDelegate gotEphemeralId:[OCMArg isEqual:@"123"]]);
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
  
  [[[session stub] andDo:proxyBlock] dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]];
  
  [restClient fetchResource:[XMMSystem class]
                 parameters:@{@"lang":@"de"}
                    headers:nil
                 completion:^(JSONAPI *result, NSError *error) {
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
  
  [[[session stub] andDo:proxyBlock] dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]];
  
  [restClient fetchResource:[XMMSystem class] id:@"1234"
                 parameters:nil
                    headers:nil
                 completion:^(JSONAPI *result, NSError *error) {
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
  
  [[[session stub] andDo:proxyBlock] dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]];
  
  [restClient fetchResource:[XMMSystem class]
                         id:@"1234"
                 parameters:nil
                    headers:nil
                 completion:^(JSONAPI *result, NSError *error) {
    XCTAssertNotNil(error);
    XCTAssertNil(result);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

@end
