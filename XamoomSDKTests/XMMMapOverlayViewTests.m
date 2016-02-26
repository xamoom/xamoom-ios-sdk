//
//  XMMMapOverlayViewTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 25/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMMapOverlayView.h"

@interface XMMMapOverlayViewTests : XCTestCase

@property XCTestExpectation *expectation;

@end

@implementation XMMMapOverlayViewTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testNoContent {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDKNibs" withExtension:@"bundle"];
  NSBundle *nibBundle = [NSBundle bundleWithURL:url];
  XMMMapOverlayView *view = [[nibBundle loadNibNamed:@"XMMMapOverlayView" owner:self options:nil] firstObject];
  
  XMMAnnotation *annotation = [[XMMAnnotation alloc] init];
  annotation.spot = nil;
  
  [view displayAnnotation:annotation showContent:YES];
  
  XCTAssertNotNil(view);
  XCTAssertTrue(view.openContentButton.hidden);
}

- (void)testDonotShowContent {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDKNibs" withExtension:@"bundle"];
  NSBundle *nibBundle = [NSBundle bundleWithURL:url];
  XMMMapOverlayView *view = [[nibBundle loadNibNamed:@"XMMMapOverlayView" owner:self options:nil] firstObject];
  
  XMMAnnotation *annotation = [[XMMAnnotation alloc] init];
  annotation.spot = [[XMMSpot alloc] init];
  annotation.spot.content.ID = @"123456";
  
  [view displayAnnotation:annotation showContent:NO];
  
  XCTAssertNotNil(view);
  XCTAssertTrue(view.openContentButton.hidden);
}

- (void)testShowContent {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDKNibs" withExtension:@"bundle"];
  NSBundle *nibBundle = [NSBundle bundleWithURL:url];
  XMMMapOverlayView *view = [[nibBundle loadNibNamed:@"XMMMapOverlayView" owner:self options:nil] firstObject];
  
  XMMAnnotation *annotation = [[XMMAnnotation alloc] init];
  annotation.spot = [[XMMSpot alloc] init];
  annotation.spot.content.ID = @"123456";
  
  [view displayAnnotation:annotation showContent:YES];
  
  XCTAssertNotNil(view);
  XCTAssertFalse(view.openContentButton.hidden);
}

@end
