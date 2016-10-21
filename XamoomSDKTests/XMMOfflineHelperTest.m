//
//  XMMOfflineHelperTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 21/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "XMMOfflineHelper.h"

@interface XMMOfflineHelperTest : XCTestCase

@property XMMOfflineHelper *offlineHelper;
@property XMMEnduserApi *mockApi;
@property XMMOfflineStorageManager *mockedManager;
@property NSManagedObjectContext *mockedContext;

@end

@implementation XMMOfflineHelperTest

- (void)setUp {
  [super setUp];
  self.mockApi = OCMClassMock([XMMEnduserApi class]);
  self.mockedManager = OCMPartialMock([[XMMOfflineStorageManager alloc] init]);
  self.mockedContext = OCMClassMock([NSManagedObjectContext class]);
  self.mockedManager.managedObjectContext = self.mockedContext;
  
  self.offlineHelper = [[XMMOfflineHelper alloc] initWithApi:self.mockApi];
  self.offlineHelper.storeManager = self.mockedManager;
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testInit {
  XMMOfflineHelper *offlineHelper = [[XMMOfflineHelper alloc] initWithApi:self.mockApi];
  
  XCTAssertNotNil(offlineHelper);
  XCTAssertEqual(offlineHelper.api, self.mockApi);
}

- (void)testDownloadWithTags {
  OCMStub([self.mockApi spotsWithTags:[OCMArg any] pageSize:100 cursor:[OCMArg any] options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker sort:0 completion:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
    void (^passedBlock)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 7];
    NSString *cursor;
    [invocation getArgument: &cursor atIndex:4];
    
    XMMSpot *spot = [[XMMSpot alloc] init];
    spot.ID = @"1";
    
    if ([cursor isEqualToString:@"1"]) {
      passedBlock(@[spot], NO, nil, nil);
    } else {
      passedBlock(@[spot], YES, @"1", nil);
    }
  });
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineHelper downloadAndSaveWithTags:@[@"tag1"] completion:^(NSArray *spots, NSError *error) {
    XCTAssertEqual(spots.count, 2);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)testDeleteSavedWithTagsSameTags {
  XMMSpot *spot1 = [[XMMSpot alloc] init];
  spot1.ID = @"1";
  spot1.tags = @[@"tag1"];
  
  XMMSpot *spot2 = [[XMMSpot alloc] init];
  spot2.ID = @"2";
  spot2.tags = @[@"tag1", @"tag2"];
  
  NSArray *spots = @[spot1, spot2];
  
  OCMStub([self.mockedManager fetchAll:[OCMArg any]]).andReturn(spots);
  OCMReject([self.mockedContext deleteObject:[OCMArg isEqual:spot2]]);
  
  NSError *error = [self.offlineHelper deleteSavedDataWithTags:@[@"tag1"] ignoreTags:@[@"tag2"]];
  
  OCMVerify([self.mockedContext deleteObject:[OCMArg isEqual:spot1]]);
}

- (void)testDeleteSavedWithTagsSameContent {
  
}



@end
