//
//  XMMEnduserApiIntegrationTest.m
//  xamoom-ios-sdk
//
//  Created by Raphael Seher on 02.12.15.
//  Copyright © 2015 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XMMEnduserApi.h>

/**
 *  Needs internet connection. Needs xamoom cloud backend.
 */
@interface XMMEnduserApiIntegrationTest : XCTestCase

@property (nonatomic, strong) NSString *apikey;
@property (nonatomic, strong) NSString *contentId;

@end

@implementation XMMEnduserApiIntegrationTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  
  NSString *path = [[NSBundle bundleForClass:[XMMEnduserApiIntegrationTest class]] pathForResource:@"TestingIDs" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];

  self.apikey = [dict objectForKey:@"apikey"];
  self.contentId = [dict objectForKey:@"contentId"];
  
  [[XMMEnduserApi sharedInstance] setApiKey:self.apikey];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testThatContentWithContentIdReturnsAllSetProperties {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId
                                          includeStyle:NO
                                           includeMenu:NO
                                          withLanguage:nil
                                                  full:NO
                                            completion:^(XMMContentById *result) {
                                              XCTAssertNotNil(result);
                                              XCTAssertNotNil(result.content.contentId);
                                              XCTAssertNotNil(result.content.imagePublicUrl);
                                              XCTAssertNotNil(result.content.descriptionOfContent);
                                              XCTAssertNotNil(result.content.language);
                                              XCTAssertNotNil(result.content.title);
                                              XCTAssertNotNil(result.content.contentBlocks);
                                              XCTAssertNotNil(result.content.category);
                                              
                                              [expectation fulfill];
                                            } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatSpotMapWithTagsReturnsAllSetProperties {
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] spotMapWithMapTags:@[@"spot1"]
                                        withLanguage:nil
                                          completion:^(XMMSpotMap *result) {
                                            XMMSpot *spot = result.items.firstObject;
                                            XCTAssertNotNil(spot.displayName);
                                            XCTAssertNotNil(spot.descriptionOfSpot);
                                            XCTAssertNotNil([NSNumber numberWithFloat:spot.lat]);
                                            XCTAssertNotNil([NSNumber numberWithFloat:spot.lon]);
                                            XCTAssertNotNil(spot.image);
                                            XCTAssertNotNil(spot.category);
                                            
                                            [expectation fulfill];
                                          }
                                               error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

@end
