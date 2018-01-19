//
//  MediaFileTest.m
//  XamoomSDKTests
//
//  Created by Raphael Seher on 18.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMMediaFile.h"

@interface XMMMediaFileTest : XCTestCase

@end

@implementation XMMMediaFileTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
  NSURL *url = [NSURL URLWithString:@"www.xamoom.com"];
  
  XMMMediaFile *mediaFile = [[XMMMediaFile alloc] initWithPosition:0 url:url title:@"title" artist:@"artist" album:@"album"];
  
  XCTAssertEqual(0, mediaFile.position);
  XCTAssertEqual(url, mediaFile.url);
  XCTAssertTrue([mediaFile.title isEqualToString:@"title"]);
  XCTAssertTrue([mediaFile.artist isEqualToString:@"artist"]);
  XCTAssertTrue([mediaFile.album isEqualToString:@"album"]);
}

@end
