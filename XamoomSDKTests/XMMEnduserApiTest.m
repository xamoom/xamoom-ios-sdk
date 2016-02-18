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
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                                       id:[OCMArg isEqual:contentID]
                               parameters:[OCMArg isEqual:@{@"lang":@"en"}]
                               completion:[OCMArg any]]);
  
  [api contentWithID:contentID completion:^(XMMContent *content, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
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
    XCTAssertNil(content.imagePublicUrl);
    XCTAssertNotNil(content.contentDescription);
    XCTAssertTrue(content.contentBlocks.count == 10);
    XCTAssertTrue(content.tags.count == 3);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentWithIdOptionsCallsFetchResourceWithParamaters {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSString *contentID = @"28d13571a9614cc19d624528ed7c2bb8";
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"preview":@"true",
                                                                                  @"public-only":@"true"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                                       id:[OCMArg isEqual:contentID]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentWithID:contentID options:XMMContentOptionsPreview|XMMContentOptionsPrivate completion:^(XMMContent *content, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentWithIdOptionsReturnsContentViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMPartialMock(self.restClient);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSString *contentID = @"28d13571a9614cc19d624528ed7c2bb8";
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentPublicOnlyJson]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api contentWithID:contentID options:XMMContentOptionsPreview|XMMContentOptionsPrivate completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertTrue([content.ID isEqualToString:contentID]);
    XCTAssertTrue([content.title isEqualToString:@"Testseite"]);
    XCTAssertNil(content.imagePublicUrl);
    XCTAssertNotNil(content.contentDescription);
    XCTAssertTrue(content.contentBlocks.count == 9);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentWithLocationIdentifierCallsFetchResources {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[location-identifier]":@"7qpqr"}];
  NSString *qrMarker = @"7qpqr";
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentWithLocationIdentifier:qrMarker completion:^(XMMContent *content, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentWithLocationIdentifierReturnsContentViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMPartialMock(self.restClient);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSString *qrMarker = @"7qpqr";
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentPublicOnlyJson]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api contentWithLocationIdentifier:qrMarker completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertNotNil(content.ID);
    XCTAssertTrue([content.title isEqualToString:@"Testseite"]);
    XCTAssertNil(content.imagePublicUrl);
    XCTAssertNotNil(content.contentDescription);
    XCTAssertTrue(content.contentBlocks.count == 9);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentWithBeaconMajorCallsFetchResources {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSNumber *minor = @54222;
  NSNumber *major = @24265;
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[location-identifier]":@"54222|24265"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentWithBeaconMajor:minor minor:major completion:^(XMMContent *content, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentWithBeaconMajorReturnsContentViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMPartialMock(self.restClient);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSNumber *minor = @54222;
  NSNumber *major = @24265;
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentPublicOnlyJson]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api contentWithBeaconMajor:major minor:minor completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertNotNil(content.ID);
    XCTAssertTrue([content.title isEqualToString:@"Testseite"]);
    XCTAssertNil(content.imagePublicUrl);
    XCTAssertNotNil(content.contentDescription);
    XCTAssertTrue(content.contentBlocks.count == 9);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentsWithLocationCallsFetchResources {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                                                  @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                                                  @"page[size]":@"10"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentsWithLocation:location pageSize:10 cursor:nil sort:XMMContentSortOptionsNone completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentsWithLocationCallsFetchResourcesWithCursorAndSortName {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                                                  @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                                                  @"page[size]":@"10",
                                                                                  @"page[cursor]":@"1234",
                                                                                  @"sort":@"name"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentsWithLocation:location pageSize:10 cursor:@"1234" sort:XMMContentSortOptionsName completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentsWithLocationCallsFetchResourcesWithCursorAndSortNameDesc {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                                                  @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                                                  @"page[size]":@"10",
                                                                                  @"page[cursor]":@"1234",
                                                                                  @"sort":@"-name"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentsWithLocation:location pageSize:10 cursor:@"1234" sort:XMMContentSortOptionsNameDesc completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentsWithLocationReturnsContentHasMoreCursorViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMPartialMock(self.restClient);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentLocation]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api contentsWithLocation:location pageSize:10 cursor:nil sort:0 completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertFalse(hasMore);
    XCTAssertTrue([cursor isEqualToString:@""]);
    XCTAssertTrue(contents.count == 4);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentWithTagsCallsFetchResources {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[tags]":@"[\"tag1\",\"tag2\"]",
                                                                                  @"page[size]":@"10"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentsWithTags:@[@"tag1", @"tag2"] pageSize:10 cursor:nil sort:0 completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentWithTagsWithCursorSortCallsFetchResources {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[tags]":@"[\"tag1\",\"tag2\"]",
                                                                                  @"page[size]":@"10",
                                                                                  @"page[cursor]":@"1234",
                                                                                  @"sort":@"name"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentsWithTags:@[@"tag1", @"tag2"] pageSize:10 cursor:@"1234" sort:XMMContentSortOptionsName completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentsWithTagsReturnsContentHasMoreCursorViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMPartialMock(self.restClient);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSArray *tags = @[@"tag1", @"tag2"];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentLocation]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api contentsWithTags:tags pageSize:10 cursor:nil sort:0 completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertFalse(hasMore);
    XCTAssertTrue([cursor isEqualToString:@""]);
    XCTAssertTrue(contents.count == 4);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotWithLocationRadiusCallsFetchResources {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en",
                                                      @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                      @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                      @"filter[radius]":@"100"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSpot class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api spotsWithLocation:location radius:100 options:XMMSpotOptionsNone completion:^(NSArray *contents, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSpotWithLocationRadiusOptionCallsFetchResources {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102000001 longitude:14.2628843];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en",
                                                      @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                      @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                      @"filter[radius]":@"100",
                                                      @"include_marker":@"true",
                                                      @"include_content":@"true"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSpot class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api spotsWithLocation:location radius:100 options:XMMSpotOptionsIncludeMarker|XMMSpotOptionsIncludeContent completion:^(NSArray *spots, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSpotsWithLocationReturnsSpotsViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMPartialMock(self.restClient);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self spotLocation]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotsWithLocation:location radius:100 options:0 completion:^(NSArray *spots, NSError *error) {
    XCTAssertTrue(spots.count == 7);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotWithLocationRadiusOptionPageSizeCursor {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102000001 longitude:14.2628843];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en",
                                                      @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                      @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                      @"filter[radius]":@"100",
                                                      @"include_marker":@"true",
                                                      @"include_content":@"true",
                                                      @"page[size]":@"20",
                                                      @"page[cursor]":@"2"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSpot class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api spotsWithLocation:location radius:100 options:XMMSpotOptionsIncludeMarker|XMMSpotOptionsIncludeContent pageSize:20 cursor:@"2" completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    //
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSpotsWithLocationPageSizeCursorReturnsSpotsViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMPartialMock(self.restClient);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self spotLocation]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotsWithLocation:location radius:10 options:0 pageSize:10 cursor:nil completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertTrue(spots.count == 7);
    XCTAssertTrue([cursor isEqualToString:@""]);
    XCTAssertFalse(hasMore);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotsWithTagsOptionSort {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSArray *tags = @[@"tag1", @"tag2"];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en",
                                                      @"filter[tags]":@"[\"tag1\",\"tag2\"]",
                                                      @"include_marker":@"true",
                                                      @"include_content":@"true",
                                                      @"page[size]":@"100",
                                                      @"sort":@"name"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSpot class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api spotsWithTags:tags options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker sort:XMMSpotSortOptionsName completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    //
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSpotsWithTagsOptionsReturnsSpotsViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSArray *tags = @[@"tag1", @"tag2"];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self spotLocation]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotsWithTags:tags options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker sort:XMMSpotSortOptionsName completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertTrue(spots.count == 7);
    XCTAssertTrue([cursor isEqualToString:@""]);
    XCTAssertFalse(hasMore);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotsWithTagsOptionPageSizeCursor {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSArray *tags = @[@"tag1", @"tag2"];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en",
                                                      @"filter[tags]":@"[\"tag1\",\"tag2\"]",
                                                      @"include_marker":@"true",
                                                      @"include_content":@"true",
                                                      @"page[size]":@"20",
                                                      @"page[cursor]":@"1",
                                                      @"sort":@"name,distance"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSpot class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api spotsWithTags:tags pageSize:20 cursor:@"1" options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker sort:XMMSpotSortOptionsName|XMMSpotSortOptionsDistance completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    //
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSpotsWithTagsOptionsPageSizeCursorReturnsSpotsViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSArray *tags = @[@"tag1", @"tag2"];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self spotLocation]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotsWithTags:tags pageSize:20 cursor:nil options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker sort:XMMSpotSortOptionsNameDesc|XMMSpotSortOptionsDistanceDesc completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertTrue(spots.count == 7);
    XCTAssertTrue([cursor isEqualToString:@""]);
    XCTAssertFalse(hasMore);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSystemCallsFetchResource {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSystem class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api systemWithCompletion:^(XMMSystem *system, NSError *error) {
    //
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSystemReturnsSystemViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self system]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api systemWithCompletion:^(XMMSystem *system, NSError *error) {
    XCTAssertTrue([system.url isEqualToString:@"http://testpavol.at"]);
    XCTAssertTrue(system.isDemo);
    XCTAssertTrue([system.name isEqualToString:@"Dev xamoom testing UMGEBUNG"]);
    XCTAssertNotNil(system.menu);
    XCTAssertNotNil(system.style);
    XCTAssertNotNil(system.setting);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSystemSettingsCallsFetchResource {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSystemSettings class]]
                                       id:@"12345"
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api systemSettingsWithID:@"12345" completion:^(XMMSystemSettings *settings, NSError *error) {
    //
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSystemSettingsReturnsSettingsViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self systemSettings]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api systemSettingsWithID:@"12345" completion:^(XMMSystemSettings *settings, NSError *error) {
    XCTAssertTrue([settings.itunesAppId isEqualToString:@"998504165"]);
    XCTAssertTrue([settings.googlePlayAppId isEqualToString:@"com.skype.raider"]);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatStyleWithIDCallsFetchResource {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMStyle class]]
                                       id:@"12345"
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api styleWithID:@"12345" completion:^(XMMStyle *style, NSError *error) {
    //
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatStyleWithIDReturnsViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self style]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api styleWithID:@"12345" completion:^(XMMStyle *style, NSError *error) {
    XCTAssertNotNil(style.icon);
    XCTAssertNotNil(style.customMarker);
    XCTAssertTrue([style.chromeHeaderColor isEqualToString:@"#ffee00"]);
    XCTAssertTrue([style.backgroundColor isEqualToString:@"#f2f2f2"]);
    XCTAssertTrue([style.foregroundFontColor isEqualToString:@"#222222"]);
    XCTAssertTrue([style.highlightFontColor isEqualToString:@"#d6220c"]);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatMenuWithIDCallsFetchResource {
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMMenu class]]
                                       id:@"12345"
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api menuWithID:@"12345" completion:^(XMMMenu *menu, NSError *error) {
    //
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatMenuWithIDReturnsViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  id mockRestClient = OCMClassMock([XMMRestClient class]);
  XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithRestClient:mockRestClient];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self menu]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api menuWithID:@"12345" completion:^(XMMMenu *menu, NSError *error) {
    XCTAssertNotNil(menu);
    XCTAssertTrue(menu.items.count == 2);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

#pragma mark - Load json

- (NSDictionary *)contentJson {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"content" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  return json;
}

- (NSDictionary *)contentPublicOnlyJson {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"contentPublicOnly" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  return json;
}

- (NSDictionary *)contentLocation {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"contentLocation" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  return json;
}

- (NSDictionary *)spotLocation {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"spotLocation" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  return json;
}

- (NSDictionary *)system {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"system" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  return json;
}

- (NSDictionary *)systemSettings {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"systemSettings" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  return json;
}

- (NSDictionary *)style {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"style" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  return json;
}

- (NSDictionary *)menu {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"menu" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  return json;
}

@end
