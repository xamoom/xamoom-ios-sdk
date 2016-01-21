//
//  XMMEnduserApiTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 21/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XMMEnduserApi.h"

@interface XMMEnduserApiTest : XCTestCase

@end

@implementation XMMEnduserApiTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testInitWithApiKey {
  NSDictionary *httpHeaders = @{@"Content-Type":@"application/vnd.api+json",
                                @"User-Agent":@"XamoomSDK iOS",
                                @"APIKEY":@"apikey",};
  
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithApiKey:@"apikey"];
  
  XCTAssertNotNil(api);
  XCTAssertNotNil(api.restClient);
  XCTAssertTrue([api.restClient.session.configuration.HTTPAdditionalHeaders isEqualToDictionary:httpHeaders]);
  XCTAssertTrue([api.systemLanguage isEqualToString:@"en"]);
}

- (void)testInitWithApiKeyBaseUrlRestClient {
  NSDictionary *httpHeaders = @{@"Content-Type":@"application/vnd.api+json",
                                @"User-Agent":@"XamoomSDK iOS",
                                @"APIKEY":@"apikey",};
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:httpHeaders];
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:@"http://xamoom.test"] session:[NSURLSession sessionWithConfiguration:config]];
  
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:restClient];
  
  XCTAssertNotNil(api);
  XCTAssertNotNil(api.restClient);
  XCTAssertTrue([api.restClient.session.configuration.HTTPAdditionalHeaders isEqualToDictionary:httpHeaders]);
  XCTAssertTrue([api.systemLanguage isEqualToString:@"en"]);
}

- (void)testContentWithId {
  //XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  XMMEnduserApi *api = OCMPartialMock([[XMMEnduserApi alloc] initWithApiKey:@""]);
  NSString *contentID = @"asdfghjkl";
  
  [api contentWithID:contentID completion:^(XMMContent *content, NSError *error) {
    
    //[expectation fulfill];
  }];
  
  //[self waitForExpectationsWithTimeout:1.0 handler:nil];
}

#pragma mark - Deprecated API Calls

- (void)testContentWithContentID {
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithApiKey:@""];
  [api contentWithContentID:@"" includeStyle:@"" includeMenu:@"" withLanguage:@"" full:NO preview:NO completion:^(XMMContentById *result) {
    //
  } error:^(XMMError *error) {
    //
  }];
}

- (void)testContentWithLocationIdentifier {
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithApiKey:@""];
  [api contentWithLocationIdentifier:@"" majorId:@"" includeStyle:NO includeMenu:NO withLanguage:@"" completion:^(XMMContentByLocationIdentifier *result) {
    //
  } error:^(XMMError *error) {
    //
  }];
}

- (void)testContentWithLat {
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithApiKey:@""];
  [api contentWithLat:@"" withLon:@"" withLanguage:@"" completion:^(XMMContentByLocation *result) {
    //
  } error:^(XMMError *error) {
    //
  }];
}

- (void)testSpotMapWithTags {
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithApiKey:@""];
  [api spotMapWithMapTags:@[] withLanguage:@"" includeContent:NO completion:^(XMMSpotMap *result) {
    //
  } error:^(XMMError *error) {
    //
  }];
}

- (void)testContentListWithPageSize {
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithApiKey:@""];
  [api contentListWithPageSize:10 withLanguage:@"" withCursor:nil withTags:@[] completion:^(XMMContentList *result) {
    //
  } error:^(XMMError *error) {
    //
  }];
}

- (void)testClosestSpots {
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithApiKey:@""];
  [api closestSpotsWithLat:1.0 withLon:1.0 withRadius:10 withLimit:10 withLanguage:@"" completion:^(XMMClosestSpot *result) {
    //
  } error:^(XMMError *error) {
    //
  }];
}

@end
