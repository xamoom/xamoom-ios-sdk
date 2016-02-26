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
#import "XMMMusicPlayer.h"

@interface XMMContentBlocksTests : XCTestCase

@property id mockedApi;
@property id mockedTableView;
@property XMMContentBlocks *contentBlocks;
@property XMMStyle *style;

@end

@implementation XMMContentBlocksTests

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

- (void)testContentBlockInitWithTableView {
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:self.mockedTableView api:self.mockedApi];
  
  XCTAssertNotNil(contentBlocks);
  XCTAssertNotNil(contentBlocks.api);
  XCTAssertNotNil(contentBlocks.tableView);
}

- (void)testDisplayContentSetsItems {
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:self.mockedTableView api:self.mockedApi];
  
  [contentBlocks displayContent:[self xamoomStaticContent]];

  XCTAssertTrue(contentBlocks.items.count == 1);
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
  
  [contentBlocks displayContent:[self xamoomStaticContent]];
  
  XCTAssertTrue([contentBlocks tableView:self.mockedTableView numberOfRowsInSection:0] == 1);
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


- (void)testThatCellForRowAtIndexPathReturnsContentBlock0Cell {
  [self.contentBlocks displayContent:[self xamoomStaticContent]];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  XMMContentBlock0TableViewCell *cell = (XMMContentBlock0TableViewCell *)[self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  
  XCTAssertTrue([cell.titleLabel.text isEqualToString:@"Block Title"]);
}

- (void)testThatCellForRowAtIndexPathReturnsContentBlock6Cell {
  [self.contentBlocks displayContent:[self xamoomStaticContentType6]];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  XMMContentBlock6TableViewCell *cell = (XMMContentBlock6TableViewCell *)[self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  
  XCTAssertTrue([cell.contentID isEqualToString:@"123456"]);
}

- (void)testThatDidSelectContentBlock6CallsDelegate {
  NSString *contentID = @"123456";
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  UITableViewController *viewController = [[UITableViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] init];
  id navigationController = [OCMockObject partialMockForObject:navController];
  
  [navigationController pushViewController:viewController animated:NO];
  XCTAssertNotNil(viewController.navigationController);

  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:viewController.tableView api:self.mockedApi];
  viewController.tableView.delegate = contentBlocks;
  viewController.tableView.dataSource = contentBlocks;
  [self.contentBlocks displayContent:[self xamoomStaticContentType6]];
  
  XCTAssertEqual(viewController.tableView.delegate, contentBlocks);
  XCTAssertEqual(viewController.tableView.dataSource, contentBlocks);
  
  id delegateMock = OCMProtocolMock(@protocol(XMMContentBlocksDelegate));
  self.contentBlocks.delegate = delegateMock;
  
  [self.contentBlocks.tableView reloadData];
  
  OCMExpect([delegateMock didClickContentBlock:[OCMArg isEqual:contentID]]);
  
  [self.contentBlocks tableView:self.contentBlocks.tableView didSelectRowAtIndexPath:indexPath];
  
  OCMVerifyAll(delegateMock);
}

#pragma mark - Helpers

- (XMMContent *)xamoomStaticContent {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Block Title";
  block1.text = @"";
  block1.publicStatus = YES;
  block1.blockType = 0;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, nil];
  
  return content;
}

- (XMMContent *)xamoomStaticContentType6 {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Block Title";
  block1.publicStatus = YES;
  block1.blockType = 6;
  block1.contentID = @"123456";
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, nil];
  
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
