//
//  Tests.m
//  Tests
//
//  Created by Raphael Seher on 23.11.15.
//  Copyright © 2015 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <xamoom-ios-sdk/XMMEnduserApi.h>

@interface Tests : XCTestCase

@property XMMEnduserApi *api;

@end

@implementation Tests

- (void)setUp {
  [super setUp];
  self.api = [XMMEnduserApi sharedInstance];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testThatSharedInstanceReturnsXMMEnduserApi {
  XCTAssertNotNil([XMMEnduserApi sharedInstance]);
}

- (void)testThatSharedInstanceReturnsSameInstance {
  XMMEnduserApi *api = [XMMEnduserApi sharedInstance];
  XCTAssertEqualObjects(api, [XMMEnduserApi sharedInstance]);
}

- (void)testThatSharedInstanceIsXMMEnduserApi {
  XCTAssertTrue([XMMEnduserApi sharedInstance].class == [XMMEnduserApi class]);
}

- (void)testThatInitReturnsXMMEnduserApi {
  XMMEnduserApi *api = [[XMMEnduserApi sharedInstance] init];
  XCTAssertNotNil(api);
  XCTAssertTrue(api.class == [XMMEnduserApi class]);
  XCTAssertNotNil([XMMEnduserApi sharedInstance].systemLanguage);
  XCTAssertTrue([[XMMEnduserApi sharedInstance].qrCodeViewControllerCancelButtonTitle isEqualToString:@"Cancel"]);
  XCTAssertNotNil([XMMEnduserApi sharedInstance].objectManager);
}

- (void)testThatInitSetsProperties {
  XCTAssertNotNil([XMMEnduserApi sharedInstance].systemLanguage);
  XCTAssertTrue([[XMMEnduserApi sharedInstance].qrCodeViewControllerCancelButtonTitle isEqualToString:@"Cancel"]);
}

- (void)testThatAPIKeyGetsSet {
  NSString *apikey = @"Hellyeah";
  [self.api setApiKey:apikey];
  
  NSString *checkApikey = [self.api.objectManager.defaultHeaders valueForKey:@"Authorization"];
  XCTAssertEqual(apikey, checkApikey);
}

#pragma mark - contentWithId

- (void)testThatContentWithContentIdCallsApiPostWithPath {
  id mockedApi = OCMPartialMock([XMMEnduserApi sharedInstance]);
  
  [[[mockedApi stub] andDo:^(NSInvocation *invocation) {
    void (^stubResponse)(XMMContentById *result);
    [invocation getArgument:&stubResponse atIndex:5];
    XMMContentById *content = [[XMMContentById alloc] init];
    content.systemName = @"Hello";
    stubResponse(content);
  }] apiPostWithPath:[OCMArg any] andDescriptor:[OCMArg any] andParams:[OCMArg any] completion:[OCMArg any] error:[OCMArg any]];
  
  [mockedApi contentWithContentId:@"" includeStyle:NO includeMenu:NO withLanguage:nil full:NO completion:^(XMMContentById *result) {
    XCTAssertEqual(result.systemName, @"Hello");
  } error:nil];
  
  OCMVerify([mockedApi apiPostWithPath:[OCMArg isEqual:@"xamoomEndUserApi/v1/get_content_by_content_id_full"] andDescriptor:[OCMArg any] andParams:[OCMArg any] completion:[OCMArg any] error:[OCMArg any]]);
}

- (void)testThatContentWIthContentIdMakesTheRightParameters {

}

/*
 - (void)test {
 id mockedApi = OCMClassMock([XMMEnduserApi class]);
 
 [[[mockedApi stub] andDo:^(NSInvocation *invocation) {
 void (^stubResponse)(XMMContentById *result);
 
 [invocation getArgument:&stubResponse atIndex:7];
 
 XMMContentById *content = [[XMMContentById alloc] init];
 content.systemName = @"Hello";
 stubResponse(content);
 }] contentWithContentId:@"" includeStyle:NO includeMenu:NO withLanguage:nil full:NO completion:[OCMArg any] error:nil];
 
 [mockedApi contentWithContentId:@"" includeStyle:NO includeMenu:NO withLanguage:nil full:NO
 completion:^(XMMContentById *result) {
 XCTAssertEqual(result.systemName, @"Hello");
 } error:nil];
 }
 */

#pragma mark - Systemlanguage

- (void)testThatSystemLanguageGetsSet {
  NSLog(@"Test Suite - testSystemLanguage");
  
  XCTAssertNotNil([XMMEnduserApi sharedInstance].systemLanguage, @"api.systemLanguage should not be nil");
}

@end
