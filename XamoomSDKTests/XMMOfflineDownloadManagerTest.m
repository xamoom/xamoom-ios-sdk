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

  [self.downloadManager downloadFileFromUrl:[NSURL URLWithString:@"file.jp"] completion:^(NSString *url, NSData *data, NSError *error) {
    //
  }];
  
  XCTAssertEqual(self.downloadManager.currentDownloads.count, 1);
}

- (void)testStartDownloads {
  NSURLSession *mockedSession = OCMClassMock([NSURLSession class]);
  self.downloadManager.session = mockedSession;
  self.downloadManager.startDownloadAutomatically = NO;
  
  NSURLSessionDownloadTask *mockedTask = OCMClassMock([NSURLSessionDownloadTask class]);
  OCMStub([mockedSession downloadTaskWithRequest:[OCMArg any]]).andReturn(mockedTask);
  NSURLRequest *mockedUrlRequest = OCMClassMock([NSURLRequest class]);
  OCMStub([mockedTask originalRequest]).andReturn(mockedUrlRequest);
  NSURL *urlForMock = [NSURL URLWithString:@"file.jpg"];
  OCMStub([mockedUrlRequest URL]).andReturn(urlForMock);
  
  [self.downloadManager downloadFileFromUrl:urlForMock completion:^(NSString *url, NSData *data, NSError *error) {
    XCTAssertEqual(urlForMock.absoluteString, url);
  }];
  
  XCTAssertEqual(self.downloadManager.currentDownloads.count, 1);
  
  [self.downloadManager startDownloads];
  
  [self.downloadManager URLSession:mockedSession
                      downloadTask:mockedTask
         didFinishDownloadingToURL:urlForMock];
  
  XCTAssertEqual(self.downloadManager.currentDownloads.count, 0);
  OCMVerify([mockedTask resume]);
}

@end
