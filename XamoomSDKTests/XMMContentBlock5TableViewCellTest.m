//
//  XMMContentBlock5TableViewCellTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 18/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "XMMContentBlock5TableViewCell.h"

@interface XMMContentBlock5TableViewCellTest : XCTestCase

@end

@implementation XMMContentBlock5TableViewCellTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConfigureForCellOffline {
  XMMContentBlock5TableViewCell *cell = [[XMMContentBlock5TableViewCell alloc] init];

  XMMOfflineFileManager *mockFileManager = OCMClassMock([XMMOfflineFileManager class]);
  cell.fileManager = mockFileManager;
  
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.fileID = @"www.xamoom.com/smt.epub";
  
  [cell configureForCell:block tableView:nil indexPath:nil style:nil offline:YES];
  
  [cell openInBrowser:nil];
  
  OCMVerify([mockFileManager urlForSavedData:[OCMArg isEqual:block.fileID]]);
  
  XCTAssertTrue(cell.offline);
  XCTAssertTrue([cell.downloadUrl isEqualToString:block.fileID]);
}

@end
