//
//  XMMEnduserApiOfflineTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 13/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "XMMEnduserApi.h"
#import "XMMOfflineApi.h"

@interface XMMEnduserApiOfflineTest : XCTestCase

@property XMMEnduserApi *enduserApi;
@property XMMOfflineApi *mockedOfflineApi;
@property float timeout;

@end

@implementation XMMEnduserApiOfflineTest

- (void)setUp {
  [super setUp];
  self.mockedOfflineApi = OCMClassMock([XMMOfflineApi class]);
  self.enduserApi = [[XMMEnduserApi alloc] initWithApiKey:@""];
  self.enduserApi.offlineApi = self.mockedOfflineApi;
  self.enduserApi.offline = YES;
  self.timeout = 1.0;
}

- (void)tearDown {
  [super tearDown];
}

- (void)testContentWithIDCallsOfflineApi {
  NSString *contentId = @"1";
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];

  [self.enduserApi contentWithID:contentId completion:^(XMMContent *content, NSError *error) {
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
  
  OCMVerify([self.mockedOfflineApi contentWithID:[OCMArg isEqual:contentId] completion:[OCMArg isNotNil]]);
}

@end
