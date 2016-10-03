//
//  XMMSystemTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 03/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XMMSystem.h"
#import "XMMOfflineStorageManager.h"

@interface XMMSystemTest : XCTestCase

@property id offlineStorage;
@property id mockedContext;

@end

@implementation XMMSystemTest

- (void)verifySavedEntity:(XMMSystem *)system {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[XMMSystem coreDataEntityName]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"jsonID == %@", system.jsonID]];
  
  NSError *error = nil;
  NSArray *results = [[XMMOfflineStorageManager sharedInstance].managedObjectContext executeFetchRequest:request error:&error];

  NSLog(@"Results: %@", results);
}


- (void)setUp {
  self.offlineStorage = [XMMOfflineStorageManager sharedInstance];
  self.mockedContext = OCMPartialMock([XMMOfflineStorageManager sharedInstance].managedObjectContext);
  
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testInit {
  XMMSystem *system = [[XMMSystem alloc] init];
  system.name = @"Some Name";
  
  XCTAssertNotNil(system);
  XCTAssertEqual(@"Some Name", system.name);
}

- (void)testSaveOffline {
  XMMSystem *system = [[XMMSystem alloc] init];
  system.jsonID = @"1234";
  system.name = @"Some Name";
  
  NSError *error = [system saveOffline];
  
  OCMVerify([self.mockedContext insertObject:[OCMArg isEqual:system]]);
  XCTAssertNil(error);
}

@end
