//
//  XMMContentBlock2TableViewCellTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 17/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "XMMContentBlock2TableViewCell.h"

@interface XMMContentBlock2TableViewCellTest : XCTestCase

@end

@implementation XMMContentBlock2TableViewCellTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testYoutubeNormal {
  XMMContentBlock2TableViewCell *cell = [[XMMContentBlock2TableViewCell alloc] init];
  UIWebView *mockWebview = OCMClassMock(UIWebView.class);
  cell.webView = mockWebview;
  
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.videoUrl = @"https://www.youtube.com/watch?v=dtm_tIkEbMc";
  
  [cell configureForCell:block tableView:nil indexPath:nil style:nil offline:NO];
  
  OCMVerify([mockWebview loadHTMLString:[OCMArg isEqual:@"<style>html, body {margin: 0;padding:0;}</style><iframe width=\"100%\" height=\"100%\" src=\"https://www.youtube.com/embed/dtm_tIkEbMc?start=0\" frameborder=\"0\" allowfullscreen></iframe>"] baseURL:[OCMArg isNil]]);
}

- (void)testYoutubeShort {
  XMMContentBlock2TableViewCell *cell = [[XMMContentBlock2TableViewCell alloc] init];
  UIWebView *mockWebview = OCMClassMock(UIWebView.class);
  cell.webView = mockWebview;
  
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.videoUrl = @"https://youtu.be/-drQtUAya00";
  
  [cell configureForCell:block tableView:nil indexPath:nil style:nil offline:NO];

  OCMVerify([mockWebview loadHTMLString:[OCMArg isEqual:@"<style>html, body {margin: 0;padding:0;}</style><iframe width=\"100%\" height=\"100%\" src=\"https://www.youtube.com/embed/-drQtUAya00?start=0\" frameborder=\"0\" allowfullscreen></iframe>"] baseURL:[OCMArg isNil]]);
}



- (void)testYoutubeWithTimestampSeconds {
  XMMContentBlock2TableViewCell *cell = [[XMMContentBlock2TableViewCell alloc] init];
  UIWebView *mockWebview = OCMClassMock(UIWebView.class);
  cell.webView = mockWebview;
  
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.videoUrl = @"https://youtu.be/-drQtUAya00?t=103";
  
  [cell configureForCell:block tableView:nil indexPath:nil style:nil offline:NO];
  
  OCMVerify([mockWebview loadHTMLString:[OCMArg isEqual:@"<style>html, body {margin: 0;padding:0;}</style><iframe width=\"100%\" height=\"100%\" src=\"https://www.youtube.com/embed/-drQtUAya00?start=103\" frameborder=\"0\" allowfullscreen></iframe>"] baseURL:[OCMArg isNil]]);
}

- (void)testYoutubeWithTimestampHoursMinutesSeconds {
  XMMContentBlock2TableViewCell *cell = [[XMMContentBlock2TableViewCell alloc] init];
  UIWebView *mockWebview = OCMClassMock(UIWebView.class);
  cell.webView = mockWebview;
  
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.videoUrl = @"https://youtu.be/-drQtUAya00?t=1h03m1s";
  
  [cell configureForCell:block tableView:nil indexPath:nil style:nil offline:NO];
  
  OCMVerify([mockWebview loadHTMLString:[OCMArg isEqual:@"<style>html, body {margin: 0;padding:0;}</style><iframe width=\"100%\" height=\"100%\" src=\"https://www.youtube.com/embed/-drQtUAya00?start=3781\" frameborder=\"0\" allowfullscreen></iframe>"] baseURL:[OCMArg isNil]]);
}

- (void)testYoutubeWithTimestampInvalid {
  XMMContentBlock2TableViewCell *cell = [[XMMContentBlock2TableViewCell alloc] init];
  UIWebView *mockWebview = OCMClassMock(UIWebView.class);
  cell.webView = mockWebview;
  
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.videoUrl = @"https://youtu.be/-drQtUAya00?t=letscrash";
  
  [cell configureForCell:block tableView:nil indexPath:nil style:nil offline:NO];
  
  OCMVerify([mockWebview loadHTMLString:[OCMArg isEqual:@"<style>html, body {margin: 0;padding:0;}</style><iframe width=\"100%\" height=\"100%\" src=\"https://www.youtube.com/embed/-drQtUAya00?start=0\" frameborder=\"0\" allowfullscreen></iframe>"] baseURL:[OCMArg isNil]]);
}

- (void)testIfOfflineCallsFileManager {
  XMMContentBlock2TableViewCell *cell = [[XMMContentBlock2TableViewCell alloc] init];
  
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.videoUrl = @"www.xamoom.com/video.mp4";
  
  XMMOfflineFileManager *mockedFileManager = OCMClassMock([XMMOfflineFileManager class]);
  cell.fileManager = mockedFileManager;
  
  OCMStub([mockedFileManager urlForSavedData:[OCMArg any]]).andReturn([NSURL URLWithString:block.videoUrl]);
  
  [cell configureForCell:block tableView:nil indexPath:nil style:nil offline:YES];
 
  OCMVerify([mockedFileManager urlForSavedData:[OCMArg isEqual:block.videoUrl]]);
}

@end
