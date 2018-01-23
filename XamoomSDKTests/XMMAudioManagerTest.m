//
//  XMMAudioManagerTest.m
//  XamoomSDKTests
//
//  Created by Raphael Seher on 18.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XMMAudioManager.h"

@interface XMMAudioManagerTest : XCTestCase

@property XMMMusicPlayer *mockMusicPlayer;

@end

@implementation XMMAudioManagerTest

- (void)setUp {
    [super setUp];
  
  _mockMusicPlayer = OCMClassMock([XMMMusicPlayer class]);
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSharedInstance {
  XMMAudioManager *audioManager = [XMMAudioManager sharedInstance];
  
  XCTAssertNotNil(audioManager);
}

- (void)testCreateMediaFileForPosition {
  XMMAudioManager *manager = [[XMMAudioManager alloc] init];
  NSURL *url = [NSURL URLWithString:@"www.xamoom.com"];
  
  XMMMediaFile *mediaFile = [manager createMediaFileForPosition:0 url:url title:@"title" artist:@"artist"];
  
  XCTAssertEqual(0, mediaFile.position);
  XCTAssertEqual(url, mediaFile.url);
  XCTAssertTrue([mediaFile.title isEqualToString:@"title"]);
  XCTAssertTrue([mediaFile.artist isEqualToString:@"artist"]);
  XCTAssertNil(mediaFile.album);
}

- (void)testCreateMediaFileWithExistingMediaFile {
  XMMAudioManager *manager = [[XMMAudioManager alloc] init];
  NSURL *url = [NSURL URLWithString:@"www.xamoom.com"];
  
  XMMMediaFile *mediaFile1 = [manager createMediaFileForPosition:0 url:url title:@"title" artist:@"artist"];
  
  XMMMediaFile *mediaFile2 = [manager createMediaFileForPosition:0 url:url title:@"title" artist:@"artist"];
  
  XCTAssertEqual(mediaFile1, mediaFile2);
}

- (void)testStartFileAtPosition {
  XMMAudioManager *manager = [[XMMAudioManager alloc] init];
  manager.musicPlayer = _mockMusicPlayer;
  NSURL *url = [NSURL URLWithString:@"www.xamoom.com"];
  
  XMMMediaFile *mediaFile = [manager createMediaFileForPosition:0 url:url title:@"title" artist:@"artist"];

  [mediaFile start];
  
  OCMVerify([_mockMusicPlayer prepareWith:[OCMArg any]]);
}

- (void)testStartFileAtPositionWithCurrentMediaFile {
  XMMAudioManager *manager = [[XMMAudioManager alloc] init];
  manager.musicPlayer = _mockMusicPlayer;
  NSURL *url = [NSURL URLWithString:@"www.xamoom.com"];
  
  XMMMediaFile *mediaFile1 = [manager createMediaFileForPosition:0 url:url title:@"title" artist:@"artist"];
  XMMMediaFile *mediaFile2 = [manager createMediaFileForPosition:1 url:url title:@"title" artist:@"artist"];
  
  [mediaFile1 start];
  [mediaFile2 start];
  
  OCMVerify([_mockMusicPlayer prepareWith:[OCMArg any]]);
  OCMVerify([_mockMusicPlayer pause]);
  OCMVerify([_mockMusicPlayer prepareWith:[OCMArg any]]);
}

- (void)testPauseFileAtPosition {
  XMMAudioManager *manager = [[XMMAudioManager alloc] init];
  manager.musicPlayer = _mockMusicPlayer;
  NSURL *url = [NSURL URLWithString:@"www.xamoom.com"];
  
  XMMMediaFile *mediaFile = [manager createMediaFileForPosition:0 url:url title:@"title" artist:@"artist"];
  
  [mediaFile start];
  [mediaFile pause];
  
  OCMVerify([_mockMusicPlayer pause]);
}

- (void)testReset {
  XMMAudioManager *manager = [[XMMAudioManager alloc] init];
  manager.musicPlayer = _mockMusicPlayer;
  NSURL *url = [NSURL URLWithString:@"www.xamoom.com"];
  
  XMMMediaFile *mediaFile1 = [manager createMediaFileForPosition:0 url:url title:@"title" artist:@"artist"];
  XMMMediaFile *mediaFile2 = [manager createMediaFileForPosition:1 url:url title:@"title" artist:@"artist"];
  
  [mediaFile1 start];
  [mediaFile2 start];
  
  [manager resetMediaFiles];
  
  XMMMediaFile *checkMediaFile1 = [manager createMediaFileForPosition:0 url:url title:@"title" artist:@"artist"];
  XMMMediaFile *checkMediaFile2 = [manager createMediaFileForPosition:1 url:url title:@"title" artist:@"artist"];

  XCTAssertNotEqual(checkMediaFile1, mediaFile1);
  XCTAssertEqual(checkMediaFile2, mediaFile2);
}

@end
