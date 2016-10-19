//
//  XMMOfflineDownloadManagerTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 19/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "XMMOfflineDownloadManager.h"

@interface XMMOfflineDownloadManagerTest : XCTestCase

@property XMMOfflineDownloadManager *downloadManager;

@end

@implementation XMMOfflineDownloadManagerTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  self.downloadManager = [[XMMOfflineDownloadManager alloc] init];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testDownloadFileFromUrl {
  NSURLSession *mockedSession = OCMClassMock([NSURLSession class]);
  self.downloadManager.session = mockedSession;
  
  OCMStub([mockedSession downloadTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
    void(^passedBlock)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error);
    [invocation getArgument:&passedBlock atIndex:3];
    passedBlock([NSURL URLWithString:@"www.xamoom.com"], nil, nil);
  }).andReturn([[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:@"www.xamoom.com"]]);
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.downloadManager downloadFileFromUrl:[NSURL URLWithString:@"www.xamoom.com"] completion:^(NSData *data, NSError *error) {
    XCTAssertEqual(self.downloadManager.currentDownloads.count, 0);
    [expectation fulfill];
  }];
  XCTAssertEqual(self.downloadManager.currentDownloads.count, 1);

  [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
