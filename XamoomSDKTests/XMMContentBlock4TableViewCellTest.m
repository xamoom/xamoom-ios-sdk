//
//  XMMContentBlock4TableViewCellTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 12/12/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XMMEnduserApi.h"
#import "XMMContentBlocks.h"

@interface XMMContentBlock4TableViewCellTest : XCTestCase

@property id mockedApi;
@property id mockedTableView;
@property XMMContentBlocks *contentBlocks;
@property XMMStyle *style;

@end

@implementation XMMContentBlock4TableViewCellTest

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
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testThatContentBlock4CellConfigureNoTextType0 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNil(testCell.titleLabel.text);
  XCTAssertNil(testCell.linkTextLabel.text);
  XCTAssertNil(testCell.linkUrl);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.facebookColor]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor whiteColor]);
}

- (void)testThatContentBlock4CellConfigureTypeFalse {
  self.contentBlocks.showAllStoreLinks = YES;
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:19 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title false"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.standardGreyColor]);
  XCTAssertEqual(testCell.icon.tintColor, testCell.standardTextColor);
  XCTAssertEqual(testCell.linkTextLabel.textColor, testCell.standardTextColor);
  XCTAssertEqual(testCell.titleLabel.textColor, testCell.standardTextColor);
}

- (void)testThatContentBlock4CellConfigureType1 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.twitterColor]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor whiteColor]);
}

- (void)testThatContentBlock4CellConfigureType2 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.standardGreyColor]);
  XCTAssertEqual(testCell.icon.tintColor, testCell.standardTextColor);
  XCTAssertEqual(testCell.linkTextLabel.textColor, testCell.standardTextColor);
  XCTAssertEqual(testCell.titleLabel.textColor, testCell.standardTextColor);
}

- (void)testThatContentBlock4CellConfigureType3 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.shopColor]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor blackColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor blackColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor blackColor]);
}

- (void)testThatContentBlock4CellConfigureType4 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.standardGreyColor]);
  XCTAssertEqual(testCell.icon.tintColor, testCell.standardTextColor);
  XCTAssertEqual(testCell.linkTextLabel.textColor, testCell.standardTextColor);
  XCTAssertEqual(testCell.titleLabel.textColor, testCell.standardTextColor);
}

- (void)testThatContentBlock4CellConfigureType5 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.linkedInColor]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor whiteColor]);
}

- (void)testThatContentBlock4CellConfigureType6 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.flickrColor]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor whiteColor]);
}

- (void)testThatContentBlock4CellConfigureType7 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.soundcloudColor]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor blackColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor blackColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor blackColor]);
}

- (void)testThatContentBlock4CellConfigureType8 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.standardGreyColor]);
  XCTAssertEqual(testCell.icon.tintColor, testCell.standardTextColor);
  XCTAssertEqual(testCell.linkTextLabel.textColor, testCell.standardTextColor);
  XCTAssertEqual(testCell.titleLabel.textColor, testCell.standardTextColor);
}

- (void)testThatContentBlock4CellConfigureType9 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.youtubeColor]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor whiteColor]);
}

- (void)testThatContentBlock4CellConfigureType10 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:11 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.googleColor]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor whiteColor]);
}

- (void)testThatContentBlock4CellConfigureType11 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:12 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.standardGreyColor]);
  XCTAssertEqual(testCell.icon.tintColor, testCell.standardTextColor);
  XCTAssertEqual(testCell.linkTextLabel.textColor, testCell.standardTextColor);
  XCTAssertEqual(testCell.titleLabel.textColor, testCell.standardTextColor);
}

- (void)testThatContentBlock4CellConfigureType12 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:13 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.standardGreyColor]);
  XCTAssertEqual(testCell.icon.tintColor, testCell.standardTextColor);
  XCTAssertEqual(testCell.linkTextLabel.textColor, testCell.standardTextColor);
  XCTAssertEqual(testCell.titleLabel.textColor, testCell.standardTextColor);
}

- (void)testThatContentBlock4CellConfigureType13 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:14 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.spotifyColor]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor blackColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor blackColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor blackColor]);
}

- (void)testThatContentBlock4CellConfigureType14 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:15 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.navigationColor]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor whiteColor]);
}

- (void)testThatContentBlock4CellConfigureType15 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:16 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title apple"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:[UIColor blackColor]]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor whiteColor]);
}

- (void)testThatContentBlock4CellConfigureType16 {
  self.contentBlocks.showAllStoreLinks = YES;
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:17 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title android"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.androidColor]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor whiteColor]);
}

