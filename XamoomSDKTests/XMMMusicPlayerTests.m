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

@property id mockDelegate;

@end

@implementation XMMMusicPlayerTests

- (void)setUp {
    [super setUp];
  _mockDelegate = OCMProtocolMock(@protocol(XMMMusicPlayerDelegate));
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInit {
  XMMMusicPlayer *musicPlayer = [[XMMMusicPlayer alloc] init];
  
  XCTAssertNotNil(musicPlayer);
}

- (void)testPrepareWithUrl {
  NSURL *url = [[NSURL alloc] initWithString:@"www.xamoom.com"];
  XMMMusicPlayer *musicPlayer = [[XMMMusicPlayer alloc] init];
  musicPlayer.delegate = _mockDelegate;
  
  [musicPlayer prepareWith:url];
  
  OCMVerify([_mockDelegate didLoadAsset:[OCMArg any]]);
}

@end
