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
  
  [contentBlocks displayContent:[self xamoomContent]];
  
  XCTAssertTrue([contentBlocks tableView:self.mockedTableView numberOfRowsInSection:0] == 1);
}

- (void)testThatCellForRowAtIndexPathReturnsContentBlock0Cell {
  UITableView *tableView = [[UITableView alloc] init];
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:tableView api:self.mockedApi];
  
  [contentBlocks displayContent:[self xamoomContent]];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  XMMContentBlock0TableViewCell *cell = (XMMContentBlock0TableViewCell *)[contentBlocks tableView:tableView cellForRowAtIndexPath:indexPath];
  
  XCTAssertTrue([cell.titleLabel.text isEqualToString:@"Block Title"]);
}

- (void)testThatCellForRowAtIndexPathReturnsBlankCell {
  UITableView *tableView = [[UITableView alloc] init];
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:tableView api:self.mockedApi];
  
  [contentBlocks displayContent:[self xamoomContentWithFalseContentBlock]];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  XMMContentBlock0TableViewCell *cell = (XMMContentBlock0TableViewCell *)[contentBlocks tableView:tableView cellForRowAtIndexPath:indexPath];
  
  XCTAssertNotNil(cell);
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
