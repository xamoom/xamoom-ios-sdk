//
//  XMMCDContentBlockTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 05/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "XMMOfflineStorageManager.h"
#import "XMMCDContentBlock.h"
#import "XMMContentBlock.h"

@interface XMMCDContentBlockTest : XCTestCase

@property XMMOfflineStorageManager *mockedManager;

@end

@implementation XMMCDContentBlockTest

- (void)setUp {
  [super setUp];
  self.mockedManager = OCMPartialMock([[XMMOfflineStorageManager alloc] init]);
  [XMMOfflineStorageManager setSharedInstance:self.mockedManager];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testCoreDataEntityName {
  XCTAssertTrue([[XMMCDContentBlock coreDataEntityName] isEqualToString:@"XMMCDContentBlock"]);
}

- (void)testInsertNewObjectFromEntityWithNoExistingEntry {
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
  
  XMMCDContentBlock *savedContentBlock = [XMMCDContentBlock insertNewObjectFrom:contentBlock];
  
  OCMVerify([self.mockedManager saveFileFromUrl:[OCMArg isEqual:contentBlock.fileID] completion:[OCMArg any]]);
  OCMVerify([self.mockedManager saveFileFromUrl:[OCMArg isEqual:contentBlock.videoUrl] completion:[OCMArg any]]);
    
  XCTAssertTrue([savedContentBlock.jsonID isEqualToString:contentBlock.ID]);
  XCTAssertTrue([savedContentBlock.title isEqualToString:contentBlock.title]);
  XCTAssertTrue([savedContentBlock.publicStatus boolValue] == contentBlock.publicStatus);
  XCTAssertTrue([savedContentBlock.blockType intValue] == contentBlock.blockType);
  XCTAssertTrue([savedContentBlock.text isEqualToString:contentBlock.text]);
  XCTAssertTrue([savedContentBlock.artists isEqualToString:contentBlock.artists]);
  XCTAssertTrue([savedContentBlock.fileID isEqualToString:contentBlock.fileID]);
  XCTAssertTrue([savedContentBlock.soundcloudUrl isEqualToString:contentBlock.soundcloudUrl]);
  XCTAssertTrue([savedContentBlock.linkUrl isEqualToString:contentBlock.linkUrl]);
  XCTAssertTrue([savedContentBlock.linkType intValue] == contentBlock.linkType);
  XCTAssertTrue([savedContentBlock.downloadType intValue] == contentBlock.downloadType);
  XCTAssertTrue([savedContentBlock.contentID isEqualToString:contentBlock.contentID]);
  XCTAssertTrue([savedContentBlock.scaleX doubleValue] == contentBlock.scaleX);
  XCTAssertTrue([savedContentBlock.videoUrl isEqualToString:contentBlock.videoUrl]);
  XCTAssertTrue([savedContentBlock.showContent boolValue] == contentBlock.showContent);
  XCTAssertTrue([savedContentBlock.altText isEqualToString:contentBlock.altText]);
}

@end
