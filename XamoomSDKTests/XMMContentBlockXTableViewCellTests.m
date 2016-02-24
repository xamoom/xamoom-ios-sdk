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

- (void)testThatContentBlock4CellConfigureNoTextType0 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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

- (void)testThatContentBlock4CellConfigureType1 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:11 inSection:0];
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

- (void)testThatContentBlock4CellConfigureType13 {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:13 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:14 inSection:0];
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:15 inSection:0];
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
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:16 inSection:0];
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
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:17 inSection:0];
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

- (void)testThatContentBlock4CellConfigureTypeFalse {
  [self.contentBlocks displayContent:[self contentWithBlockType4]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:18 inSection:0];
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

- (void)testThatContentBlock5CellConfigureCell {
  [self.contentBlocks displayContent:[self contentWithBlockType5]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock5TableViewCell *testCell = (XMMContentBlock5TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.artistLabel.text isEqualToString:@"Artists Text"]);
  XCTAssert([testCell.downloadUrl isEqualToString:@"www.xamoom.com"]);
}

- (void)testThatContentBlock5CellConfigureWithNoText {
  [self.contentBlocks displayContent:[self contentWithBlockType5]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock5TableViewCell *testCell = (XMMContentBlock5TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNil(testCell.titleLabel.text);
  XCTAssertNil(testCell.artistLabel.text);
  XCTAssertNil(testCell.downloadUrl);
}

- (void)testThatContentBlock6CellConfigureCell {
  [self.contentBlocks displayContent:[self contentWithBlockType6]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(XMMContent *content, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    XMMContent *content = [[XMMContent alloc] init];
    content.title = @"Content Title check";
    content.imagePublicUrl = @"www.xamoom.com";
    content.contentDescription = @"check";
    passedBlock(content, nil);
  };
  
  [[[self.mockedApi stub] andDo:completion] contentWithID:[OCMArg any] options:XMMContentOptionsPreview completion:[OCMArg any]];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock6TableViewCell *testCell = (XMMContentBlock6TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.contentID isEqualToString:@"123456"]);
  XCTAssert([testCell.contentTitleLabel.text isEqualToString:@"Content Title check"]);
  XCTAssert([testCell.contentExcerptLabel.text isEqualToString:@"check"]);
  XCTAssertTrue(testCell.loadingIndicator.hidden);
  XCTAssert(testCell.contentImageWidthConstraint.constant == 100);
  XCTAssert(testCell.contentTitleLeadingConstraint.constant == 8);
}

- (void)testThatContentBlock6CellConfigureWithoutText {
  [self.contentBlocks displayContent:[self contentWithBlockType6]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(XMMContent *content, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    XMMContent *content = [[XMMContent alloc] init];
    passedBlock(content, nil);
  };
  
  [[[self.mockedApi stub] andDo:completion] contentWithID:[OCMArg any] options:XMMContentOptionsPreview completion:[OCMArg any]];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock6TableViewCell *testCell = (XMMContentBlock6TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.contentID isEqualToString:@"123456"]);
  XCTAssertNil(testCell.contentTitleLabel.text);
  XCTAssertTrue(testCell.loadingIndicator.hidden);
  XCTAssert(testCell.contentImageWidthConstraint.constant == 0);
  XCTAssert(testCell.contentTitleLeadingConstraint.constant == 0);
}

- (void)testThatContentBlock7CellConfigureCell {
  [self.contentBlocks displayContent:[self contentWithBlockType7]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock7TableViewCell *testCell = (XMMContentBlock7TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Block Title"]);
  XCTAssert(testCell.webViewTopConstraint.constant = 8);
}

- (void)testThatContentBlock7CellConfigureNoText {
  [self.contentBlocks displayContent:[self contentWithBlockType7]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock7TableViewCell *testCell = (XMMContentBlock7TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNil(testCell.titleLabel.text);
  XCTAssert(testCell.webViewTopConstraint.constant == 0);
}

- (void)testThatContentBlock7CellWebviewPause {
  [self.contentBlocks displayContent:[self contentWithBlockType7]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock7TableViewCell *testCell = (XMMContentBlock7TableViewCell *)cell;
  
  id mockedWebView = OCMClassMock([UIWebView class]);
  testCell.webView = mockedWebView;
  
  OCMExpect([mockedWebView reload]);
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseAllSounds" object:nil];
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Block Title"]);
  XCTAssert(testCell.webViewTopConstraint.constant = 8);
  OCMVerifyAll(mockedWebView);
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

- (XMMContent *)contentWithBlockType5 {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Content Title";
  block1.artists = @"Artists Text";
  block1.fileID = @"www.xamoom.com";
  block1.publicStatus = YES;
  block1.blockType = 5;
  
  XMMContentBlock *block2 = [[XMMContentBlock alloc] init];
  block2.title = nil;
  block2.text = nil;
  block2.publicStatus = YES;
  block2.blockType = 5;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, block2, nil];
  
  return content;
}

- (XMMContent *)contentWithBlockType6 {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.contentID = @"123456";
  block1.publicStatus = YES;
  block1.blockType = 6;
  
  XMMContentBlock *block2 = [[XMMContentBlock alloc] init];
  block2.contentID = @"123456";
  block2.publicStatus = YES;
  block2.blockType = 6;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, block2, nil];
  
  return content;
}

- (XMMContent *)contentWithBlockType7 {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Block Title";
  block1.soundcloudUrl = @"www.xamoom.com";
  block1.publicStatus = YES;
  block1.blockType = 7;
  
  XMMContentBlock *block2 = [[XMMContentBlock alloc] init];
  block2.title = nil;
  block2.publicStatus = YES;
  block2.blockType = 7;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, block2, nil];
  
  return content;
}

- (XMMContent *)contentWithBlockType8 {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Block Title";
  block1.text = @"Block text";
  block1.downloadType = 0;
  block1.publicStatus = YES;
  block1.blockType = 8;
  
  XMMContentBlock *block2 = [[XMMContentBlock alloc] init];
  block2.title = nil;
  block1.downloadType = 1;
  block2.publicStatus = YES;
  block2.blockType = 8;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, block2, nil];
  
  return content;
}

@end
