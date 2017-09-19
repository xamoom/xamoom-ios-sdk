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
#import "XMMOfflineApi.h"

@interface XMMEnduserApiTest : XCTestCase

@property XMMRestClient *restClient;
@property XMMEnduserApi *api;
@property id mockRestClient;

@end

@implementation XMMEnduserApiTest

@synthesize api, restClient, mockRestClient;

NSString* apiVersion = @"3.5.3";

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  NSDictionary *httpHeaders = @{@"Content-Type":@"application/vnd.api+json",
                                @"User-Agent":@"XamoomSDK iOS",
                                @"APIKEY":@"apikey",};
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:httpHeaders];
  self.restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:@"http://xamoom.test"] session:[NSURLSession sessionWithConfiguration:config]];
  self.mockRestClient = OCMPartialMock(self.restClient);
  self.api = [[XMMEnduserApi alloc] initWithRestClient:self.mockRestClient];
  
  
  // needed, because JSONAPIResourceDescriptors linkedTypeToResource dictionary is nil when setting api up
  [JSONAPIResourceDescriptor addResource:[XMMSystem class]];
  [JSONAPIResourceDescriptor addResource:[XMMSystemSettings class]];
  [JSONAPIResourceDescriptor addResource:[XMMStyle class]];
  [JSONAPIResourceDescriptor addResource:[XMMMenu class]];
  [JSONAPIResourceDescriptor addResource:[XMMContent class]];
  [JSONAPIResourceDescriptor addResource:[XMMContentBlock class]];
  [JSONAPIResourceDescriptor addResource:[XMMSpot class]];
  [JSONAPIResourceDescriptor addResource:[XMMMarker class]];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testInitWithApiKey {
  NSDictionary *httpHeaders = @{@"Content-Type":@"application/vnd.api+json",
                                @"User-Agent":[NSString stringWithFormat:@"XamoomSDK iOS||%@", apiVersion],
                                @"APIKEY":@"apikey",};
  
  XMMEnduserApi *customApi = [[XMMEnduserApi alloc] initWithApiKey:@"apikey"];
  
  
  NSDictionary *usedHeaders = customApi.restClient.session.configuration.HTTPAdditionalHeaders;
  
  XCTAssertNotNil(customApi);
  XCTAssertNotNil(customApi.restClient);
  XCTAssertTrue([usedHeaders isEqualToDictionary:httpHeaders]);
  XCTAssertTrue([customApi.systemLanguage isEqualToString:@"en"]);
  XCTAssertNotNil(customApi.offlineApi);
}

- (void)testCustomUserAgent {
  XMMEnduserApi *customApi = [[XMMEnduserApi alloc] initWithApiKey:@"apikey"];

  NSString *checkUserAgent = [NSString stringWithFormat:@"XamoomSDK iOS|aou|%@", apiVersion];
  
  NSString *userAgent = [customApi customUserAgentFrom:@"äöü"];
  
  XCTAssertTrue([checkUserAgent isEqualToString:userAgent]);
}

- (void)testInitWithApiKeyBaseUrlRestClient {
  XMMEnduserApi *customApi = [[XMMEnduserApi alloc] initWithRestClient:self.restClient];
  
  XCTAssertNotNil(customApi);
  XCTAssertNotNil(customApi.restClient);
  XCTAssertTrue([customApi.systemLanguage isEqualToString:@"en"]);
}

- (void)testNewSharedInstanceWithKey {
  XMMEnduserApi *customApi = [XMMEnduserApi sharedInstanceWithKey:@"apikey"];
  
  XCTAssertNotNil(customApi);
  XCTAssertTrue([customApi.systemLanguage isEqualToString:@"en"]);
  XCTAssertTrue([customApi.language isEqualToString:@"en"]);
}

- (void)testSharedInstance {
  XMMEnduserApi *customApi = [XMMEnduserApi sharedInstanceWithKey:@"apikey"];
  api = [XMMEnduserApi sharedInstance];
  
  XCTAssertNotNil(customApi);
  XCTAssertTrue([customApi.systemLanguage isEqualToString:@"en"]);
  XCTAssertTrue([customApi.language isEqualToString:@"en"]);
}

