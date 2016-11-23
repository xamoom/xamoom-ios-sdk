//
//  XMMOfflineHelperTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 21/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "XMMCDSpot.h"
#import "XMMOfflineStorageTagModule.h"

@interface XMMOfflineStorageTagModuleTest : XCTestCase

@property XMMOfflineStorageTagModule *offlineHelper;
@property XMMEnduserApi *mockApi;
@property XMMOfflineStorageManager *mockedManager;
@property NSManagedObjectContext *mockedContext;

@end

@implementation XMMOfflineStorageTagModuleTest

- (void)setUp {
  [super setUp];
  self.mockApi = OCMClassMock([XMMEnduserApi class]);
  self.mockedManager = OCMPartialMock([[XMMOfflineStorageManager alloc] init]);
  self.mockedContext = OCMClassMock([NSManagedObjectContext class]);
  self.mockedManager.managedObjectContext = self.mockedContext;
  
  self.offlineHelper = [[XMMOfflineStorageTagModule alloc] initWithApi:self.mockApi];
  self.offlineHelper.storeManager = self.mockedManager;
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testInit {
  XMMOfflineStorageTagModule *offlineHelper = [[XMMOfflineStorageTagModule alloc] initWithApi:self.mockApi];
  
  XCTAssertNotNil(offlineHelper);
  XCTAssertEqual(offlineHelper.api, self.mockApi);
}

- (void)testDownloadWithTags {
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"2";
  
  OCMStub([self.mockApi spotsWithTags:[OCMArg any] pageSize:100 cursor:[OCMArg any] options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker sort:0 completion:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
    void (^passedBlock)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 7];
    NSString *cursor;
    [invocation getArgument: &cursor atIndex:4];
    
    XMMSpot *spot = [[XMMSpot alloc] init];
    spot.ID = @"1";
    spot.content = content;
    
    if ([cursor isEqualToString:@"1"]) {
      passedBlock(@[spot], NO, nil, nil);
    } else {
      passedBlock(@[spot], YES, @"1", nil);
    }
  });
  
  OCMStub([self.mockApi contentWithID:[OCMArg any] completion:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
    void (^passedBlock)(XMMContent *contents, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 3];
    
    passedBlock(content, nil);
  });
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineHelper downloadAndSaveWithTags:@[@"tag1"] completion:^(NSArray *spots, NSError *error) {
    XCTAssertEqual(spots.count, 2);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)testDeleteSavedWithTagsSameTags {
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"3";
  
  XMMContent *content2 = [[XMMContent alloc] init];
  content2.ID = @"4";
  
  XMMSpot *spot1 = [[XMMSpot alloc] init];
  spot1.ID = @"1";
  spot1.tags = @[@"tag1"];
  spot1.content = content;
  
  XMMSpot *spot2 = [[XMMSpot alloc] init];
  spot2.ID = @"2";
  spot2.tags = @[@"tag1", @"tag2"];
  spot2.content = content2;
  
  NSArray *spots = @[[XMMCDSpot insertNewObjectFrom:spot1], [XMMCDSpot insertNewObjectFrom:spot2]];
  
  OCMStub([self.mockedManager fetchAll:[OCMArg any]]).andReturn(spots);
  OCMReject([self.mockedContext deleteObject:[OCMArg isEqual:spots[1]]]);
  
  [self.offlineHelper addOfflineTag:@"tag1"];
  [self.offlineHelper addOfflineTag:@"tag2"];
  
  NSError *error = [self.offlineHelper deleteSavedDataWithTags:@[@"tag1"]];
  XCTAssertNil(error);
  OCMVerify([self.mockedManager deleteEntity:[OCMArg any] ID:[OCMArg isEqual:@"1"]]);
}

- (void)testDeleteSavedDataWithTagsSameContent {
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"3";
  
  XMMSpot *spot1 = [[XMMSpot alloc] init];
  spot1.ID = @"1";
  spot1.tags = @[@"tag1"];
  spot1.content = content;
  
  XMMSpot *spot2 = [[XMMSpot alloc] init];
  spot2.ID = @"2";
  spot2.tags = @[@"tag1", @"tag2"];
  spot2.content = content;
  
  [self.offlineHelper addOfflineTag:@"tag1"];
  [self.offlineHelper addOfflineTag:@"tag2"];
  
  NSArray *spots = @[[XMMCDSpot insertNewObjectFrom:spot1], [XMMCDSpot insertNewObjectFrom:spot2]];
  
  OCMStub([self.mockedManager fetchAll:[OCMArg any]]).andReturn(spots);
  OCMStub([self.mockedManager fetch:[OCMArg any] predicate:[OCMArg any]]).andReturn(spots);
  
  XMMCDSpot *savedSpot = spots[0];
  OCMReject([self.mockedContext deleteObject:(NSManagedObject *)savedSpot.content]);
  
  NSError *error = [self.offlineHelper deleteSavedDataWithTags:@[@"tag1"]];
  XCTAssertNil(error);
}

- (void)testDeleteSavedDataWtihTagsDifferentContent {
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"3";
  
  XMMContent *content2 = [[XMMContent alloc] init];
  content2.ID = @"4";
  
  XMMSpot *spot1 = [[XMMSpot alloc] init];
  spot1.ID = @"1";
  spot1.tags = @[@"tag1"];
  spot1.content = content;
  
  XMMSpot *spot2 = [[XMMSpot alloc] init];
  spot2.ID = @"2";
  spot2.tags = @[@"tag1", @"tag2"];
  spot2.content = content2;
  
  [self.offlineHelper addOfflineTag:@"tag1"];
  [self.offlineHelper addOfflineTag:@"tag2"];
  
  NSArray *spots = @[[XMMCDSpot insertNewObjectFrom:spot1], [XMMCDSpot insertNewObjectFrom:spot2]];
  
  NSArray *spotsWithContent1 = @[spots[0]];
  OCMStub([self.mockedManager fetchAll:[OCMArg any]]).andReturn(spots);
  OCMStub([self.mockedManager fetch:[OCMArg any] predicate:[OCMArg any]]).andReturn(spotsWithContent1);
  
  NSError *error = [self.offlineHelper deleteSavedDataWithTags:@[@"tag1"]];
  XCTAssertNil(error);
  OCMVerify([self.mockedManager deleteEntity:[OCMArg any] ID:[OCMArg isEqual:@"3"]]);
}

@end
