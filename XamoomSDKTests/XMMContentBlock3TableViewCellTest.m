//
//  XMMContentBlock3TableViewCellTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 18/01/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XMMContentBlock3TableViewCell.h"
#import "XMMContentBlock.h"
#import "XMMContentBlocks.h"

@interface XMMContentBlock3TableViewCellTest : XCTestCase

@property id mockedApi;
@property id mockedTableView;
@property XMMContentBlocks *contentBlocks;
@property XMMStyle *style;

@end

@implementation XMMContentBlock3TableViewCellTest

- (void)setUp {
  [super setUp];
  
  self.mockedApi = OCMClassMock([XMMEnduserApi class]);
  self.mockedTableView = OCMClassMock([UITableView class]);
  
  self.style = [[XMMStyle alloc] init];
  self.style.foregroundFontColor = @"#222222";
  self.style.highlightFontColor = @"#0000FF";
  self.style.backgroundColor = @"#FFFFFF";
  
  UITableView *tableView = [[UITableView alloc] init];
  self.contentBlocks = [[XMMContentBlocks alloc] initWithTableView:tableView api:self.mockedApi];
  self.contentBlocks.style = self.style;
}

- (void)tearDown {
  self.contentBlocks = nil;
  self.mockedApi = nil;
  self.mockedTableView = nil;
  [super tearDown];
}

- (void)testThatContentBlock3CellConfigureForImage {
  [self.contentBlocks displayContent:[self contentWithBlockType3]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock3TableViewCell *testCell = (XMMContentBlock3TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert(testCell.horizontalSpacingImageTitleConstraint.constant == 8);
  XCTAssertTrue([testCell.titleLabel.textColor isEqual:[UIColor colorWithHexString: self.style.foregroundFontColor]]);
  XCTAssertTrue([testCell.copyrightLabel.text isEqual:@"copyright"]);
  XCTAssert([testCell.blockImageView.accessibilityHint isEqualToString:@"Content Title"]);
  XCTAssert(testCell.imageLeftHorizontalSpaceConstraint.constant == 0);
  XCTAssert(testCell.imageRightHorizontalSpaceConstraint.constant == 0);
}

- (void)testThatContentBlock3CellConfigureWithoutParameters {
  [self.contentBlocks displayContent:[self contentWithBlockType3]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock3TableViewCell *testCell = (XMMContentBlock3TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNil(testCell.titleLabel.text);
  XCTAssert(testCell.horizontalSpacingImageTitleConstraint.constant == 0);
  XCTAssertTrue([testCell.titleLabel.textColor isEqual:[UIColor colorWithHexString: self.style.foregroundFontColor]]);
  XCTAssertTrue([testCell.blockImageView.accessibilityHint isEqualToString:@"Alt Text"]);
  XCTAssert(testCell.imageLeftHorizontalSpaceConstraint.constant == 80);
  XCTAssert(testCell.imageRightHorizontalSpaceConstraint.constant == -80);
}

- (void)testThatContentBlock3CellConfigureSVG {
  [self.contentBlocks displayContent:[self contentWithBlockType3]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock3TableViewCell *testCell = (XMMContentBlock3TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertTrue([testCell.titleLabel.text isEqualToString:@"SVG"]);
  XCTAssert(testCell.horizontalSpacingImageTitleConstraint.constant == 8);
  XCTAssertTrue([testCell.titleLabel.textColor isEqual:[UIColor colorWithHexString: self.style.foregroundFontColor]]);
  XCTAssert(testCell.imageLeftHorizontalSpaceConstraint.constant == 0);
  XCTAssert(testCell.imageRightHorizontalSpaceConstraint.constant == 0);
}

- (void)testIfOfflineCallsFileManager {
  XMMContentBlock3TableViewCell *cell = [[XMMContentBlock3TableViewCell alloc] init];
  
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.videoUrl = @"www.xamoom.com/image.jpg";
  
  XMMOfflineFileManager *mockedFileManager = OCMClassMock([XMMOfflineFileManager class]);
  cell.fileManager = mockedFileManager;
  
  OCMStub([mockedFileManager urlForSavedData:[OCMArg any]]).andReturn([NSURL URLWithString:block.videoUrl]);
  
  [cell configureForCell:block tableView:nil indexPath:nil style:nil offline:YES];
  
  OCMVerify([mockedFileManager urlForSavedData:[OCMArg isEqual:block.fileID]]);
}

# pragma mark - helper

- (XMMContent *)contentWithBlockType3 {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Content Title";
  block1.fileID = @"https://storage.googleapis.com/xamoom-files-dev/mobile/904ee8c40f6c46ebbdd41f752f058b9b.jpg";
  block1.publicStatus = YES;
  block1.copyright = @"copyright";
  block1.blockType = 3;
  
  XMMContentBlock *block2 = [[XMMContentBlock alloc] init];
  block2.title = nil;
  block2.fileID = nil;
  block2.scaleX = 50;
  block2.altText = @"Alt Text";
  block2.publicStatus = YES;
  block2.blockType = 3;
  
  XMMContentBlock *block3 = [[XMMContentBlock alloc] init];
  block3.title = @"SVG";
  block3.fileID = @"https://storage.googleapis.com/xamoom-files-dev/0cd9f04d14c74a2d922f6e0f0022a9b4.svg";
  block3.publicStatus = YES;
  block3.blockType = 3;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, block2, block3, nil];
  
  return content;
}

@end