- (void)testSaveSharedInstance {
  XMMEnduserApi *customApi = [[XMMEnduserApi alloc] initWithApiKey:@"apikey"];
  [XMMEnduserApi saveSharedInstance:customApi];
  XMMEnduserApi *checkApi = [XMMEnduserApi sharedInstance];
  
  XCTAssertEqual(customApi, checkApi);
  XCTAssertTrue([checkApi.systemLanguage isEqualToString:@"en"]);
  XCTAssertTrue([checkApi.language isEqualToString:@"en"]);
}

- (void)testThatContentWithIdCallsFetchResourceWithParamaters {
  
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
  NSString *contentID = @"28d13571a9614cc19d624528ed7c2bb8";

  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentJson]], nil);
  };
  
  [[[self.mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [self.api contentWithID:contentID completion:^(XMMContent *content, NSError *error) {
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

- (void)testThatContentWithIdReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  NSString *contentID = @"28d13571a9614cc19d624528ed7c2bb8";
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[self.mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [self.api contentWithID:contentID completion:^(XMMContent *content, NSError *error) {
    XCTAssertNil(content);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)testThatContentWithIdCallsOfflineApi {
  XMMOfflineApi *mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  self.api.offlineApi = mockOfflineApi;
  
  NSString *contentID = @"28d13571a9614cc19d624528ed7c2bb8";

  self.api.offline = YES;
  
  [self.api contentWithID:contentID completion:nil];
  
  OCMVerify([mockOfflineApi contentWithID:[OCMArg isEqual:contentID]
                               completion:[OCMArg any]]);
  
}

- (void)testThatContentWithIdOptionsCallsFetchResourceWithParamaters {
  NSString *contentID = @"28d13571a9614cc19d624528ed7c2bb8";
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"preview":@"true",
                                                                                  @"public-only":@"true"}];
  
  OCMExpect([self.mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                                       id:[OCMArg isEqual:contentID]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [self.api contentWithID:contentID options:XMMContentOptionsPreview|XMMContentOptionsPrivate completion:^(XMMContent *content, NSError *error) {
  }];
  
  OCMVerifyAll(self.mockRestClient);
}

- (void)testThatContentWithIdOptionsReturnsContentViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  NSString *contentID = @"28d13571a9614cc19d624528ed7c2bb8";
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentPublicOnlyJson]], nil);
  };
  
  [[[self.mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [self.api contentWithID:contentID options:XMMContentOptionsPreview|XMMContentOptionsPrivate completion:^(XMMContent *content, NSError *error) {
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

- (void)testThatContentWithIdOptionsReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  NSString *contentID = @"28d13571a9614cc19d624528ed7c2bb8";
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[self.mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [self.api contentWithID:contentID options:XMMContentOptionsPreview|XMMContentOptionsPrivate completion:^(XMMContent *content, NSError *error) {
    XCTAssertNil(content);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentWithIdOptionsCallsOfflineApi {
  XMMOfflineApi *mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  self.api.offlineApi = mockOfflineApi;
  
  NSString *contentID = @"28d13571a9614cc19d624528ed7c2bb8";
  
  self.api.offline = YES;
  
  [self.api contentWithID:contentID options:0 completion:nil];
  
  OCMVerify([mockOfflineApi contentWithID:[OCMArg isEqual:contentID]
                               completion:[OCMArg any]]);
  
}

- (void)testThatContentWithLocationIdentifierCallsFetchResources {
  
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

- (void)testThatContentWithLocationIdentifierWithOptionsCallsFetchResources {
  
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"preview":@"true",
                                                                                  @"public-only":@"true",
                                                                                  @"filter[location-identifier]":@"7qpqr"}];
  NSString *qrMarker = @"7qpqr";
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentWithLocationIdentifier:qrMarker options:XMMContentOptionsPreview|XMMContentOptionsPrivate completion:^(XMMContent *content, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentWithLocationIdentifierReturnsContentViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  NSString *qrMarker = @"7qpqr";
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentPublicOnlyJson]], nil);
  };
  
  [[[self.mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [self.api contentWithLocationIdentifier:qrMarker completion:^(XMMContent *content, NSError *error) {
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

- (void)testThatContentWithLocationIdentifierReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  NSString *qrMarker = @"7qpqr";
  
  NSDictionary *checkDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"val1", @"key1", nil];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[self.mockRestClient stub] andDo:completion] fetchResource:[OCMArg any]
                                                    parameters:[OCMArg isEqual:checkDictionary]
                                                    completion:[OCMArg any]];
  
  [self.api contentWithLocationIdentifier:qrMarker completion:^(XMMContent *content, NSError *error) {
    XCTAssertNil(content);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentWithLocationIdentifierCallsOfflineApi {
  XMMOfflineApi *mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  self.api.offlineApi = mockOfflineApi;
  
  NSString *qr = @"1214";
  
  self.api.offline = YES;
  
  [self.api contentWithLocationIdentifier:qr options:0 completion:nil];
  
  OCMVerify([mockOfflineApi contentWithLocationIdentifier:[OCMArg isEqual:qr] completion:[OCMArg any]]);
}

- (void)testThatContentWithLocationIdentifierWithOptionsAndConditionCallsFetchResources {
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"preview":@"true",
                                                                                  @"public-only":@"true",
                                                                                  @"filter[location-identifier]":@"7qpqr",
                                                                                  @"condition[name]":@"myname",
                                                                                  @"condition[date]":@"2017-07-10T11:18:49Z",
                                                                                  @"condition[weekday]":@"3"}];
  
  NSString *qrMarker = @"7qpqr";
  NSString *dateString = @"2017-07-10T13:18:49+02:00";
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
  NSDate *date = [dateFormatter dateFromString:dateString];
  
  NSDictionary *options = @{@"name":@"myname",
                            @"date":date,
                            @"weekday":@3};
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentWithLocationIdentifier:qrMarker options:XMMContentOptionsPreview|XMMContentOptionsPrivate conditions:options completion:^(XMMContent *content, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentWithLocationIdentifierAndConditionCallReturnsContentViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  NSString *qrMarker = @"7qpqr";
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentPublicOnlyJson]], nil);
  };
  
  [[[self.mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  
  [self.api contentWithLocationIdentifier:qrMarker options:0 conditions:nil completion:^(XMMContent *content, NSError *error) {
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
  
  NSNumber *minor = @54222;
  NSNumber *major = @24265;
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[location-identifier]":@"24265|54222"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentWithBeaconMajor:major minor:minor completion:^(XMMContent *content, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentWithBeaconWithOptionsCallsFetchResources {
  
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"filter[location-identifier]":@"24265|54222",
                                                                                  @"preview":@"true",
                                                                                  @"public-only":@"true",
                                                                                  @"lang":@"en",
                                                                                  }];
  NSNumber *minor = @54222;
  NSNumber *major = @24265;
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentWithBeaconMajor:major minor:minor options:XMMContentOptionsPrivate|XMMContentOptionsPreview completion:^(XMMContent *content, NSError *error) {
    //
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentWithBeaconMajorReturnsContentViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  NSNumber *minor = @54222;
  NSNumber *major = @24265;
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentPublicOnlyJson]], nil);
  };
  
  [[[self.mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [self.api contentWithBeaconMajor:major minor:minor completion:^(XMMContent *content, NSError *error) {
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

- (void)testThatContentWithBeaconMajorReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  NSNumber *minor = @54222;
  NSNumber *major = @24265;
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[self.mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [self.api contentWithBeaconMajor:major minor:minor completion:^(XMMContent *content, NSError *error) {
    XCTAssertNil(content);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentWithBeaconAndConditionCallReturnsContentViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  NSNumber *minor = @54222;
  NSNumber *major = @24265;
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentPublicOnlyJson]], nil);
  };
  
  [[[self.mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [self.api contentWithBeaconMajor:major minor:minor options:0 conditions:nil completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentsWithLocationCallsFetchResources {
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                                                  @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                                                  @"page[size]":@"10"}];
  
  OCMExpect([self.mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [self.api contentsWithLocation:location pageSize:10 cursor:nil sort:XMMContentSortOptionsNone completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
  }];
  
  OCMVerifyAll(self.mockRestClient);
}

- (void)testThatContentsWithLocationCallsFetchResourcesWithCursorAndSortName {
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                                                  @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                                                  @"page[size]":@"10",
                                                                                  @"page[cursor]":@"1234",
                                                                                  @"sort":@"name"}];
  
  OCMExpect([self.mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [self.api contentsWithLocation:location pageSize:10 cursor:@"1234" sort:XMMContentSortOptionsTitle completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
  }];
  
  OCMVerifyAll(self.mockRestClient);
}

- (void)testThatContentsWithLocationCallsFetchResourcesWithCursorAndSortNameDesc {
  
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

- (void)testThatContentWithLocationCallsOfflineApi {
  
  XMMOfflineApi *mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  api.offlineApi = mockOfflineApi;
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:44.0 longitude:16.9];
  
  api.offline = YES;
  
  [api contentsWithLocation:location pageSize:0 cursor:nil sort:0 completion:nil];
  
  OCMVerify([mockOfflineApi contentsWithLocation:[OCMArg isEqual:location] pageSize:0 cursor:[OCMArg any] sort:0 completion:[OCMArg any]]);
}

- (void)testThatContentsWithLocationReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api contentsWithLocation:location pageSize:10 cursor:nil sort:0 completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNil(contents);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentWithTagsCallsFetchResources {
  
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
  
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[tags]":@"[\"tag1\",\"tag2\"]",
                                                                                  @"page[size]":@"10",
                                                                                  @"page[cursor]":@"1234",
                                                                                  @"sort":@"name"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentsWithTags:@[@"tag1", @"tag2"] pageSize:10 cursor:@"1234" sort:XMMContentSortOptionsTitle completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentsWithTagsReturnsContentHasMoreCursorViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
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

- (void)testThatContentsWithTagsReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  NSArray *tags = @[@"tag1", @"tag2"];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api contentsWithTags:tags pageSize:10 cursor:nil sort:0 completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNil(contents);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentWithTagsCallsOfflineApi {
  
  XMMOfflineApi *mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  api.offlineApi = mockOfflineApi;
  
  NSArray *tags = [[NSArray alloc] initWithObjects:@"tag1", nil];
  
  api.offline = YES;
  
  [api contentsWithTags:tags pageSize:0 cursor:nil sort:0 completion:nil];
  
  OCMVerify([mockOfflineApi contentsWithTags:[OCMArg isEqual:tags] pageSize:0 cursor:[OCMArg any] sort:0 completion:[OCMArg any]]);
}

- (void)testThatContentWithNameWithCursorSortCallsFetchResources {
  
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[name]":@"test",
                                                                                  @"page[size]":@"10",
                                                                                  @"page[cursor]":@"1234"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMContent class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api contentsWithName:@"test" pageSize:10 cursor:@"1234" sort:0 completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatContentsWithNameReturnsContentHasMoreCursorViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self contentWithName]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api contentsWithName:@"test" pageSize:20 cursor:nil sort:0 completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertFalse(hasMore);
    XCTAssertTrue([cursor isEqualToString:@""]);
    XCTAssertTrue(contents.count == 10);
    XMMContent *content = [contents objectAtIndex:0];
    XCTAssertTrue([content.title isEqualToString:@"Testseite"]);
    content = [contents objectAtIndex:9];
    XCTAssertTrue([content.title isEqualToString:@"Vimeo Test"]);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentsWithNameReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api contentsWithName:@"test" pageSize:20 cursor:nil sort:0 completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNil(contents);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatContentWithNameCallsOfflineApi {
  
  XMMOfflineApi *mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  api.offlineApi = mockOfflineApi;
  
  NSString *name = @"test";
  
  api.offline = YES;
  
  [api contentsWithName:name pageSize:0 cursor:nil sort:0 completion:nil];
  
  OCMVerify([mockOfflineApi contentsWithName:[OCMArg isEqual:name] pageSize:0 cursor:[OCMArg any] sort:0 completion:[OCMArg any]]);
}

- (void)testThatSpotWithIdReturnsSpotViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  NSString *spotID = @"5755996320301056|5744440375246848";
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self spotJson]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotWithID:spotID completion:^(XMMSpot *spot, NSError *error) {
    XCTAssertTrue([spot.ID isEqualToString:spotID]);
    XCTAssertTrue([spot.name isEqualToString:@"DO NOT TOUCH | APP | Spot 1"]);
    XCTAssertTrue([spot.spotDescription isEqualToString:@"Test"]);
    XCTAssertTrue([spot.image isEqualToString:@"https://storage.googleapis.com/xamoom-files-dev/mobile/956eb377e35a469c996ce3eacf1b6909.jpg?v=822c6f2dfd6f3c1c0451cc26d25351ef744060e29dfeba1073ade84c6c88c2f7c7d31e613448839112195baf9eacd6854776f0be16bf461d29461dfa6acac6b4"]);
    XCTAssertTrue(spot.category == 0);
    XCTAssertTrue(spot.latitude == 46.615067896711807);
    XCTAssertTrue(spot.longitude == 14.262270927429199);
    XCTAssertTrue([[spot.tags objectAtIndex:0] isEqualToString:@"Spot1"]);
    XCTAssertTrue([[spot.tags objectAtIndex:1] isEqualToString:@"tag1"]);
    XCTAssertTrue([[spot.tags objectAtIndex:2] isEqualToString:@"donottouchspot"]);
    XCTAssertTrue([spot.system.ID isEqualToString:@"5755996320301056"]);
    XCTAssertNil(spot.content);
    XCTAssertNil(spot.markers);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotWithIdReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  NSString *spotID = @"5755996320301056|5744440375246848";
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotWithID:spotID completion:^(XMMSpot *spot, NSError *error) {
    XCTAssertNil(spot);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotWithIdAndOptionsCallsFetchResources {
  
  NSString *spotID = @"5755996320301056|5744440375246848";
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en",
                                                      @"include_markers":@"true",
                                                      @"include_content":@"true",
                                                      @"filter[has-location]":@"true"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSpot class]]
                                       id:spotID
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api spotWithID:spotID options:XMMSpotOptionsWithLocation|XMMSpotOptionsIncludeMarker|XMMSpotOptionsIncludeContent completion:^(XMMSpot *spot, NSError *error) {
    //nothing
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSpotWithIdAndOptionsReturnsContentViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  NSString *spotID = @"5755996320301056|5744440375246848";
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self spotWithContentAndMarkerJson]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotWithID:spotID options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker completion:^(XMMSpot *spot, NSError *error) {
    XCTAssertTrue([spot.ID isEqualToString:spotID]);
    XCTAssertTrue([spot.name isEqualToString:@"DO NOT TOUCH | APP | Spot 1"]);
    XCTAssertTrue([spot.spotDescription isEqualToString:@"Test"]);
    XCTAssertTrue([spot.image isEqualToString:@"https://storage.googleapis.com/xamoom-files-dev/mobile/956eb377e35a469c996ce3eacf1b6909.jpg?v=822c6f2dfd6f3c1c0451cc26d25351ef744060e29dfeba1073ade84c6c88c2f7c7d31e613448839112195baf9eacd6854776f0be16bf461d29461dfa6acac6b4"]);
    XCTAssertTrue(spot.category == 0);
    XCTAssertTrue(spot.latitude == 46.615067896711807);
    XCTAssertTrue(spot.longitude == 14.262270927429199);
    XCTAssertTrue([[spot.tags objectAtIndex:0] isEqualToString:@"Spot1"]);
    XCTAssertTrue([[spot.tags objectAtIndex:1] isEqualToString:@"tag1"]);
    XCTAssertTrue([[spot.tags objectAtIndex:2] isEqualToString:@"donottouchspot"]);
    XCTAssertTrue([spot.system.ID isEqualToString:@"5755996320301056"]);
    XCTAssertTrue([spot.content.ID isEqualToString:@"e9c917086aca465eb454e38c0146428b"]);
    XMMMarker *marker = [spot.markers firstObject];
    XCTAssertTrue([marker.ID isEqualToString:@"7qpqr"]);
    XCTAssertTrue([marker.eddyStoneUrl isEqualToString:@"dev.xm.gl/2134hs"]);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}


- (void)testThatSpotWithIdCallsFetchResources {
  
  NSString *spotID = @"5755996320301056|5744440375246848";
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSpot class]]
                                       id:spotID
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api spotWithID:spotID completion:^(XMMSpot *spot, NSError *error) {
    //nothing
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSpotWithIdCallsOfflineApi {
  
  XMMOfflineApi *mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  api.offlineApi = mockOfflineApi;
  
  NSString *spotId = @"test";
  
  api.offline = YES;
  
  [api spotWithID:spotId options:0 completion:nil];
  
  OCMVerify([mockOfflineApi spotWithID:[OCMArg isEqual:spotId] completion:[OCMArg any]]);
}

- (void)testThatSpotWithLocationRadiusCallsFetchResources {
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en",
                                                      @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                      @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                      @"filter[radius]":@"100"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSpot class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api spotsWithLocation:location radius:100 options:XMMSpotOptionsNone sort:XMMSpotSortOptionsNone completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSpotWithLocationRadiusOptionCallsFetchResources {
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102000001 longitude:14.2628843];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en",
                                                      @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                      @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                      @"filter[radius]":@"100",
                                                      @"include_markers":@"true",
                                                      @"include_content":@"true",
                                                      @"filter[has-location]":@"true",
                                                      @"sort":@"-distance"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSpot class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api spotsWithLocation:location radius:100 options:XMMSpotOptionsIncludeMarker|XMMSpotOptionsIncludeContent|XMMSpotOptionsWithLocation sort:XMMSpotSortOptionsDistanceDesc completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSpotsWithLocationReturnsSpotsViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self spotLocation]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotsWithLocation:location radius:100 options:0 sort:XMMSpotSortOptionsNone completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertTrue(spots.count == 7);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotsWithLocationReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotsWithLocation:location radius:100 options:0 sort:XMMSpotSortOptionsNone completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNil(spots);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotsWithLocationCallsOfflineApi {
  
  id mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  api.offlineApi = mockOfflineApi;
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:44.0 longitude:16.0];
  
  api.offline = YES;
  
  [api spotsWithLocation:location radius:0 options:0 sort:0 completion:nil];
  
  OCMVerify([mockOfflineApi spotsWithLocation:location radius:0 pageSize:0 cursor:[OCMArg any] completion:[OCMArg any]]);
}

- (void)testThatSpotWithLocationRadiusOptionPageSizeCursorCallsFetchResource {
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102000001 longitude:14.2628843];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en",
                                                      @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                      @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                      @"filter[radius]":@"100",
                                                      @"include_markers":@"true",
                                                      @"include_content":@"true",
                                                      @"page[size]":@"20",
                                                      @"page[cursor]":@"2",
                                                      @"filter[has-location]":@"true"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSpot class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api spotsWithLocation:location radius:100 options:XMMSpotOptionsIncludeMarker|XMMSpotOptionsIncludeContent|XMMSpotOptionsWithLocation sort:XMMSpotSortOptionsNone pageSize:20 cursor:@"2" completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    //
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSpotsWithLocationPageSizeCursorReturnsSpotsViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self spotLocation]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotsWithLocation:location radius:10 options:0 sort:XMMSpotSortOptionsNone pageSize:10 cursor:nil completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertTrue(spots.count == 7);
    XCTAssertTrue([cursor isEqualToString:@""]);
    XCTAssertFalse(hasMore);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotsWithLocationPageSizeCursorReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotsWithLocation:location radius:10 options:0 sort:XMMSpotSortOptionsNone pageSize:10 cursor:nil completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNil(spots);
    XCTAssertNotNil(error);
    XCTAssertFalse(hasMore);
    XCTAssertNil(cursor);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotsWithTagsOptionSortCallsFetchResource {
  
  NSArray *tags = @[@"tag1", @"tag2"];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en",
                                                      @"filter[tags]":@"[\"tag1\",\"tag2\"]",
                                                      @"include_markers":@"true",
                                                      @"include_content":@"true",
                                                      @"page[size]":@"100",
                                                      @"filter[has-location]":@"true",
                                                      @"sort":@"name"}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSpot class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api spotsWithTags:tags options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker|XMMSpotOptionsWithLocation sort:XMMSpotSortOptionsName completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    //
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSpotsWithTagsOptionsReturnsSpotsViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  NSArray *tags = @[@"tag1", @"tag2"];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self spotLocation]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotsWithTags:tags options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker sort:XMMSpotSortOptionsNone completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertTrue(spots.count == 7);
    XCTAssertTrue([cursor isEqualToString:@""]);
    XCTAssertFalse(hasMore);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotsWithTagsOptionsReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  NSArray *tags = @[@"tag1", @"tag2"];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotsWithTags:tags options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker sort:XMMSpotSortOptionsNone completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNil(spots);
    XCTAssertNotNil(error);
    XCTAssertFalse(hasMore);
    XCTAssertNil(cursor);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotsWithTagsOptionPageSizeCursorCallsFetchResource {
  
  NSArray *tags = @[@"tag1", @"tag2"];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en",
                                                      @"filter[tags]":@"[\"tag1\",\"tag2\"]",
                                                      @"include_markers":@"true",
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

- (void)testThatSpotsWithTagsCallsOfflineApi {
  
  id mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  api.offlineApi = mockOfflineApi;
  
  NSArray *tags = [[NSArray alloc] initWithObjects:@"tag1", nil];
  
  api.offline = YES;
  
  [api spotsWithTags:tags options:0 sort:0 completion:nil];
  
  OCMVerify([mockOfflineApi spotsWithTags:[OCMArg isEqual:tags] pageSize:100 cursor:[OCMArg any] sort:0 completion:[OCMArg any]]);
}

- (void)testThatSpotsWithNameCallsFetchResource {
  
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":@"en",
                                                      @"filter[name]":@"do not touch",
                                                      @"page[size]":@"20",
                                                      @"page[cursor]":@"1",}];
  
  OCMExpect([mockRestClient fetchResource:[OCMArg isEqual:[XMMSpot class]]
                               parameters:[OCMArg isEqual:params]
                               completion:[OCMArg any]]);
  
  [api spotsWithName:@"do not touch" pageSize:20 cursor:@"1" options:0 sort:0 completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    //
  }];
  
  OCMVerifyAll(mockRestClient);
}

- (void)testThatSpotsWithNameReturnsSpotsViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self spotWithName]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotsWithName:@"do not touch" pageSize:20 cursor:nil options:0 sort:0 completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertEqual(spots.count, 1);
    XCTAssertFalse(hasMore);
    XCTAssertTrue([cursor isEqualToString:@""]);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotsWithNameReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api spotsWithName:@"do not touch" pageSize:20 cursor:nil options:0 sort:0 completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertNil(spots);
    XCTAssertNotNil(error);
    XCTAssertFalse(hasMore);
    XCTAssertNil(cursor);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSpotsWithNameCallsOfflineApi {
  
  id mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  api.offlineApi = mockOfflineApi;
  
  NSString *name = @"name";
  
  api.offline = YES;
  
  [api spotsWithName:name pageSize:0 cursor:[OCMArg any] options:0 sort:0 completion:nil];
  
  OCMVerify([mockOfflineApi spotsWithName:[OCMArg isEqual:name] pageSize:0 cursor:[OCMArg any] sort:0 completion:[OCMArg any]]);
}

- (void)testThatSystemCallsFetchResource {
  
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
  
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self system]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api systemWithCompletion:^(XMMSystem *system, NSError *error) {
    XCTAssertTrue([system.url isEqualToString:@"http://testpavol.at"]);
    XCTAssertTrue([system.name isEqualToString:@"Dev xamoom testing UMGEBUNG"]);
    XCTAssertNotNil(system.menu);
    XCTAssertNotNil(system.style);
    XCTAssertNotNil(system.setting);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSystemReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  

  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api systemWithCompletion:^(XMMSystem *system, NSError *error) {
    XCTAssertNil(system);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatSystemCallsOfflineApi {
  
  XMMOfflineApi *mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  api.offlineApi = mockOfflineApi;
  
  api.offline = YES;
  
  [api systemWithCompletion:nil];
  
  OCMVerify([mockOfflineApi systemWithCompletion:[OCMArg any]]);
}

- (void)testThatSystemSettingsCallsFetchResource {
  
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

- (void)testThatSystemSettingsReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api systemSettingsWithID:@"12345" completion:^(XMMSystemSettings *settings, NSError *error) {
    XCTAssertNil(settings);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatStyleWithIDCallsFetchResource {
  
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

- (void)testThatSystemSettingsCallsOfflineApi {
  
  XMMOfflineApi *mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  api.offlineApi = mockOfflineApi;
  
  NSString *systemId = @"11";
  
  api.offline = YES;
  
  [api systemSettingsWithID:systemId completion:nil];
  
  OCMVerify([mockOfflineApi systemSettingsWithID:[OCMArg isEqual:systemId] completion:[OCMArg any]]);
}

- (void)testThatStyleWithIDReturnsViaCallback {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  
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

- (void)testThatStyleWithIDReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api styleWithID:@"12345" completion:^(XMMStyle *style, NSError *error) {
    XCTAssertNil(style);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatStyleCallsOfflineApi {
  
  XMMOfflineApi *mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  api.offlineApi = mockOfflineApi;
  
  NSString *systemId = @"11";
  
  api.offline = YES;
  
  [api styleWithID:systemId completion:nil];
  
  OCMVerify([mockOfflineApi styleWithID:[OCMArg isEqual:systemId] completion:[OCMArg any]]);
}

- (void)testThatMenuWithIDCallsFetchResource {
  
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
  
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock([[JSONAPI alloc] initWithDictionary:[self menu]], nil);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api menuWithID:@"12345" completion:^(XMMMenu *menu, NSError *error) {
    XCTAssertNotNil(menu);
    XCTAssertTrue(menu.items.count == 3);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatMenuWithIDReturnsError {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(JSONAPI *result, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 5];
    passedBlock(nil, [[NSError alloc] init]);
  };
  
  [[[mockRestClient stub] andDo:completion] fetchResource:[OCMArg any] id:[OCMArg any] parameters:[OCMArg any] completion:[OCMArg any]];
  
  [api menuWithID:@"12345" completion:^(XMMMenu *menu, NSError *error) {
    XCTAssertNil(menu);
    XCTAssertNotNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testThatMenuCallsOfflineApi {
  
  XMMOfflineApi *mockOfflineApi = OCMClassMock([XMMOfflineApi class]);
  api.offlineApi = mockOfflineApi;
  
  NSString *systemId = @"11";
  
  api.offline = YES;
  
  [api menuWithID:systemId completion:nil];
  
  OCMVerify([mockOfflineApi menuWithID:[OCMArg isEqual:systemId] completion:[OCMArg any]]);
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

- (NSDictionary *)contentWithName {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"contentWithName" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  return json;
}

- (NSDictionary *)spotJson {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"spot" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  return json;
}

- (NSDictionary *)spotWithContentAndMarkerJson {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"spotWithContentAndMarker" ofType:@"json"];
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

- (NSDictionary *)spotWithName {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"spotWithName" ofType:@"json"];
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
