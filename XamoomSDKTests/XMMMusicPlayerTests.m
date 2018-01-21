//
//  XMMMusicPlayerTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 25/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <AVFoundation/AVFoundation.h>
#import "XMMMusicPlayer.h"

@interface XMMMusicPlayerTests : XCTestCase

@property id mockDelegate;
@property AVPlayer *mockPlayer;

@end

@implementation XMMMusicPlayerTests

- (void)setUp {
    [super setUp];
  _mockDelegate = OCMProtocolMock(@protocol(XMMMusicPlayerDelegate));
  _mockPlayer = OCMClassMock([AVPlayer class]);
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInit {
  XMMMusicPlayer *musicPlayer = [[XMMMusicPlayer alloc] init];
  
  XCTAssertNotNil(musicPlayer);
}

- (void)testPrepareWithUrl {
  NSURL *url = [[NSURL alloc] initWithString:@"https://storage.googleapis.com/xamoom-files-dev/93b258c0c2d543759471cec6f102118d.mp3"];
  XMMMusicPlayer *musicPlayer = [[XMMMusicPlayer alloc] initWith:_mockPlayer];
  musicPlayer.delegate = _mockDelegate;
  
  [musicPlayer prepareWith:url];
  [musicPlayer observeValueForKeyPath:@"status"
                             ofObject:_mockPlayer
                               change:nil context:nil];
  
  OCMVerify([_mockPlayer replaceCurrentItemWithPlayerItem:[OCMArg any]]);
}

- (void)testPlay {
  XMMMusicPlayer *musicPlayer = [[XMMMusicPlayer alloc] initWith:_mockPlayer];

  [musicPlayer play];
  
  OCMVerify([_mockPlayer play]);
}

- (void)testPause {
  XMMMusicPlayer *musicPlayer = [[XMMMusicPlayer alloc] initWith:_mockPlayer];
  
  [musicPlayer pause];
  
  OCMVerify([_mockPlayer pause]);
}

- (void)testSeekForward {
  XMMMusicPlayer *musicPlayer = [[XMMMusicPlayer alloc] initWith:_mockPlayer];
  OCMExpect([_mockPlayer currentTime]).andReturn(CMTimeMake(0, 100));
  AVPlayerItem *item = OCMClassMock([AVPlayerItem class]);
  OCMExpect([item duration]).andReturn(CMTimeMake(50, 100));
  OCMExpect([_mockPlayer currentItem]).andReturn(item);

  [musicPlayer forward:30];
  
  OCMVerify([_mockPlayer seekToTime:CMTimeMake(0, 0)]);
}

- (void)testSeekBackward {
  XMMMusicPlayer *musicPlayer = [[XMMMusicPlayer alloc] initWith:_mockPlayer];
  
  [musicPlayer backward:30];
  
  OCMVerify([_mockPlayer seekToTime:CMTimeMake(0, 0)]);
}

@end
