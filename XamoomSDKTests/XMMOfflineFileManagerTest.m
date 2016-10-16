//
//  XMMOfflineFileManagerTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 14/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMOfflineFileManager.h"

@interface XMMOfflineFileManagerTest : XCTestCase

@property NSString *fileName;

@property XMMOfflineFileManager *offlineFileManager;

@end

@implementation XMMOfflineFileManagerTest

- (void)setUp {
  [super setUp];
  self.offlineFileManager = [[XMMOfflineFileManager alloc] init];
  self.fileName = @"https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/170px-Apple_logo_black.svg.png";
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager removeItemAtPath:[[XMMOfflineFileManager urlForSavedData:self.fileName] path] error:nil];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testSaveFileFromUrl {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.offlineFileManager saveFileFromUrl:self.fileName completion:^(NSData *data, NSError *error) {
    XCTAssertNotNil(data);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:10.0 handler:nil];
  
  NSError *error;
  NSData *data = [self.offlineFileManager savedDataFromUrl:self.fileName error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(data);
}

- (void)testImageFromSavedFile {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [self.offlineFileManager saveFileFromUrl:self.fileName completion:^(NSData *data, NSError *error) {
    XCTAssertNotNil(data);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:4.0 handler:nil];
  
  NSError *error;
  UIImage *image = [self.offlineFileManager savedImageFromUrl:self.fileName error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(image);
}
@end
