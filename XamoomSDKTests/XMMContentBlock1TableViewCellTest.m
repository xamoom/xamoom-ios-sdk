//
//  XMMContentBlock1TableViewCellTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 17/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "XMMContentBlock1TableViewCell.h"
#import "XMMContentBlock.h"

@interface XMMContentBlock1TableViewCellTest : XCTestCase

@end

@implementation XMMContentBlock1TableViewCellTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
- (void)testConfigureCellOffline {
  XMMContentBlock1TableViewCell *cell = [[XMMContentBlock1TableViewCell alloc] init];
  XMMMusicPlayer *mockedPlayer = OCMClassMock([XMMMusicPlayer class]);
  cell.progressBar = mockedPlayer;
  
  XMMOfflineFileManager *mockedFileManager = OCMClassMock([XMMOfflineFileManager class]);
  cell.fileManager = mockedFileManager;
  
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.fileID = @"http://www.xamoom.com/file1";
  
  OCMStub([mockedFileManager urlForSavedData:[OCMArg isEqual:block.fileID]]).andReturn([NSURL URLWithString:@"file://localFile1"]);
  
  [cell configureForCell:block tableView:nil indexPath:nil style:nil offline:YES];
  
  OCMVerify([mockedPlayer initAudioPlayerWithUrlString:[OCMArg isEqual:@"file://localFile1"]]);
  
  XCTAssertNotNil(cell);
}
 */

@end
