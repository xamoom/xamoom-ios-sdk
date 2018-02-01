//
//  MediaFileTest.m
//  XamoomSDKTests
//
//  Created by Raphael Seher on 18.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMMediaFile.h"
#import <OCMock.h>

@interface XMMMediaFileTest : XCTestCase

@property id playBackDelegateMock;
@property id mockMediaFileDelegate;

@property NSURL *url;

@end

@implementation XMMMediaFileTest

- (void)setUp {
  [super setUp];
  
  _playBackDelegateMock = OCMProtocolMock(@protocol(XMMPlaybackDelegate));
  _mockMediaFileDelegate = OCMProtocolMock(@protocol(XMMMediaFileDelegate));
  _url = [NSURL URLWithString:@"www.xamoom.com"];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testInit {
  XMMMediaFile *mediaFile = [[XMMMediaFile alloc]
                             initWithPlaybackDelegate:_playBackDelegateMock
                             ID:@"0" url:_url
                             title:@"title" artist:@"artist" album:@"album"];
  
  XCTAssertEqual(_playBackDelegateMock, mediaFile.playbackDelegate);
  XCTAssertEqual(@"0", mediaFile.ID);
  XCTAssertEqual(_url, mediaFile.url);
  XCTAssertTrue([mediaFile.title isEqualToString:@"title"]);
  XCTAssertTrue([mediaFile.artist isEqualToString:@"artist"]);
  XCTAssertTrue([mediaFile.album isEqualToString:@"album"]);
  XCTAssertEqual(0, mediaFile.playbackPosition);
}

- (void)testStart {
  XMMMediaFile *mediaFile = [[XMMMediaFile alloc]
                             initWithPlaybackDelegate:_playBackDelegateMock
                             ID:@"0" url:_url
                             title:@"title" artist:@"artist" album:@"album"];
  
  [mediaFile start];
  
  OCMVerify([_playBackDelegateMock playFileAt:@"0"]);
}

- (void)testPause {
  XMMMediaFile *mediaFile = [[XMMMediaFile alloc]
                             initWithPlaybackDelegate:_playBackDelegateMock
                             ID:@"0" url:_url
                             title:@"title" artist:@"artist" album:@"album"];
  
  [mediaFile pause];
  
  OCMVerify([_playBackDelegateMock pauseFileAt:@"0"]);
}

- (void)testStop {
  XMMMediaFile *mediaFile = [[XMMMediaFile alloc]
                             initWithPlaybackDelegate:_playBackDelegateMock
                             ID:@"0" url:_url
                             title:@"title" artist:@"artist" album:@"album"];
  
  [mediaFile stop];
  
  OCMVerify([_playBackDelegateMock stopFileAt:@"0"]);
}

- (void)testSeekForward {
  XMMMediaFile *mediaFile = [[XMMMediaFile alloc]
                             initWithPlaybackDelegate:_playBackDelegateMock
                             ID:@"0" url:_url
                             title:@"title" artist:@"artist" album:@"album"];
  
  [mediaFile seekForward:10];
  
  OCMVerify([_playBackDelegateMock seekForwardFileAt:@"0" time:10]);
}

- (void)testSeekBackward {
  XMMMediaFile *mediaFile = [[XMMMediaFile alloc]
                             initWithPlaybackDelegate:_playBackDelegateMock
                             ID:@"0" url:_url
                             title:@"title" artist:@"artist" album:@"album"];
  
  [mediaFile seekBackward:10];
  
  OCMVerify([_playBackDelegateMock seekBackwardFileAt:@"0" time:10]);
}

- (void)testDelegate {
  XMMMediaFile *mediaFile = [[XMMMediaFile alloc]
                             initWithPlaybackDelegate:_playBackDelegateMock
                             ID:@"0" url:_url
                             title:@"title" artist:@"artist" album:@"album"];
  mediaFile.delegate = _mockMediaFileDelegate;
  
  [mediaFile didStart];
  [mediaFile didPause];
  [mediaFile didStop];
  [mediaFile didUpdatePlaybackPosition:100];
  
  OCMVerify([_mockMediaFileDelegate didStart]);
  OCMVerify([_mockMediaFileDelegate didPause]);
  OCMVerify([_mockMediaFileDelegate didStop]);
  OCMVerify([_mockMediaFileDelegate didUpdatePlaybackPosition:100]);
  XCTAssertEqual(100, mediaFile.playbackPosition);
}

@end
