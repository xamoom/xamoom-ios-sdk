//
//  XMMOfflineStorageManagerTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 29/09/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMOfflineStorageManager.h"
#import "XMMSystem.h"

@interface XMMOfflineStorageManagerTests : XCTestCase

@property XMMOfflineStorageManager *storeManager;

@end

@implementation XMMOfflineStorageManagerTests

- (void)setUp {
  [super setUp];
  self.storeManager = [[XMMOfflineStorageManager alloc] init];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testInit {
  XMMOfflineStorageManager *manager = [[XMMOfflineStorageManager alloc] init];
  
  XCTAssertNotNil(manager);
  XCTAssertNotNil(manager.managedObjectContext);
}

- (void)testSaveSystem {
  XMMSystem *system = [NSEntityDescription insertNewObjectForEntityForName:@"XMMSystem" inManagedObjectContext:self.storeManager.managedObjectContext];
  system.name = @"Test";
  
  XCTAssertNotNil(system);
  XCTAssertEqual(system.name, @"Test");
  
}

@end
