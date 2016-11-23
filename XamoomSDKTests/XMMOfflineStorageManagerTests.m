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

  XMMSpot *spot = [[XMMSpot alloc] init];
  spot.ID = @"2";
  spot.image = @"www.xamoom.com/file2.jpg";
  XMMCDSpot *savedSpot = [XMMCDSpot insertNewObjectFrom:spot];
  
  XMMContentBlock *fileBlock = [[XMMContentBlock alloc] init];
  fileBlock.ID = @"3";
  fileBlock.fileID = @"www.xamoom.com/file3.jpg";
  
  XMMContentBlock *videoBlock = [[XMMContentBlock alloc] init];
  videoBlock.ID = @"4";
  videoBlock.videoUrl = @"www.xamoom.com/file4.jpg";
  content.contentBlocks = @[fileBlock, videoBlock];
  XMMCDContent *savedContent = [XMMCDContent insertNewObjectFrom:content];
  
  XMMOfflineFileManager *mockedFileManager = OCMClassMock([XMMOfflineFileManager class]);
  self.storeManager.fileManager = mockedFileManager;
  
  OCMStub([self.mockedContext executeFetchRequest:[OCMArg isEqual:[NSFetchRequest fetchRequestWithEntityName:[XMMCDContent coreDataEntityName]]] error:nil])
    .andReturn(@[savedContent]);
  OCMStub([self.mockedContext executeFetchRequest:[OCMArg isEqual:[NSFetchRequest fetchRequestWithEntityName:[XMMCDContentBlock coreDataEntityName]]] error:nil])
  .andReturn(savedContent.contentBlocks);
  OCMStub([self.mockedContext executeFetchRequest:[OCMArg isEqual:[NSFetchRequest fetchRequestWithEntityName:[XMMCDSpot coreDataEntityName]]] error:nil])
  .andReturn(@[savedSpot]);
  
  [self.storeManager deleteAllEntities];

  OCMVerify([mockedFileManager deleteFileWithUrl:[OCMArg isEqual:@"www.xamoom.com/file.jpg"] error:nil]);
  OCMVerify([mockedFileManager deleteFileWithUrl:[OCMArg isEqual:@"www.xamoom.com/file2.jpg"] error:nil]);
  OCMVerify([mockedFileManager deleteFileWithUrl:[OCMArg isEqual:@"www.xamoom.com/file3.jpg"] error:nil]);
  OCMVerify([mockedFileManager deleteFileWithUrl:[OCMArg isEqual:@"www.xamoom.com/file4.jpg"] error:nil]);

  OCMVerify([self.mockedContext deleteObject:[OCMArg isEqual:savedContent]]);
}

- (void)testSaveFileDeleteWithContentDuplicate {
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"1";
  content.imagePublicUrl = @"www.xamoom.com/file.jpg";
  XMMCDContent *savedContent = [XMMCDContent insertNewObjectFrom:content];
  
  OCMStub([self.mockedContext executeFetchRequest:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(@[savedContent]);
  
  XMMOfflineFileManager *mockedFileManager = OCMClassMock([XMMOfflineFileManager class]);
  OCMReject([mockedFileManager deleteFileWithUrl:[OCMArg any] error:[OCMArg anyObjectRef]]);
  self.storeManager.fileManager = mockedFileManager;
  
  [self.storeManager.saveDeletionFiles addObject:@"www.xamoom.com/file.jpg"];
  [self.storeManager deleteLocalFilesWithSafetyCheck];
}

- (void)testSaveFileDeleteWithSpotDuplicate {
  XMMSpot *spot = [[XMMSpot alloc] init];
  spot.ID = @"2";
  spot.image = @"www.xamoom.com/file.jpg";
  XMMCDSpot *savedSpot = [XMMCDSpot insertNewObjectFrom:spot];
  
  OCMStub([self.mockedContext executeFetchRequest:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(@[savedSpot]);

  XMMOfflineFileManager *mockedFileManager = OCMClassMock([XMMOfflineFileManager class]);
  OCMReject([mockedFileManager deleteFileWithUrl:[OCMArg any] error:nil]);
  self.storeManager.fileManager = mockedFileManager;
  
  [self.storeManager.saveDeletionFiles addObject:@"www.xamoom.com/file.jpg"];
  [self.storeManager deleteLocalFilesWithSafetyCheck];
  
  OCMVerify(mockedFileManager);
}

- (void)testSaveFileDeleteWithContentBlockWithFileIDDuplicate {
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.ID = @"1";
  block.fileID = @"www.xamoom.com/file.jpg";
  [XMMCDContentBlock insertNewObjectFrom:block];
  
  OCMStub([self.mockedContext executeFetchRequest:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(@[block]);

  XMMOfflineFileManager *mockedFileManager = OCMClassMock([XMMOfflineFileManager class]);
  OCMReject([mockedFileManager deleteFileWithUrl:[OCMArg any] error:nil]);
  self.storeManager.fileManager = mockedFileManager;
  
  [self.storeManager.saveDeletionFiles addObject:@"www.xamoom.com/file.jpg"];
  [self.storeManager deleteLocalFilesWithSafetyCheck];
  
  OCMVerify(mockedFileManager);
}

- (void)testSaveFileDeleteWithContentBlockWithVideoUrlDuplicate {
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.ID = @"1";
  block.videoUrl = @"www.xamoom.com/file.jpg";
  [XMMCDContentBlock insertNewObjectFrom:block];
  
  OCMStub([self.mockedContext executeFetchRequest:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(@[block]);
  
  XMMOfflineFileManager *mockedFileManager = OCMClassMock([XMMOfflineFileManager class]);
  OCMReject([mockedFileManager deleteFileWithUrl:[OCMArg any] error:nil]);
  self.storeManager.fileManager = mockedFileManager;
  
  [self.storeManager.saveDeletionFiles addObject:@"www.xamoom.com/file.jpg"];
  [self.storeManager deleteLocalFilesWithSafetyCheck];
  
  OCMVerify(mockedFileManager);
}

- (void)testSaveFileDeleteSuccess {
  XMMOfflineFileManager *mockedFileManager = OCMClassMock([XMMOfflineFileManager class]);
  self.storeManager.fileManager = mockedFileManager;
  
  OCMStub([self.mockedContext executeFetchRequest:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(@[]);

  [self.storeManager.saveDeletionFiles addObject:@"www.xamoom.com/file.jpg"];
  [self.storeManager deleteLocalFilesWithSafetyCheck];
  
  OCMVerify([mockedFileManager deleteFileWithUrl:[OCMArg isEqual:@"www.xamoom.com/file.jpg"] error:nil]);
}

- (void)testDeleteEntityWithID {
  XMMContent *content = [[XMMContent alloc] init];
  content.ID = @"1";
  XMMCDContent *savedContent = [XMMCDContent insertNewObjectFrom:content];
  
  OCMStub([self.mockedContext executeFetchRequest:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(@[savedContent]);
  
  [self.storeManager deleteEntity:[XMMCDContent class] ID:@"1"];
  
  OCMVerify([self.mockedContext deleteObject:[OCMArg isEqual:savedContent]]);
}

@end
