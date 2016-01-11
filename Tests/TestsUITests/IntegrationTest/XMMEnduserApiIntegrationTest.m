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
@property (nonatomic, strong) NSString *qrMarkerId;
@property (nonatomic, strong) NSString *nfcMarkerId;
@property (nonatomic, strong) NSString *beaconId2;
@property (nonatomic, strong) NSString *beaconId3;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lon;

@end

@implementation XMMEnduserApiIntegrationTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  
  NSString *path = [[NSBundle bundleForClass:[XMMEnduserApiIntegrationTest class]] pathForResource:@"TestingIDs" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
  
  self.apikey = [dict objectForKey:@"apikey"];
  self.contentId = [dict objectForKey:@"contentId"];
  self.qrMarkerId = [dict objectForKey:@"qrMarker"];
  self.nfcMarkerId = [dict objectForKey:@"nfcMarker"];
  self.beaconId2 = [dict objectForKey:@"beaconId2"];
  self.beaconId3 = [dict objectForKey:@"beaconId3"];
  self.lat = @"46.6152274";
  self.lon = @"14.2622597";
  
  [[XMMEnduserApi sharedInstance] setApiKey:self.apikey];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

#pragma mark - Test Properties

- (void)testThatContentWithContentIdReturnsAllSetProperties {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId
                                          includeStyle:YES
                                           includeMenu:YES
                                          withLanguage:nil
                                                  full:YES
                                               preview:NO
                                            completion:^(XMMContentById *result) {
                                              XCTAssertNotNil(result);
                                              XCTAssertNotNil(result.systemName);
                                              XCTAssertNotNil(result.systemUrl);
                                              XCTAssertNotNil(result.systemId);
                                              XCTAssertNotNil(result.menu);
                                              XCTAssertNotNil(result.style);
                                              XCTAssertNotNil(result.content);
                                              
                                              XCTAssertTrue([result.content.title isEqualToString:@"APP | Testing Hub"]);
                                              XCTAssertTrue([result.content.contentId isEqualToString:self.contentId]);
                                              XCTAssertNotNil(result.content.imagePublicUrl);
                                              XCTAssertTrue([result.content.language isEqualToString:@"de"]);
                                              XCTAssertTrue([result.content.descriptionOfContent isEqualToString:@"Testing Hub excerpt."]);
                                              XCTAssertTrue(result.content.contentBlocks.count == 10);
                                              XCTAssertTrue(result.content.category.intValue == 58);
                                              
                                              [expectation fulfill];
                                            } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentWithLocationIdentifierQRReturnsAllSetProperties {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.qrMarkerId
                                                        majorId:nil
                                                   includeStyle:YES
                                                    includeMenu:YES
                                                   withLanguage:nil
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       XCTAssertNotNil(result);
                                                       XCTAssertNotNil(result.systemName);
                                                       XCTAssertNotNil(result.systemUrl);
                                                       XCTAssertNotNil(result.systemId);
                                                       XCTAssertNotNil(result.menu);
                                                       XCTAssertNotNil(result.style);
                                                       XCTAssertNotNil(result.content);
                                                       XCTAssertTrue(result.hasSpot);
                                                       XCTAssertTrue(result.hasContent);
                                                       
                                                       XCTAssertTrue([result.content.title isEqualToString:@"APP | Testing Hub"]);
                                                       XCTAssertTrue([result.content.contentId isEqualToString:self.contentId]);
                                                       XCTAssertNotNil(result.content.imagePublicUrl);
                                                       XCTAssertTrue([result.content.language isEqualToString:@"de"]);
                                                       XCTAssertTrue([result.content.descriptionOfContent isEqualToString:@"Testing Hub excerpt."]);
                                                       XCTAssertTrue(result.content.contentBlocks.count == 10);
                                                       XCTAssertTrue(result.content.category.intValue == 58);
                                                       
                                                       [expectation fulfill];
                                                     } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentWithLocationIdentifierNFCReturnsAllSetProperties {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.nfcMarkerId
                                                        majorId:nil
                                                   includeStyle:YES
                                                    includeMenu:YES
                                                   withLanguage:nil
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       XCTAssertNotNil(result);
                                                       XCTAssertNotNil(result.systemName);
                                                       XCTAssertNotNil(result.systemUrl);
                                                       XCTAssertNotNil(result.systemId);
                                                       XCTAssertNotNil(result.menu);
                                                       XCTAssertNotNil(result.style);
                                                       XCTAssertNotNil(result.content);
                                                       XCTAssertTrue(result.hasSpot);
                                                       XCTAssertTrue(result.hasContent);
                                                       
                                                       XCTAssertTrue([result.content.title isEqualToString:@"APP | Testing Hub"]);
                                                       XCTAssertTrue([result.content.contentId isEqualToString:self.contentId]);
                                                       XCTAssertNotNil(result.content.imagePublicUrl);
                                                       XCTAssertTrue([result.content.language isEqualToString:@"de"]);
                                                       XCTAssertTrue([result.content.descriptionOfContent isEqualToString:@"Testing Hub excerpt."]);
                                                       XCTAssertTrue(result.content.contentBlocks.count == 10);
                                                       XCTAssertTrue(result.content.category.intValue == 58);
                                                       
                                                       [expectation fulfill];
                                                     } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentWithLocationIdentifierBeaconReturnsAllSetProperties {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.beaconId3
                                                        majorId:self.beaconId2
                                                   includeStyle:YES
                                                    includeMenu:YES
                                                   withLanguage:nil
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       XCTAssertNotNil(result);
                                                       XCTAssertNotNil(result.systemName);
                                                       XCTAssertNotNil(result.systemUrl);
                                                       XCTAssertNotNil(result.systemId);
                                                       XCTAssertNotNil(result.menu);
                                                       XCTAssertNotNil(result.style);
                                                       XCTAssertNotNil(result.content);
                                                       XCTAssertTrue(result.hasSpot);
                                                       XCTAssertTrue(result.hasContent);
                                                       
                                                       XCTAssertTrue([result.content.title isEqualToString:@"APP | Testing Hub"]);
                                                       XCTAssertTrue([result.content.contentId isEqualToString:self.contentId]);
                                                       XCTAssertNotNil(result.content.imagePublicUrl);
                                                       XCTAssertTrue([result.content.language isEqualToString:@"de"]);
                                                       XCTAssertTrue([result.content.descriptionOfContent isEqualToString:@"Testing Hub excerpt."]);
                                                       XCTAssertTrue(result.content.contentBlocks.count == 10);
                                                       XCTAssertTrue(result.content.category.intValue == 58);
                                                       
                                                       [expectation fulfill];
                                                     } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentWithLatReturnsAllSetProperties {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] contentWithLat:self.lat
                                         withLon:self.lon
                                    withLanguage:nil
                                      completion:^(XMMContentByLocation *result) {
                                        XCTAssertNotNil(result.items);
                                        [expectation fulfill];
                                      } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatSpotMapWithTagsReturnsAllSetProperties {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] spotMapWithMapTags:@[@"spot1"]
                                        withLanguage:nil
                                      includeContent:YES
                                          completion:^(XMMSpotMap *result) {
                                            XMMSpot *spot = result.items.firstObject;
                                            
                                            XCTAssertNotNil(result.style);
                                            
                                            XCTAssertTrue([spot.displayName isEqualToString:@"APP | Spot 1"]);
                                            XCTAssertTrue([spot.descriptionOfSpot isEqualToString:@"Thats the spot excerpt."]);
                                            XCTAssertNotNil([NSNumber numberWithFloat:spot.lat]);
                                            XCTAssertNotNil([NSNumber numberWithFloat:spot.lon]);
                                            XCTAssertNotNil(spot.image);
                                            XCTAssertEqual(spot.category.intValue, 0);
                                            XCTAssertNotNil(spot.contentId);
                                            
                                            [expectation fulfill];
                                          } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentListWithTagsReturnsAllSetProperties {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] contentListWithPageSize:10
                                             withLanguage:nil
                                               withCursor:nil
                                                 withTags:@[@"tests"]
                                               completion:^(XMMContentList *result) {
                                                 XCTAssertNotNil(result.cursor);
                                                 XCTAssertFalse(result.hasMore);
                                                 XCTAssertNotNil(result.items);
                                                 
                                                 [expectation fulfill];
                                               } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatClosestSpotsReturnsAllSetProperties {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] closestSpotsWithLat:self.lat.doubleValue
                                              withLon:self.lon.doubleValue
                                           withRadius:1000
                                            withLimit:10
                                         withLanguage:nil
                                           completion:^(XMMClosestSpot *result) {
                                             XCTAssertNotNil(result.items);
                                             XCTAssertEqual(result.radius, 1000);
                                             XCTAssertEqual(result.limit, 10);
                                             
                                             [expectation fulfill];
                                           } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

#pragma mark - ContentWithId

- (void)testThatContentWithContentIdReturnsContentMenuStyle {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId
                                          includeStyle:YES
                                           includeMenu:YES
                                          withLanguage:nil
                                                  full:YES
                                               preview:NO
                                            completion:^(XMMContentById *result) {
                                              XCTAssertNotNil(result);
                                              XCTAssertNotNil(result.content);
                                              XCTAssertNotNil(result.menu);
                                              XCTAssertNotNil(result.style);
                                              
                                              [expectation fulfill];
                                            } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentWithContentIdReturnsContent {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId
                                          includeStyle:NO
                                           includeMenu:NO
                                          withLanguage:nil
                                                  full:YES
                                               preview:NO
                                            completion:^(XMMContentById *result) {
                                              XCTAssertNotNil(result);
                                              XCTAssertNotNil(result.content);
                                              XCTAssertNil(result.menu);
                                              XCTAssertNil(result.style);
                                              
                                              [expectation fulfill];
                                            } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

#pragma mark - ContentWithLocationIdentifier

- (void)testThatContentWithQRLocationIdentifierReturnsContentMenuStyle {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.qrMarkerId
                                                        majorId:nil
                                                   includeStyle:YES
                                                    includeMenu:YES
                                                   withLanguage:nil
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       XCTAssertNotNil(result);
                                                       XCTAssertNotNil(result.content);
                                                       XCTAssertNotNil(result.menu);
                                                       XCTAssertNotNil(result.style);
                                                       [expectation fulfill];
                                                     } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentWithQRLocationIdentifierReturnsContent {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.qrMarkerId
                                                        majorId:nil
                                                   includeStyle:NO
                                                    includeMenu:NO
                                                   withLanguage:nil
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       XCTAssertNotNil(result);
                                                       XCTAssertNotNil(result.content);
                                                       XCTAssertNil(result.menu);
                                                       XCTAssertNil(result.style);
                                                       [expectation fulfill];
                                                     } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentWithNFCLocationIdentifierReturnsContentMenuStyle {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.nfcMarkerId
                                                        majorId:nil
                                                   includeStyle:YES
                                                    includeMenu:YES
                                                   withLanguage:nil
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       XCTAssertNotNil(result);
                                                       XCTAssertNotNil(result.content);
                                                       XCTAssertNotNil(result.menu);
                                                       XCTAssertNotNil(result.style);
                                                       [expectation fulfill];
                                                     } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentWithNFCLocationIdentifierReturnsContent {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.nfcMarkerId
                                                        majorId:nil
                                                   includeStyle:NO
                                                    includeMenu:NO
                                                   withLanguage:nil
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       XCTAssertNotNil(result);
                                                       XCTAssertNotNil(result.content);
                                                       XCTAssertNil(result.menu);
                                                       XCTAssertNil(result.style);
                                                       [expectation fulfill];
                                                     } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentWithBeaconLocationIdentifierReturnsContentMenuStyle {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.beaconId3
                                                        majorId:self.beaconId2
                                                   includeStyle:YES
                                                    includeMenu:YES
                                                   withLanguage:nil
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       XCTAssertNotNil(result);
                                                       XCTAssertNotNil(result.content);
                                                       XCTAssertNotNil(result.menu);
                                                       XCTAssertNotNil(result.style);
                                                       [expectation fulfill];
                                                     } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentWithBeaconLocationIdentifierReturnsContent {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.beaconId3
                                                        majorId:self.beaconId2
                                                   includeStyle:NO
                                                    includeMenu:NO
                                                   withLanguage:nil
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       XCTAssertNotNil(result);
                                                       XCTAssertNotNil(result.content);
                                                       XCTAssertNil(result.menu);
                                                       XCTAssertNil(result.style);
                                                       [expectation fulfill];
                                                     } error:^(XMMError *error) {
                                                       NSLog(@"Hellyeah: %@", error.message);
                                                     }];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

#pragma mark - ContentWithLat:Lon:

- (void)testThatContentWithLatReturnsContent {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] contentWithLat:self.lat
                                         withLon:self.lon
                                    withLanguage:nil
                                      completion:^(XMMContentByLocation *results) {
                                        XCTAssertNotNil(results);
                                        XMMContent *content = results.items.firstObject;
                                        XCTAssertNotNil(content);
                                        [expectation fulfill];
                                        
                                      } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentWithLatReturnsNoContent {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] contentWithLat:@"48.0673358"
                                         withLon:@"12.8617154"
                                    withLanguage:nil
                                      completion:^(XMMContentByLocation *results) {
                                        XCTAssertNotNil(results);
                                        XCTAssertNil(results.items);
                                        [expectation fulfill];
                                        
                                      } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

#pragma mark - SpotMap

- (void)testThatSpotMapWithTagsReturnsContent {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] spotMapWithMapTags:@[@"spot1"]
                                        withLanguage:nil includeContent:YES completion:^(XMMSpotMap *result) {
                                          XCTAssertNotNil(result);
                                          XCTAssertNotNil(result.items);
                                          XMMSpot *spot = result.items.firstObject;
                                          XCTAssertNotNil(spot);
                                          XCTAssertNotNil(spot.contentId);
                                          [expectation fulfill];
                                        } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatSpotMapWithTagsReturnsNoContent {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] spotMapWithMapTags:@[@"spot1"]
                                        withLanguage:nil includeContent:NO completion:^(XMMSpotMap *result) {
                                          XCTAssertNotNil(result);
                                          XCTAssertNotNil(result.items);
                                          XMMSpot *spot = result.items.firstObject;
                                          XCTAssertNotNil(spot);
                                          XCTAssertNil(spot.contentId);
                                          [expectation fulfill];
                                        } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatSpotMapWithTagsWorksWithUmlaut {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] spotMapWithMapTags:@[@"Wörthersee"]
                                        withLanguage:nil includeContent:YES completion:^(XMMSpotMap *result) {
                                          XCTAssertNotNil(result);
                                          XCTAssertNotNil(result.items);
                                          XMMSpot *spot = result.items.firstObject;
                                          XCTAssertNotNil(spot);
                                          [expectation fulfill];
                                        } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

#pragma mark - contentListWithPageSize

- (void)testThatContentListReturnsList {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] contentListWithPageSize:10
                                             withLanguage:nil
                                               withCursor:nil
                                                 withTags:@[@"tests"]
                                               completion:^(XMMContentList *result) {
                                                 XCTAssertNotNil(result);
                                                 XCTAssertNotNil(result.items);
                                                 XMMContent *content = result.items.firstObject;
                                                 XCTAssertNotNil(content);
                                                 [expectation fulfill];
                                               } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testThatContentListWorksWithUmlauts {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] contentListWithPageSize:10
                                             withLanguage:nil
                                               withCursor:nil
                                                 withTags:@[@"Wörthersee"]
                                               completion:^(XMMContentList *result) {
                                                 XCTAssertNotNil(result);
                                                 XCTAssertNotNil(result.items);
                                                 XMMContent *content = result.items.firstObject;
                                                 XCTAssertNotNil(content);
                                                 [expectation fulfill];
                                               } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

# pragma mark - closestSpotsWithLat:Lon:

- (void)testThatClosestSpotsReturnsSpots {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  
  [[XMMEnduserApi sharedInstance] closestSpotsWithLat:self.lat.doubleValue
                                              withLon:self.lon.doubleValue
                                           withRadius:10000
                                            withLimit:10
                                         withLanguage:nil
                                           completion:^(XMMClosestSpot *result) {
                                             XCTAssertNotNil(result);
                                             XCTAssertNotNil(result.items);
                                             XMMSpot *spot = result.items.firstObject;
                                             XCTAssertNotNil(spot);
                                             [expectation fulfill];
                                           } error:nil];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

@end
