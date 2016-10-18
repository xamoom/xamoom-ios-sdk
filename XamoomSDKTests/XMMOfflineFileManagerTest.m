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
  [fileManager removeItemAtPath:[[self.offlineFileManager urlForSavedData:self.fileName] path] error:nil];
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

- (void)testFilePathForSavedObjectWithCaching {
  NSString *urlString = @"https://storage.googleapis.com/xamoom-files-dev/mobile/e7db53fe77734ff9ba31de6cf8a92844.jpg?v=6716a9ab9440d1739402bf97fd09cd1da5427aeb64ae53a04ce748a40de06da6c2eac1fa63b8dc310db8abfdf10c21d7f81b2e133e2aeaaa5b23ea56ca2f6f5b";
  NSString *checkUrl = @"file:///Users/raphaelseher/Library/Developer/CoreSimulator/Devices/CCE24606-63B2-4DAF-97F1-B8BD53FEFED4/data/Containers/Data/Application/250913D2-09B2-49EB-A838-FCF8F08665DD/Documents/3a312f3fa76bae7e1dc77a55d813d658.jpg";
  
  NSURL *url = [self.offlineFileManager urlForSavedData:urlString];
    
  XCTAssertTrue([[[url lastPathComponent] lowercaseString] isEqualToString:[[[NSURL URLWithString:checkUrl] lastPathComponent] lowercaseString]]);
}

@end
