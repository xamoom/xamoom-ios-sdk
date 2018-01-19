//
//  XMMAudioManagerTest.m
//  XamoomSDKTests
//
//  Created by Raphael Seher on 18.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMAudioManager.h"

@interface XMMAudioManagerTest : XCTestCase

@end

@implementation XMMAudioManagerTest

- (void)setUp {
    [super setUp];
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



@end
