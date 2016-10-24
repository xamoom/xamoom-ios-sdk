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
  NSURLSessionDownloadTask *mockedTask = OCMClassMock([NSURLSessionDownloadTask class]);
  
  OCMStub([mockedSession downloadTaskWithRequest:[OCMArg any]]).andReturn(mockedTask);

  [self.downloadManager downloadFileFromUrl:[NSURL URLWithString:@"file.jp"] completion:^(NSData *data, NSError *error) {
    //
  }];
  
  OCMVerify([mockedTask resume]);
  XCTAssertEqual(self.downloadManager.currentDownloads.count, 1);
}

@end
