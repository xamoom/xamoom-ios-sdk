//
//  XMMOfflineStorageManagerTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 29/09/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XMMOfflineStorageManager.h"
#import "XMMCDSystemSettings.h"
#import "NSString+MD5.h"

@interface XMMOfflineStorageManagerTests : XCTestCase

@property XMMOfflineStorageManager *storeManager;
@property id mockedContext;

@end

@implementation XMMOfflineStorageManagerTests

- (void)setUp {
  [super setUp];
  self.storeManager = [[XMMOfflineStorageManager alloc] init];
  self.mockedContext = OCMClassMock([NSManagedObjectContext class]);
  self.storeManager.managedObjectContext = self.mockedContext;
}

- (void)tearDown {
  [super tearDown];
}

- (void)testInit {
  XMMOfflineStorageManager *manager = [[XMMOfflineStorageManager alloc] init];
  
  XCTAssertNotNil(manager);
  XCTAssertNotNil(manager.managedObjectContext);
}

- (void)testSave {
  NSError *error = [self.storeManager save];
  
  XCTAssertNil(error);
  OCMVerify([self.mockedContext save:[OCMArg anyObjectRef]]);
}

- (void)testFetchEntityTypeJsonID {
  NSFetchRequest *checkRequest = [NSFetchRequest fetchRequestWithEntityName:[XMMCDSystemSettings coreDataEntityName]];
  checkRequest.predicate = [NSPredicate predicateWithFormat:@"jsonID = %@", @"1234"];
  
  [self.storeManager fetch:[XMMCDSystemSettings coreDataEntityName] jsonID:@"1234"];
  
  OCMVerify([self.mockedContext executeFetchRequest:[OCMArg isEqual:checkRequest] error:[OCMArg anyObjectRef]]);
}

- (void)testSaveFileFromUrl {
  NSString *fileName = @"https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/170px-Apple_logo_black.svg.png";
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];

  [self.storeManager saveFileFromUrl:fileName completion:^(NSData *data, NSError *error) {
    XCTAssertNotNil(data);
    XCTAssertNil(error);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:4.0 handler:nil];
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsPath = [paths objectAtIndex:0];
  NSURL *filePath = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", documentsPath]];
  fileName = [fileName MD5String];
  filePath = [filePath URLByAppendingPathComponent:fileName];
  NSData *data = [NSData dataWithContentsOfURL:filePath options:0 error:nil];
  XCTAssertNotNil(data);
}

@end
