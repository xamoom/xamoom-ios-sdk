//
//  XMMContentBlock2TableViewCellTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 17/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "XMMContentBlock2TableViewCell.h"

@interface XMMContentBlock2TableViewCellTest : XCTestCase

@end

@implementation XMMContentBlock2TableViewCellTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIfOfflineCallsFileManager {
  XMMContentBlock2TableViewCell *cell = [[XMMContentBlock2TableViewCell alloc] init];
  
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.videoUrl = @"www.xamoom.com/video.mp4";
  
  XMMOfflineFileManager *mockedFileManager = OCMClassMock([XMMOfflineFileManager class]);
  cell.fileManager = mockedFileManager;
  
  OCMStub([mockedFileManager urlForSavedData:[OCMArg any]]).andReturn([NSURL URLWithString:block.videoUrl]);
  
  [cell configureForCell:block tableView:nil indexPath:nil style:nil offline:YES];
 
  OCMVerify([mockedFileManager urlForSavedData:[OCMArg isEqual:block.videoUrl]]);
}

@end
