//
//  XMMContentBlockXTableViewCellTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 24/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XMMEnduserApi.h"
#import "XMMContentBlocks.h"
#import "XMMMusicPlayer.h"

@interface XMMContentBlockXTableViewCellTests : XCTestCase

@property id mockedApi;
@property id mockedTableView;
@property XMMContentBlocks *contentBlocks;
@property XMMStyle *style;

@end

@implementation XMMContentBlockXTableViewCellTests

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


- (void)testThatContentBlock0CellConfigures {
  [self.contentBlocks displayContent:[self contentWithBlockType0]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock0TableViewCell *testCell = (XMMContentBlock0TableViewCell *)cell;
  
  XCTAssertTrue([testCell.titleLabel.textColor isEqual:[UIColor colorWithHexString: self.style.foregroundFontColor]]);
  XCTAssertTrue([[testCell.contentTextView.linkTextAttributes objectForKey:NSForegroundColorAttributeName] isEqual:[UIColor colorWithHexString: self.style.highlightFontColor]]);
  XCTAssertTrue([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssertNotNil(testCell.contentTextView.attributedText);
}

- (void)testThatContentBlock0CellConfigureForNoText {
  [self.contentBlocks displayContent:[self contentWithBlockType0]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock0TableViewCell *testCell = (XMMContentBlock0TableViewCell *)cell;
  
  XCTAssertTrue([testCell.titleLabel.text isEqualToString:@""]);
  XCTAssertTrue([testCell.contentTextView.text isEqualToString:@""]);
  XCTAssertTrue(testCell.contentTextViewTopConstraint.constant == 0);
  XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(testCell.contentTextView.textContainerInset, UIEdgeInsetsZero));
}

- (void)testThatContentBlock1CellConfigures{
  [self.contentBlocks displayContent:[self contentWithBlockType1]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock1TableViewCell *testCell = (XMMContentBlock1TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertTrue([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssertTrue([testCell.artistLabel.text isEqualToString:@"Artists Text"]);
}

- (void)testThatContentBlock1CellConfigureForNoText{
  [self.contentBlocks displayContent:[self contentWithBlockType1]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock1TableViewCell *testCell = (XMMContentBlock1TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNil(testCell.titleLabel.text);
  XCTAssertNil(testCell.artistLabel.text);
}

- (void)testThatContentBlock1CellTriggersMusicPlayer {
  [self.contentBlocks displayContent:[self contentWithBlockType1]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  XMMMusicPlayer *mockedMusicPlayer = OCMPartialMock([[XMMMusicPlayer alloc] init]);
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock1TableViewCell *testCell = (XMMContentBlock1TableViewCell *)cell;
  testCell.audioPlayerControl = mockedMusicPlayer;
  
  OCMExpect([mockedMusicPlayer play]);
  OCMExpect([mockedMusicPlayer pause]);
  
  [testCell playButtonTouched:nil];
  XCTAssertTrue(testCell.isPlaying);
  [testCell playButtonTouched:nil];
  XCTAssertFalse(testCell.isPlaying);
  
  OCMVerify(mockedMusicPlayer);
}

- (void)testThatContentBlock1CellMusicPlayerDelegateWorks {
  [self.contentBlocks displayContent:[self contentWithBlockType1]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock1TableViewCell *testCell = (XMMContentBlock1TableViewCell *)cell;
  AVURLAsset *asset = OCMPartialMock([[AVURLAsset alloc] initWithURL:[NSURL URLWithString:@"www.xamoom.com"] options:nil]);
  Float64 seconds = 5;
  int32_t preferredTimeScale = 600;
  CMTime inTime = CMTimeMakeWithSeconds(seconds, preferredTimeScale);
  OCMStub(asset.duration).andReturn(inTime);
  
  [testCell.audioPlayerControl.delegate didLoadAsset:nil];
  XCTAssert([testCell.remainingTimeLabel.text isEqualToString:@"-"]);
  
  [testCell.audioPlayerControl.delegate didLoadAsset:asset];
  XCTAssert([testCell.remainingTimeLabel.text isEqualToString:@"0:05"]);
  
  [testCell.audioPlayerControl.delegate didUpdateRemainingSongTime:@"0:01"];
  XCTAssert([testCell.remainingTimeLabel.text isEqualToString:@"0:01"]);
}

- (void)testThatContentBlock1CellPausesOnNotification {
  [self.contentBlocks displayContent:[self contentWithBlockType1]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  XMMMusicPlayer *mockedMusicPlayer = OCMPartialMock([[XMMMusicPlayer alloc] init]);
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock1TableViewCell *testCell = (XMMContentBlock1TableViewCell *)cell;
  testCell.audioPlayerControl = mockedMusicPlayer;
  
  OCMExpect([mockedMusicPlayer pause]);
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseAllSounds" object:nil];
  
  OCMVerify(mockedMusicPlayer);
}

- (void)testThatContentBlock2CellConfigureYoutube {
  [self.contentBlocks displayContent:[self contentWithBlockType2]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock2TableViewCell *testCell = (XMMContentBlock2TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssertTrue([testCell.titleLabel.textColor isEqual:[UIColor colorWithHexString: self.style.foregroundFontColor]]);
  XCTAssertFalse(testCell.youtubePlayerView.hidden);
  XCTAssertTrue(testCell.playIconImageView.hidden);
  XCTAssertTrue(testCell.thumbnailImageView.hidden);
}

- (void)testThatContentBlock2CellConfigureVimeo {
  [self.contentBlocks displayContent:[self contentWithBlockType2]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock2TableViewCell *testCell = (XMMContentBlock2TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNil(testCell.titleLabel.text);
  XCTAssertTrue([testCell.titleLabel.textColor isEqual:[UIColor colorWithHexString: self.style.foregroundFontColor]]);
  XCTAssertTrue(testCell.youtubePlayerView.hidden);
  XCTAssertFalse(testCell.playIconImageView.hidden);
  XCTAssertFalse(testCell.thumbnailImageView.hidden);
}

- (void)testThatContentBlock2CellConfigureWebVideo {
  [self.contentBlocks displayContent:[self contentWithBlockType2]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock2TableViewCell *testCell = (XMMContentBlock2TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNil(testCell.titleLabel.text);
  XCTAssertTrue([testCell.titleLabel.textColor isEqual:[UIColor colorWithHexString: self.style.foregroundFontColor]]);
  XCTAssertTrue(testCell.youtubePlayerView.hidden);
  XCTAssertFalse(testCell.playIconImageView.hidden);
  XCTAssertFalse(testCell.thumbnailImageView.hidden);
}

- (void)disable_testThatContentBlock2CellConfigureTap { //ugly test
  [self.contentBlocks displayContent:[self contentWithBlockType2]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock2TableViewCell *testCell = (XMMContentBlock2TableViewCell *)cell;
  testCell = (XMMContentBlock2TableViewCell *)OCMPartialMock(testCell);
  
  [testCell tappedVideoView:nil];
  
  OCMVerify([testCell tappedVideoView:[OCMArg any]]);
}

- (void)testThatContentBlock3CellConfigureForImage {
  [self.contentBlocks displayContent:[self contentWithBlockType3]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock3TableViewCell *testCell = (XMMContentBlock3TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert(testCell.horizontalSpacingImageTitleConstraint.constant == 8);
  XCTAssertTrue([testCell.titleLabel.textColor isEqual:[UIColor colorWithHexString: self.style.foregroundFontColor]]);
  XCTAssert([testCell.blockImageView.accessibilityHint isEqualToString:@"Content Title"]);
  XCTAssert(testCell.imageLeftHorizontalSpaceConstraint.constant == 0);
  XCTAssert(testCell.imageRightHorizontalSpaceConstraint.constant == 0);
}

- (void)testThatContentBlock3CellConfigureWithoutParameters {
  [self.contentBlocks displayContent:[self contentWithBlockType3]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock3TableViewCell *testCell = (XMMContentBlock3TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertTrue([testCell.titleLabel.text isEqualToString:@"SVG"]);
  XCTAssert(testCell.horizontalSpacingImageTitleConstraint.constant == 8);
  XCTAssertTrue([testCell.titleLabel.textColor isEqual:[UIColor colorWithHexString: self.style.foregroundFontColor]]);
  XCTAssert(testCell.imageLeftHorizontalSpaceConstraint.constant == 0);
  XCTAssert(testCell.imageRightHorizontalSpaceConstraint.constant == 0);
}



#pragma mark - Helpers

- (XMMContent *)contentWithBlockType0 {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Content Title";
  block1.text = @"Content Text";
  block1.publicStatus = YES;
  block1.blockType = 0;
  
  XMMContentBlock *block2 = [[XMMContentBlock alloc] init];
  block2.title = nil;
  block2.text = nil;
  block2.publicStatus = YES;
  block2.blockType = 0;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, block2, nil];
  
  return content;
}

- (XMMContent *)contentWithBlockType1 {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Content Title";
  block1.artists = @"Artists Text";
  block1.publicStatus = YES;
  block1.blockType = 1;
  
  XMMContentBlock *block2 = [[XMMContentBlock alloc] init];
  block2.title = nil;
  block2.text = nil;
  block2.publicStatus = YES;
  block2.blockType = 1;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, block2, nil];
  
  return content;
}

- (XMMContent *)contentWithBlockType2 {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Content Title";
  block1.videoUrl = @"https://www.youtube.com/watch?v=mVju1coG_6Q&list=WL&index=8";
  block1.publicStatus = YES;
  block1.blockType = 2;
  
  XMMContentBlock *block2 = [[XMMContentBlock alloc] init];
  block2.title = nil;
  block2.videoUrl = @"https://vimeo.com/149123295";
  block2.publicStatus = YES;
  block2.blockType = 2;
  
  XMMContentBlock *block3 = [[XMMContentBlock alloc] init];
  block3.title = nil;
  block3.videoUrl = @"https://storage.googleapis.com/xamoom-public-resources/testing_pingeborg.mp4";
  block3.publicStatus = YES;
  block3.blockType = 2;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, block2, block3, nil];
  
  return content;
}

- (XMMContent *)contentWithBlockType3 {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Content Title";
  block1.fileID = @"https://storage.googleapis.com/xamoom-files-dev/mobile/904ee8c40f6c46ebbdd41f752f058b9b.jpg";
  block1.publicStatus = YES;
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
