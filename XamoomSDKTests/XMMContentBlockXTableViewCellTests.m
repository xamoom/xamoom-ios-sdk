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
  self.contentBlocks = nil;
  self.mockedApi = nil;
  self.mockedTableView = nil;
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
  NSString *attributedString = testCell.contentTextView.text;
  XCTAssertTrue([attributedString isEqualToString:@"Some content description"]);
}

- (void)testThatContentBlock0CellConfigureForNoText {
  [self.contentBlocks displayContent:[self contentWithBlockType0]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock0TableViewCell *testCell = (XMMContentBlock0TableViewCell *)cell;
  
  XCTAssertTrue([testCell.titleLabel.text isEqualToString:@""]);
  XCTAssertTrue([testCell.contentTextView.text isEqualToString:@""]);
  XCTAssertTrue(testCell.contentTextViewTopConstraint.constant == 0);
  XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(testCell.contentTextView.textContainerInset, UIEdgeInsetsMake(0, -5, -20, -5)));
}

- (void)testThatContentBlock1CellConfigures{
  [self.contentBlocks displayContent:[self contentWithBlockType1]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock1TableViewCell *testCell = (XMMContentBlock1TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertTrue([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssertTrue([testCell.artistLabel.text isEqualToString:@"Artists Text"]);
}

- (void)testThatContentBlock1CellConfigureForNoText{
  [self.contentBlocks displayContent:[self contentWithBlockType1]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock2TableViewCell *testCell = (XMMContentBlock2TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssertTrue([testCell.titleLabel.textColor isEqual:[UIColor colorWithHexString: self.style.foregroundFontColor]]);
  XCTAssertFalse(testCell.webView.hidden);
  XCTAssertTrue(testCell.playIconImageView.hidden);
  XCTAssertTrue(testCell.thumbnailImageView.hidden);
}

- (void)testThatContentBlock2CellConfigureVimeo {
  [self.contentBlocks displayContent:[self contentWithBlockType2]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock2TableViewCell *testCell = (XMMContentBlock2TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNil(testCell.titleLabel.text);
  XCTAssertTrue([testCell.titleLabel.textColor isEqual:[UIColor colorWithHexString: self.style.foregroundFontColor]]);
  XCTAssertTrue(testCell.playIconImageView.hidden);
  XCTAssertTrue(testCell.thumbnailImageView.hidden);
  XCTAssertFalse(testCell.webView.hidden);
}

- (void)testThatContentBlock2CellConfigureWebVideo {
  [self.contentBlocks displayContent:[self contentWithBlockType2]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock2TableViewCell *testCell = (XMMContentBlock2TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNil(testCell.titleLabel.text);
  XCTAssertTrue([testCell.titleLabel.textColor isEqual:[UIColor colorWithHexString: self.style.foregroundFontColor]]);
  XCTAssertTrue(testCell.webView.hidden);
  XCTAssertFalse(testCell.playIconImageView.hidden);
  XCTAssertFalse(testCell.thumbnailImageView.hidden);
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

- (void)testThatContentBlock5CellConfigureCell {
  [self.contentBlocks displayContent:[self contentWithBlockType5]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock5TableViewCell *testCell = (XMMContentBlock5TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Content Title"]);
  XCTAssert([testCell.artistLabel.text isEqualToString:@"Artists Text"]);
  XCTAssert([testCell.downloadUrl isEqualToString:@"www.xamoom.com"]);
}

- (void)testThatContentBlock5CellConfigureWithNoText {
  [self.contentBlocks displayContent:[self contentWithBlockType5]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock5TableViewCell *testCell = (XMMContentBlock5TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNil(testCell.titleLabel.text);
  XCTAssertNil(testCell.artistLabel.text);
  XCTAssertNil(testCell.downloadUrl);
}

- (void)testThatContentBlock6CellConfigureCell {
  [self.contentBlocks displayContent:[self contentWithBlockType6]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(XMMContent *content, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    XMMContent *content = [[XMMContent alloc] init];
    content.title = @"Content Title check";
    content.imagePublicUrl = @"www.xamoom.com";
    content.contentDescription = @"check";
    passedBlock(content, nil);
  };
  
  [[[self.mockedApi stub] andDo:completion] contentWithID:[OCMArg isEqual:@"423hjk23h4k2j34"] options:XMMContentOptionsPreview completion:[OCMArg any]];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock6TableViewCell *testCell = (XMMContentBlock6TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.contentID isEqualToString:@"423hjk23h4k2j34"]);
  XCTAssert([testCell.contentTitleLabel.text isEqualToString:@"Content Title check"]);
  XCTAssert([testCell.contentExcerptLabel.text isEqualToString:@"check"]);
  XCTAssertTrue(testCell.loadingIndicator.hidden);
  XCTAssert(testCell.contentImageWidthConstraint.constant == 100);
  XCTAssert(testCell.contentTitleLeadingConstraint.constant == 8);
}

- (void)testThatContentBlock6CellConfigureWithoutText {
  [self.contentBlocks displayContent:[self contentWithBlockType6]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  
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
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock7TableViewCell *testCell = (XMMContentBlock7TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Block Title"]);
  XCTAssert(testCell.webViewTopConstraint.constant = 8);
}

- (void)testThatContentBlock7CellConfigureNoText {
  [self.contentBlocks displayContent:[self contentWithBlockType7]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock7TableViewCell *testCell = (XMMContentBlock7TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNil(testCell.titleLabel.text);
  XCTAssert(testCell.webViewTopConstraint.constant == 0);
}

- (void)testThatContentBlock7CellWebviewPause {
  [self.contentBlocks displayContent:[self contentWithBlockType7]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
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

- (void)testThatContentBlock8CellConfigureType0 {
  [self.contentBlocks displayContent:[self contentWithBlockType8]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock8TableViewCell *testCell = (XMMContentBlock8TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Block Title"]);
  XCTAssert([testCell.contentTextLabel.text isEqualToString:@"Block text"]);
  XCTAssert([testCell.fileID isEqualToString:@"www.xamoom.com"]);
}

- (void)testThatContentBlock8CellConfigureType1NoText {
  [self.contentBlocks displayContent:[self contentWithBlockType8]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock8TableViewCell *testCell = (XMMContentBlock8TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNil(testCell.titleLabel.text);
  XCTAssertNil(testCell.contentTextLabel.text
               );
  XCTAssertNil(testCell.fileID);
}

- (void)testThatContentBlock8CellIconForDownloadType {
  [self.contentBlocks displayContent:[self contentWithBlockType8]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock8TableViewCell *testCell = (XMMContentBlock8TableViewCell *)cell;
  
  testCell.contactImage = [self testImageNamed:@"contact"];
  testCell.calendarImage = [self testImageNamed:@"cal"];
  
  XCTAssertNotNil(testCell.contactImage);
  XCTAssertNotNil(testCell.calendarImage);

  XCTAssertEqual([testCell iconForDownloadType:0], testCell.contactImage);
  XCTAssertEqual([testCell iconForDownloadType:1], testCell.calendarImage);
}

#pragma mark - Helpers

- (UIImage *)testImageNamed:(NSString *)name {
  NSBundle *bundle = [NSBundle bundleForClass:[XMMContent class]];
  return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

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
  block1.contentID = @"423hjk23h4k2j34";
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
  block1.fileID = @"www.xamoom.com";
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
