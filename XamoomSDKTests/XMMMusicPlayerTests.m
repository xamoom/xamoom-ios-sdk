//
//  XMMMusicPlayerTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 25/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XMMMusicPlayer.h"

@interface XMMMusicPlayerTests : XCTestCase

@end

@implementation XMMMusicPlayerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReturnWhenAlreadyHavingAVPlayer {
  XMMMusicPlayer *musicPlayer = [[XMMMusicPlayer alloc] initWithFrame:CGRectZero];
  AVPlayer *player = (AVPlayer *)OCMClassMock([AVPlayer class]);
  musicPlayer.audioPlayer = player;
  
  [musicPlayer initAudioPlayerWithUrlString:@"www.xamoom.com"];
}

- (void)testPlay {
  XMMMusicPlayer *musicPlayer = [[XMMMusicPlayer alloc] initWithFrame:CGRectZero];
  AVPlayer *player = OCMPartialMock([[AVPlayer alloc] init]);
  musicPlayer.audioPlayer = player;
  
  [musicPlayer play];

  OCMVerify([player play]);
}

- (void)testPause {
  XMMMusicPlayer *musicPlayer = [[XMMMusicPlayer alloc] initWithFrame:CGRectZero];
  AVPlayer *player = OCMPartialMock([[AVPlayer alloc] init]);
  musicPlayer.audioPlayer = player;
  
  [musicPlayer pause];
  
  OCMVerify([player pause]);
}

@end
