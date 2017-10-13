//
//  XMMContentBlockTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 07/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMContentBlock.h"
#import "XMMCDContent.h"

@interface XMMContentBlockTest : XCTestCase

@end

@implementation XMMContentBlockTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testContentBlocksResourceName {
  XCTAssertTrue([[XMMContentBlock resourceName] isEqualToString:@"contentblocks"]);
}

- (void)testInitWithCoreDataObject {
  XMMContentBlock *contentBlock = [[XMMContentBlock alloc] init];
  contentBlock.ID = @"1";
  contentBlock.title = @"title";
  contentBlock.publicStatus = YES;
  contentBlock.blockType = 2;
  contentBlock.text = @"text";
  contentBlock.artists = @"artists";
  contentBlock.fileID = @"fileID";
  contentBlock.soundcloudUrl = @"soundcloud";
  contentBlock.linkUrl = @"link";
  contentBlock.linkType = 3;
  contentBlock.contentID = @"id";
  contentBlock.downloadType = 4;
  contentBlock.spotMapTags = @[@"1", @"2"];
  contentBlock.scaleX = 0.7;
  contentBlock.videoUrl = @"video";
  contentBlock.showContent = NO;
  contentBlock.altText = @"alt";
  contentBlock.copyright = @"copyright";
  contentBlock.contentListTags = @[@"test1", @"test2"];
  contentBlock.contentListPageSize = 10;
  contentBlock.contentListSortAsc = true;
  
  XMMCDContentBlock *savedContentBlock = [XMMCDContentBlock insertNewObjectFrom:contentBlock];
  XMMContentBlock *newContentBlock = [[XMMContentBlock alloc] initWithCoreDataObject:savedContentBlock];
  
  XCTAssertTrue([newContentBlock.ID isEqualToString:contentBlock.ID]);
  XCTAssertTrue([newContentBlock.title isEqualToString:contentBlock.title]);
  XCTAssertTrue(newContentBlock.publicStatus == contentBlock.publicStatus);
  XCTAssertTrue(newContentBlock.blockType == contentBlock.blockType);
  XCTAssertTrue([newContentBlock.text isEqualToString:contentBlock.text]);
  XCTAssertTrue([newContentBlock.artists isEqualToString:contentBlock.artists]);
  XCTAssertTrue([newContentBlock.fileID isEqualToString:contentBlock.fileID]);
  XCTAssertTrue([newContentBlock.soundcloudUrl isEqualToString:contentBlock.soundcloudUrl]);
  XCTAssertTrue([newContentBlock.linkUrl isEqualToString:contentBlock.linkUrl]);
  XCTAssertTrue(newContentBlock.linkType == contentBlock.linkType);
  XCTAssertTrue(newContentBlock.downloadType == contentBlock.downloadType);
  XCTAssertTrue([newContentBlock.contentID isEqualToString:contentBlock.contentID]);
  XCTAssertTrue(newContentBlock.scaleX == contentBlock.scaleX);
  XCTAssertTrue([newContentBlock.videoUrl isEqualToString:contentBlock.videoUrl]);
  XCTAssertTrue(newContentBlock.showContent == contentBlock.showContent);
  XCTAssertTrue([newContentBlock.altText isEqualToString:contentBlock.altText]);
  XCTAssertTrue([newContentBlock.copyright isEqualToString:contentBlock.copyright]);
  XCTAssertTrue(newContentBlock.contentListPageSize == contentBlock.contentListPageSize);
  XCTAssertTrue(newContentBlock.contentListSortAsc == contentBlock.contentListSortAsc);
  XCTAssertTrue(newContentBlock.contentListTags == contentBlock.contentListTags);
}

- (void)testSaveOffline {
  XMMContentBlock *contentBlock = [[XMMContentBlock alloc] init];
  contentBlock.ID = @"1";
  
  XMMCDContentBlock *savedContentBlock = (XMMCDContentBlock *)[contentBlock saveOffline];
  
  XCTAssertNotNil(savedContentBlock);
}

@end
