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

@property XMMRestClient *restClient;

@end

@implementation XMMEnduserApiTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  NSDictionary *httpHeaders = @{@"Content-Type":@"application/vnd.api+json",
                                @"User-Agent":@"XamoomSDK iOS",
                                @"APIKEY":@"apikey",};
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:httpHeaders];
  self.restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:@"http://xamoom.test"] session:[NSURLSession sessionWithConfiguration:config]];
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
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:self.restClient];
  
  XCTAssertNotNil(api);
  XCTAssertNotNil(api.restClient);
  XCTAssertTrue([api.systemLanguage isEqualToString:@"en"]);
}

- (void)testThatContentWithIdCallsFetchResourceWithParamaters {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSString *contentID = @"28d13571a9614cc19d624528ed7c2bb8";
  
  [api contentWithID:contentID completion:^(XMMContent *content, NSError *error) {
    //
  }];
  
  OCMVerify([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                                       id:[OCMArg isEqual:contentID]
                               parameters:[OCMArg isEqual:@{@"lang":@"en"}]
                               completion:[OCMArg any]]);
}

- (void)testThatContentWithIdReturnsContentViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMPartialMock(self.restClient);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSString *contentID = @"28d13571a9614cc19d624528ed7c2bb8";
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentJson]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api contentWithID:contentID completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertTrue([content.ID isEqualToString:contentID]);
    XCTAssertTrue([content.title isEqualToString:@"Testseite"]);
    XCTAssertNotNil(content.imagePublicUrl);
    XCTAssertNotNil(content.contentDescription);
    XCTAssertTrue(content.contentBlocks.count == 7);
    XCTAssertNil(content.spot);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
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

#pragma mark - Load json

- (NSDictionary *)contentJson {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"content" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  return json;
}

@end
