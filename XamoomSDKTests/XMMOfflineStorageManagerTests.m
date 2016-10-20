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

- (void)testDeleteAllEntitiesCallsFetchRequest {
  OCMExpect([self.mockedContext executeFetchRequest:[OCMArg isKindOfClass:[NSFetchRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeFetchRequest:[OCMArg isKindOfClass:[NSFetchRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeFetchRequest:[OCMArg isKindOfClass:[NSFetchRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeFetchRequest:[OCMArg isKindOfClass:[NSFetchRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeFetchRequest:[OCMArg isKindOfClass:[NSFetchRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeFetchRequest:[OCMArg isKindOfClass:[NSFetchRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeFetchRequest:[OCMArg isKindOfClass:[NSFetchRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeFetchRequest:[OCMArg isKindOfClass:[NSFetchRequest class]] error:[OCMArg anyObjectRef]]);
  OCMExpect([self.mockedContext executeFetchRequest:[OCMArg isKindOfClass:[NSFetchRequest class]] error:[OCMArg anyObjectRef]]);
  
  [self.storeManager deleteAllEntities];

  OCMVerifyAll(self.mockedContext);
}

- (void)testDeleteAllEntitiesCallsDeleteSavedFiles {
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"1";
  content.imagePublicUrl = @"www.xamoom.com/file.jpg";
  XMMCDContent *savedContent = [XMMCDContent insertNewObjectFrom:content];

  XMMOfflineFileManager *mockedFileManager = OCMClassMock([XMMOfflineFileManager class]);
  self.storeManager.fileManager = mockedFileManager;
  
  OCMStub([self.mockedContext executeFetchRequest:[OCMArg any] error:nil])
    .andReturn(@[savedContent]);
  
  [self.storeManager deleteAllEntities];

  OCMVerify([mockedFileManager deleteFileWithUrl:[OCMArg isEqual:@"www.xamoom.com/file.jpg"] error:nil]);
  OCMVerify([self.mockedContext deleteObject:[OCMArg isEqual:savedContent]]);
}

@end
