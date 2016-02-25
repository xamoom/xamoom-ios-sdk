//
//  APIIntegrationTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 25/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMEnduserApi.h"

@interface APIIntegrationTests : XCTestCase

@property XMMEnduserApi *api;
@property NSString* contentID;
@property NSString* qrMarker;
@property double timeout;

@end

@implementation APIIntegrationTests

- (void)setUp {
  [super setUp];
  self.timeout = 2.0;
  
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestingIDs" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
  NSString *apikey = [dict objectForKey:@"APIKEY"];
  NSString *devkey = [dict objectForKey:@"X-DEVKEY"];
  
  NSDictionary *httpHeaders = @{@"Content-Type":@"application/vnd.api+json",
                                @"User-Agent":@"XamoomSDK iOS",
                                @"APIKEY":apikey,
                                @"X-DEVKEY":devkey};
  
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:httpHeaders];
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:@"https://xamoom-cloud-dev.appspot.com/_api/v2/consumer/"] session:[NSURLSession sessionWithConfiguration:config]];
  
  self.api = [[XMMEnduserApi alloc] initWithRestClient:restClient];
  
  self.contentID = [dict objectForKey:@"contentID"];
  self.qrMarker = [dict objectForKey:@"qrMarker"];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testContentWithID {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  NSArray *tags = [NSArray arrayWithObjects:@"tag1", @"tag2", @"tag3", nil];
  
  [self.api contentWithID:self.contentID completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertNil(error);
    
    //content
    XCTAssertTrue([content.title isEqualToString:@"DO NOT TOUCH | APP | Testsite 1"]);
    XCTAssertTrue([content.contentDescription isEqualToString:@"Test"]);
    XCTAssertTrue([content.language isEqualToString:@"de"]);
    XCTAssertNotNil(content.imagePublicUrl);
    XCTAssertTrue([content.tags isEqualToArray:tags]);
    XCTAssertTrue(content.category == 0);
    
    //system
    XCTAssertTrue([content.system.ID isEqualToString:@"5755996320301056"]);
    
    //blocks
    //text
    XMMContentBlock *block = [content.contentBlocks objectAtIndex:0];
    XCTAssertTrue([block.title isEqualToString:@"Test"]);
    XCTAssertTrue([block.text isEqualToString:@"<p>Test</p>"]);
    XCTAssertTrue(block.publicStatus);
    XCTAssertTrue(block.blockType == 0);
    
    //audio
    block = [content.contentBlocks objectAtIndex:1];
    XCTAssertTrue([block.title isEqualToString:@"Test"]);
    XCTAssertTrue([block.artists isEqualToString:@"Test"]);
    XCTAssertTrue(block.publicStatus);
    XCTAssertTrue(block.blockType == 1);
    XCTAssertTrue([block.fileID isEqualToString:@"https://storage.googleapis.com/xamoom-files-dev/612f64221fd34ac283cb1c5ecc4c18f8.mp3"]);
    
    //soundcloud
    block = [content.contentBlocks objectAtIndex:2];
    XCTAssertTrue([block.title isEqualToString:@"Test"]);
    XCTAssertTrue(block.publicStatus);
    XCTAssertTrue(block.blockType == 7);
    XCTAssertTrue([block.soundcloudUrl isEqualToString:@"https://soundcloud.com/lukasgraham/7-years"]);
    
    //youtube
    block = [content.contentBlocks objectAtIndex:3];
    XCTAssertTrue([block.title isEqualToString:@"Test"]);
    XCTAssertTrue(block.publicStatus);
    XCTAssertTrue(block.blockType == 2);
    XCTAssertTrue([block.videoUrl isEqualToString:@"https://www.youtube.com/watch?v=IxwU-h_h8Ls"]);
    
    //link
    block = [content.contentBlocks objectAtIndex:4];
    XCTAssertTrue([block.title isEqualToString:@"Test"]);
    XCTAssertTrue([block.text isEqualToString:@"Test"]);
    XCTAssertTrue(block.publicStatus);
    XCTAssertTrue(block.blockType == 4);
    XCTAssertTrue(block.linkType == 3);
    XCTAssertTrue([block.linkUrl isEqualToString:@"http://www.xamoom.com"]);
    
    //image
    block = [content.contentBlocks objectAtIndex:5];
    XCTAssertTrue([block.title isEqualToString:@"Test"]);
    XCTAssertTrue([block.altText isEqualToString:@"Test"]);
    XCTAssertTrue(block.publicStatus);
    XCTAssertTrue(block.scaleX == 100);
    XCTAssertTrue(block.blockType == 3);
    XCTAssertTrue([block.fileID isEqualToString:@"https://storage.googleapis.com/xamoom-files-dev/mobile/e7f670906b464ea58352d90d3c4674fa.jpg"]);
    XCTAssertTrue([block.linkUrl isEqualToString:@"http://www.xamoom.com"]);
    
    //ebook
    block = [content.contentBlocks objectAtIndex:6];
    XCTAssertTrue([block.title isEqualToString:@"Test"]);
    XCTAssertTrue([block.artists isEqualToString:@"Test"]);
    XCTAssertTrue(block.publicStatus);
    XCTAssertTrue(block.blockType == 5);
    XCTAssertTrue([block.fileID isEqualToString:@"https://storage.googleapis.com/xamoom-files-dev/c4970ddbcb9b471da3c15ed7b0087bff.epub"]);
    
    //content
    block = [content.contentBlocks objectAtIndex:7];
    XCTAssertTrue(block.publicStatus);
    XCTAssertTrue(block.blockType == 6);
    XCTAssertTrue([block.contentID isEqualToString:@"e5be72be162d44b189893a406aff5227"]);
    
    //download
    block = [content.contentBlocks objectAtIndex:8];
    XCTAssertTrue([block.title isEqualToString:@"Test"]);
    XCTAssertTrue([block.text isEqualToString:@"Test"]);
    XCTAssertTrue(block.publicStatus);
    XCTAssertTrue(block.blockType == 8);
    XCTAssertTrue(block.downloadType == 0);
    XCTAssertTrue([block.fileID isEqualToString:@"https://storage.googleapis.com/xamoom-files-dev/108bfa6dd489437fb1f5c0613e457b53.vcf"]);
    
    //spotMap
    block = [content.contentBlocks objectAtIndex:9];
    XCTAssertTrue([block.title isEqualToString:@"Test"]);
    XCTAssertTrue(block.publicStatus);
    XCTAssertTrue(block.blockType == 9);
    XCTAssertTrue([block.spotMapTags isEqualToArray:[NSArray arrayWithObject:@"spot1"]]);
    XCTAssertTrue(block.showContent);
    
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentWithLocationIdentifier {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [self.api contentWithLocationIdentifier:self.qrMarker completion:^(XMMContent *content, NSError *error) {
    XCTAssertTrue([content.title isEqualToString:@"DO NOT TOUCH | APP | Testsite 1"]);
    
    [expectation fulfill];
  }];

  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentWithBeacon {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [self.api contentWithBeaconMajor:@54222 minor:@24265 completion:^(XMMContent *content, NSError *error) {
    XCTAssertTrue([content.title isEqualToString:@"DO NOT TOUCH | APP | Testsite 1"]);
    
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSpotsWithTag {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  NSArray *tags = [NSArray arrayWithObjects:@"Spot1", @"tag1", @"donottouchspot", nil];
  
  [self.api spotsWithTags:@[@"donottouchspot"] options:0 completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XMMSpot *spot = [spots firstObject];
    XCTAssertTrue([spot.name isEqualToString:@"DO NOT TOUCH | APP | Spot 1"]);
    XCTAssertTrue([spot.spotDescription isEqualToString:@"Test"]);

    XCTAssertNotNil(spot.image);
    XCTAssertTrue(spot.latitude == 46.61506789671181);
    XCTAssertTrue(spot.longitude == 14.2622709274292);
    XCTAssertTrue([spot.tags isEqualToArray:tags]);
    XCTAssertTrue([spot.system.ID isEqualToString:@"5755996320301056"]);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystem {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [self.api systemWithCompletion:^(XMMSystem *system, NSError *error) {
    
    [expectation fulfill];
  }];

  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystemSettings {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [self.api systemSettingsWithID:@"5755996320301056" completion:^(XMMSystemSettings *settings, NSError *error) {
    
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testStyle {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [self.api styleWithID:@"5755996320301056" completion:^(XMMStyle *style, NSError *error) {
    
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testMenu {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [self.api menuWithID:@"5755996320301056" completion:^(XMMMenu *menu, NSError *error) {
    
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


@end
