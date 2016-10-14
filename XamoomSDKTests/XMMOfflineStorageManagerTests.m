//
//  XMMOfflineStorageManagerTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 29/09/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <CoreData/CoreData.h>
#import "XMMOfflineStorageManager.h"
#import "NSString+MD5.h"
#import "XMMCDContent.h"
#import "XMMCDContentBlock.h"
#import "XMMCDMarker.h"
#import "XMMCDMenu.h"
#import "XMMCDMenuItem.h"
#import "XMMCDSpot.h"
#import "XMMCDStyle.h"
#import "XMMCDSystem.h"
#import "XMMCDSystem.h"
#import "XMMCDSystemSettings.h"


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

- (void)skipped_testSetSharedinstance {
  XMMOfflineStorageManager *manager = [[XMMOfflineStorageManager alloc] init];
  [XMMOfflineStorageManager setSharedInstance:manager];
  
  XCTAssertEqual([XMMOfflineStorageManager sharedInstance], manager);
}

- (void)testSave {
  NSError *error = [self.storeManager save];
  
  XCTAssertNil(error);
  OCMVerify([self.mockedContext save:[OCMArg anyObjectRef]]);
}

- (void)testFetchAll {
  NSFetchRequest *checkRequest = [NSFetchRequest fetchRequestWithEntityName:[XMMCDSystemSettings coreDataEntityName]];
  [self.storeManager fetchAll:[XMMCDSystemSettings coreDataEntityName]];
  
  OCMVerify([self.mockedContext executeFetchRequest:[OCMArg isEqual:checkRequest] error:[OCMArg anyObjectRef]]);
}

- (void)testFetchEntityTypeJsonID {
  NSFetchRequest *checkRequest = [NSFetchRequest fetchRequestWithEntityName:[XMMCDSystemSettings coreDataEntityName]];
  checkRequest.predicate = [NSPredicate predicateWithFormat:@"jsonID = %@", @"1234"];
  
  [self.storeManager fetch:[XMMCDSystemSettings coreDataEntityName] jsonID:@"1234"];
  
  OCMVerify([self.mockedContext executeFetchRequest:[OCMArg isEqual:checkRequest] error:[OCMArg anyObjectRef]]);
}

- (void)testDeleteAllEntities {
  OCMExpect([self.mockedContext executeRequest:[OCMArg isKindOfClass:[NSBatchDeleteRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeRequest:[OCMArg isKindOfClass:[NSBatchDeleteRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeRequest:[OCMArg isKindOfClass:[NSBatchDeleteRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeRequest:[OCMArg isKindOfClass:[NSBatchDeleteRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeRequest:[OCMArg isKindOfClass:[NSBatchDeleteRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeRequest:[OCMArg isKindOfClass:[NSBatchDeleteRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeRequest:[OCMArg isKindOfClass:[NSBatchDeleteRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeRequest:[OCMArg isKindOfClass:[NSBatchDeleteRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeRequest:[OCMArg isKindOfClass:[NSBatchDeleteRequest class]] error:[OCMArg anyObjectRef]]);
  
  [self.storeManager deleteAllEntities];

  OCMVerifyAll(self.mockedContext);
}

@end