- (void)testThatContentBlock4CellConfigureType17 {
  self.contentBlocks.showAllStoreLinks = YES;
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:18 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock4TableViewCell *testCell = (XMMContentBlock4TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title windows"]);
  XCTAssert([testCell.linkTextLabel.text isEqualToString:@"Link"]);
  XCTAssert([testCell.linkUrl isEqualToString:@"www.xamoom.com"]);
  XCTAssert([testCell.viewForBackgroundColor.backgroundColor isEqual:testCell.windowsColor]);
  XCTAssertEqual(testCell.icon.tintColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.linkTextLabel.textColor, [UIColor whiteColor]);
  XCTAssertEqual(testCell.titleLabel.textColor, [UIColor whiteColor]);
}

# pragma mark - Helper

- (XMMContent *)contentWithBlockType4 {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block2 = [[XMMContentBlock alloc] init];
  block2.title = nil;
  block2.text = nil;
  block2.linkUrl = nil;
  block2.linkType = 0;
  block2.publicStatus = YES;
  block2.blockType = 4;
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Content Title";
  block1.text = @"Link";
  block1.linkUrl = @"www.xamoom.com";
  block1.linkType = 1;
  block1.publicStatus = YES;
  block1.blockType = 4;
  
  XMMContentBlock *block3 = [[XMMContentBlock alloc] init];
  block3.title = @"Content Title";
  block3.text = @"Link";
  block3.linkUrl = @"www.xamoom.com";
  block3.linkType = 2;
  block3.publicStatus = YES;
  block3.blockType = 4;
  
  XMMContentBlock *block4 = [[XMMContentBlock alloc] init];
  block4.title = @"Content Title";
  block4.text = @"Link";
  block4.linkUrl = @"www.xamoom.com";
  block4.linkType = 3;
  block4.publicStatus = YES;
  block4.blockType = 4;
  
  XMMContentBlock *block5 = [[XMMContentBlock alloc] init];
  block5.title = @"Content Title";
  block5.text = @"Link";
  block5.linkUrl = @"www.xamoom.com";
  block5.linkType = 4;
  block5.publicStatus = YES;
  block5.blockType = 4;
  
  XMMContentBlock *block6 = [[XMMContentBlock alloc] init];
  block6.title = @"Content Title";
  block6.text = @"Link";
  block6.linkUrl = @"www.xamoom.com";
  block6.linkType = 5;
  block6.publicStatus = YES;
  block6.blockType = 4;
  
  XMMContentBlock *block7 = [[XMMContentBlock alloc] init];
  block7.title = @"Content Title";
  block7.text = @"Link";
  block7.linkUrl = @"www.xamoom.com";
  block7.linkType = 6;
  block7.publicStatus = YES;
  block7.blockType = 4;
  
  XMMContentBlock *block8 = [[XMMContentBlock alloc] init];
  block8.title = @"Content Title";
  block8.text = @"Link";
  block8.linkUrl = @"www.xamoom.com";
  block8.linkType = 7;
  block8.publicStatus = YES;
  block8.blockType = 4;
  
  XMMContentBlock *block9 = [[XMMContentBlock alloc] init];
  block9.title = @"Content Title";
  block9.text = @"Link";
  block9.linkUrl = @"www.xamoom.com";
  block9.linkType = 8;
  block9.publicStatus = YES;
  block9.blockType = 4;
  
  XMMContentBlock *block10 = [[XMMContentBlock alloc] init];
  block10.title = @"Content Title";
  block10.text = @"Link";
  block10.linkUrl = @"www.xamoom.com";
  block10.linkType = 9;
  block10.publicStatus = YES;
  block10.blockType = 4;
  
  XMMContentBlock *block11 = [[XMMContentBlock alloc] init];
  block11.title = @"Content Title";
  block11.text = @"Link";
  block11.linkUrl = @"www.xamoom.com";
  block11.linkType = 10;
  block11.publicStatus = YES;
  block11.blockType = 4;
  
  XMMContentBlock *block12 = [[XMMContentBlock alloc] init];
  block12.title = @"Content Title";
  block12.text = @"Link";
  block12.linkUrl = @"www.xamoom.com";
  block12.linkType = 11;
  block12.publicStatus = YES;
  block12.blockType = 4;
  
  XMMContentBlock *block13 = [[XMMContentBlock alloc] init];
  block13.title = @"Content Title";
  block13.text = @"Link";
  block13.linkUrl = @"www.xamoom.com";
  block13.linkType = 12;
  block13.publicStatus = YES;
  block13.blockType = 4;
  
  XMMContentBlock *block14 = [[XMMContentBlock alloc] init];
  block14.title = @"Content Title";
  block14.text = @"Link";
  block14.linkUrl = @"www.xamoom.com";
  block14.linkType = 13;
  block14.publicStatus = YES;
  block14.blockType = 4;
  
  XMMContentBlock *block15 = [[XMMContentBlock alloc] init];
  block15.title = @"Content Title";
  block15.text = @"Link";
  block15.linkUrl = @"www.xamoom.com";
  block15.linkType = 14;
  block15.publicStatus = YES;
  block15.blockType = 4;
  
  XMMContentBlock *block16 = [[XMMContentBlock alloc] init];
  block16.title = @"Content Title apple";
  block16.text = @"Link";
  block16.linkUrl = @"www.xamoom.com";
  block16.linkType = 15;
  block16.publicStatus = YES;
  block16.blockType = 4;
  
  XMMContentBlock *block17 = [[XMMContentBlock alloc] init];
  block17.title = @"Content Title android";
  block17.text = @"Link";
  block17.linkUrl = @"www.xamoom.com";
  block17.linkType = 16;
  block17.publicStatus = YES;
  block17.blockType = 4;
  
  XMMContentBlock *block18 = [[XMMContentBlock alloc] init];
  block18.title = @"Content Title windows";
  block18.text = @"Link";
  block18.linkUrl = @"www.xamoom.com";
  block18.linkType = 17;
  block18.publicStatus = YES;
  block18.blockType = 4;
  
  XMMContentBlock *block19 = [[XMMContentBlock alloc] init];
  block19.title = @"Content Title false";
  block19.text = @"Link";
  block19.linkUrl = @"www.xamoom.com";
  block19.linkType = 18;
  block19.publicStatus = YES;
  block19.blockType = 4;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block2, block1, block3, block4, block5, block6, block7, block8, block9, block10, block11, block12, block13, block14, block15, block16, block17, block18, block19, nil];
  
  return content;
}


@end
