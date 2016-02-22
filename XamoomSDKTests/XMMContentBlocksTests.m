//
//  XMMContentBlocksTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 03/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XMMEnduserApi.h"
#import "XMMContentBlocks.h"

@interface XMMContentBlocksTests : XCTestCase

@property id mockedApi;
@property id mockedTableView;

@end

@implementation XMMContentBlocksTests

- (void)setUp {
  [super setUp];
  self.mockedApi = OCMClassMock([XMMEnduserApi class]);
  self.mockedTableView = OCMClassMock([UITableView class]);
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testContentBlockInitWithTableView {
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:self.mockedTableView api:self.mockedApi];
  
  XCTAssertNotNil(contentBlocks);
  XCTAssertNotNil(contentBlocks.api);
  XCTAssertNotNil(contentBlocks.tableView);
}

- (void)testDisplayContentSetsItems {
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:self.mockedTableView api:self.mockedApi];
  
  [contentBlocks displayContent:[self xamoomContent]];

  XCTAssertTrue(contentBlocks.items.count == 2);
}

- (void)testkContentBlock9MapContentLinkNotification {
  XCTAssertTrue([[XMMContentBlocks kContentBlock9MapContentLinkNotification] isEqualToString:@"com.xamoom.kContentBlock9MapContentLinkNotification"]);
}

- (void)testThatUpdateFontSizeUpdatesValue {
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:self.mockedTableView api:self.mockedApi];

  [contentBlocks updateFontSizeTo:BigFontSize];
  
  XCTAssertTrue([XMMContentBlock0TableViewCell fontSize] == BigFontSize);
}

- (void)testThatItemsCountIsSet {
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:self.mockedTableView api:self.mockedApi];
  
  [contentBlocks displayContent:[self xamoomContent]];
  
  XCTAssertTrue([contentBlocks tableView:self.mockedTableView numberOfRowsInSection:0] == 2);
}

- (void)testThatCellForRowAtIndexPathReturnsContentBlock0Cell {
  UITableView *tableView = [[UITableView alloc] init];
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:tableView api:self.mockedApi];
  
  [contentBlocks displayContent:[self xamoomContent]];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  XMMContentBlock0TableViewCell *cell = (XMMContentBlock0TableViewCell *)[contentBlocks tableView:tableView cellForRowAtIndexPath:indexPath];
  
  XCTAssertTrue([cell.titleLabel.text isEqualToString:@"Block Title"]);
}

- (void)testThatCellForRowAtIndexPathReturnsContentBlock6Cell {
  UITableView *tableView = [[UITableView alloc] init];
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:tableView api:self.mockedApi];
  
  [contentBlocks displayContent:[self xamoomContent]];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  
  XMMContentBlock6TableViewCell *cell = (XMMContentBlock6TableViewCell *)[contentBlocks tableView:tableView cellForRowAtIndexPath:indexPath];
  
  XCTAssertTrue([cell.contentID isEqualToString:@"123456"]);
}

- (void)testThatCellForRowAtIndexPathReturnsBlankCell {
  UITableView *tableView = [[UITableView alloc] init];
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:tableView api:self.mockedApi];
  
  [contentBlocks displayContent:[self xamoomContentWithFalseContentBlock]];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  XMMContentBlock0TableViewCell *cell = (XMMContentBlock0TableViewCell *)[contentBlocks tableView:tableView cellForRowAtIndexPath:indexPath];
  
  XCTAssertNotNil(cell);
}

- (void)testThatSetStyleSetsColor {
  UITableView *tableView = [[UITableView alloc] init];
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:tableView api:self.mockedApi];
  
  XMMStyle *style = [[XMMStyle alloc] init];
  style.backgroundColor = @"#000000";
  
  contentBlocks.style = style;
  
  XCTAssertTrue([contentBlocks.style.backgroundColor isEqualToString:@"#000000"]);
  XCTAssertEqual(contentBlocks.style, style);
}

- (void)testThatClickContentNotificationCallsDelegate {
  NSString *contentID = @"12314";
  UITableView *tableView = [[UITableView alloc] init];
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:tableView api:self.mockedApi];
  id delegateMock = OCMProtocolMock(@protocol(XMMContentBlocksDelegate));
  contentBlocks.delegate = delegateMock;
  
  OCMExpect([delegateMock didClickContentBlock:[OCMArg isEqual:contentID]]);
  
  NSDictionary *userInfo = @{@"contentID":contentID};
  [[NSNotificationCenter defaultCenter]
   postNotificationName:XMMContentBlocks.kContentBlock9MapContentLinkNotification
   object:self userInfo:userInfo];
  
  OCMVerifyAll(delegateMock);
}

- (void)testAutomaticDimension {
  UITableView *tableView = [[UITableView alloc] init];
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:tableView api:self.mockedApi];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

  CGFloat height = [contentBlocks tableView:tableView heightForRowAtIndexPath:indexPath];
  
  XCTAssertEqual(height, UITableViewAutomaticDimension);
}

#pragma mark - Helpers

- (XMMContent *)xamoomContent {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Block Title";
  block1.text = @"";
  block1.publicStatus = YES;
  block1.blockType = 0;
  
  XMMContentBlock *block6 = [[XMMContentBlock alloc] init];
  block6.title = @"ContentBlock Title";
  block6.contentID = @"123456";
  block6.publicStatus = YES;
  block6.blockType = 6;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, block6, nil];
  
  return content;
}

- (XMMContent *)xamoomContentWithFalseContentBlock {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Block Title";
  block1.text = @"";
  block1.publicStatus = YES;
  block1.blockType = 10;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, nil];
  
  return content;
}

@end
