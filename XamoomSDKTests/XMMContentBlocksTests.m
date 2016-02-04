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

- (void)testDisplayContent {
  XMMContentBlocks *contentBlocks = [[XMMContentBlocks alloc] initWithTableView:self.mockedTableView api:self.mockedApi];
  [contentBlocks displayContent:[self xamoomContent]];
  
  XCTAssertTrue(contentBlocks.items.count == 1);
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

@end
