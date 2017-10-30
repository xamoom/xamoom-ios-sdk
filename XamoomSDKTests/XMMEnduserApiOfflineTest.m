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
#import "NSDateFormatter+ISODate.h"

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
  
  [self.enduserApi contentWithID:contentId completion:nil];
  
  OCMVerify([self.mockedOfflineApi contentWithID:[OCMArg isEqual:contentId] completion:[OCMArg any]]);
}

- (void)testContentWithIDOptionsCallsOfflineApi {
  NSString *contentId = @"1";
  
  [self.enduserApi contentWithID:contentId options:XMMContentOptionsNone completion:nil];
  
  OCMVerify([self.mockedOfflineApi contentWithID:[OCMArg isEqual:contentId] completion:[OCMArg any]]);
}

- (void)testContentWithLocationIdentifierOptionsCallsOfflineApi {
  NSString *locId = @"1";
  
  [self.enduserApi contentWithLocationIdentifier:locId options:XMMContentOptionsNone completion:nil];
  
  OCMVerify([self.mockedOfflineApi contentWithLocationIdentifier:[OCMArg isEqual:locId] completion:[OCMArg any]]);
}


- (void)testContentsFromDateToDateCallsOfflineApi {
  NSDate *date = [[NSDateFormatter ISO8601Formatter] dateFromString:@"2017-10-20T07:02:01Z"];
  
  [self.enduserApi contentsFrom:date to:date relatedSpot:nil pageSize:10 cursor:@"" sort:0
                     completion:nil];
  
  OCMVerify([self.mockedOfflineApi
             contentsFrom:[OCMArg isEqual:date]
             to:[OCMArg isEqual:date]
             pageSize:10
             cursor:[OCMArg isEqual:@""]
             sort:0
             filter:[OCMArg isNotNil]
             completion:[OCMArg isNil]]);
}

@end
