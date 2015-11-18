//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <xamoom-ios-sdk/XMMEnduserApi.h>
#import <xamoom-ios-sdk/XMMContentBlocks.h>

float const kTimeWaiting = 3.0;

@interface xamoom_ios_sdk_testTests : XCTestCase
{
  BOOL done;
}

@property XMMEnduserApi *api;
@property XMMContentById *apiResultGetContentById;
@property XMMContentByLocationIdentifier *apiResultGetByLocationIdentifier;
@property XMMContentByLocation *apiResultGetByLocation;
@property XMMSpotMap *apiResultGetSpotMap;
@property XMMContentList *apiResultGetContentList;
@property XMMClosestSpot *apiResultClosestSpot;
@property XMMContentBlocks *contentBlocks;
@property NSArray* fetchResult;
@property NSString* qrScanResult;

@property NSString * contentId;
@property NSString * qrId;
@property NSString * nfcId;
@property NSString * major;
@property NSString * minor;

@end

@implementation xamoom_ios_sdk_testTests

- (void)setUp {
  NSLog(@"Test Suite - setUp");
  
  //reset variables
  done = NO;
  
  NSString* path = [[NSBundle mainBundle] pathForResource:@"TestLogins"
                                                   ofType:@"plist"];
  
  NSDictionary* testLogins = [NSDictionary dictionaryWithContentsOfFile:path];
  
  NSString *apikey = [testLogins valueForKey:@"apikey"];
  
  self.contentId = [testLogins valueForKey:@"contentId"];
  self.qrId = [testLogins valueForKey:@"qrMarker"];
  self.nfcId = [testLogins valueForKey:@"nfcMarker"];
  self.major = [testLogins valueForKey:@"beaconId2"];
  self.minor = [testLogins valueForKey:@"beaconId3"];
  
  [[XMMEnduserApi sharedInstance] setApiKey:apikey];
}

- (void)tearDown {
  [super tearDown];
  
  self.api = nil;
  self.apiResultGetContentById = nil;
  self.apiResultGetByLocationIdentifier = nil;
  self.apiResultGetByLocation = nil;
  self.apiResultGetSpotMap = nil;
  self.apiResultGetContentList = nil;
  self.fetchResult = nil;
  self.apiResultClosestSpot = nil;
  self.contentBlocks = nil;
}

#pragma mark - Tests

- (void)testSystemLanguage {
  NSLog(@"Test Suite - testSystemLanguage");
  
  XCTAssertNotNil([XMMEnduserApi sharedInstance].systemLanguage, @"api.systemLanguage should not be nil");
}

#pragma mark API request tests

- (void)testGetContentByIdFullFull {
  NSLog(@"Test Suite - testGetContentByIdFull");
  [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId includeStyle:YES includeMenu:YES withLanguage:@"de" full:YES completion:^(XMMContentById *result) {
    self.apiResultGetContentById = result;
    done = YES;
  } error:^(XMMError *error) {
    
  }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdFullFullWithoutLanguage {
  NSLog(@"Test Suite - testGetContentByIdFull");
  [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId includeStyle:YES includeMenu:YES withLanguage:@"" full:YES completion:^(XMMContentById *result) {
    self.apiResultGetContentById = result;
    done = YES;
  } error:^(XMMError *error) {
    
  }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdFullFullWitLanguageNil {
  NSLog(@"Test Suite - testGetContentByIdFull");
  [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId includeStyle:YES includeMenu:YES withLanguage:nil full:YES completion:^(XMMContentById *result) {
    self.apiResultGetContentById = result;
    done = YES;
  } error:^(XMMError *error) {
    
  }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

//LocationIdentifier

- (void)testGetContentByLocationIdentifierFull {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierFull");
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.qrId majorId:nil includeStyle:YES includeMenu:YES withLanguage:@"de" completion:^(XMMContentByLocationIdentifier *result) {
    self.apiResultGetByLocationIdentifier = result;
    done = YES;
  } error:^(XMMError *error) {
    
  }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithoutStyle {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithoutStyle");
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.qrId majorId:nil includeStyle:NO includeMenu:YES withLanguage:@"de"
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       self.apiResultGetByLocationIdentifier = result;
                                                       done = YES;
                                                     } error:^(XMMError *error) {
                                                       
                                                     }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithoutMenu {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithoutMenu");
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.qrId majorId:nil includeStyle:YES includeMenu:NO withLanguage:@"de"
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       self.apiResultGetByLocationIdentifier = result;
                                                       done = YES;
                                                     } error:^(XMMError *error) {
                                                       
                                                     }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithoutStyleAndMenu {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithoutStyleAndMenu");
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.qrId majorId:nil includeStyle:NO includeMenu:NO withLanguage:@"de"
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       self.apiResultGetByLocationIdentifier = result;
                                                       done = YES;
                                                     } error:^(XMMError *error) {
                                                       done = YES;
                                                     }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithEnglishLanguage {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithEnglishLanguage");
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.qrId majorId:nil includeStyle:YES includeMenu:YES withLanguage:@"en"
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       self.apiResultGetByLocationIdentifier = result;
                                                       done = YES;
                                                     } error:^(XMMError *error) {
                                                       
                                                     }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithBeacon {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithEnglishLanguage");
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:self.minor majorId:self.major includeStyle:YES includeMenu:YES withLanguage:@"en"
                                                     completion:^(XMMContentByLocationIdentifier *result) {
                                                       self.apiResultGetByLocationIdentifier = result;
                                                       done = YES;
                                                     } error:^(XMMError *error) {
                                                       
                                                     }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

//location

- (void)testGetContentByLocationFull {
  NSLog(@"Test Suite - testGetContentByLocationFull");
  [[XMMEnduserApi sharedInstance] contentWithLat:@"46.615" withLon:@"14.263" withLanguage:@"de"
                                      completion:^(XMMContentByLocation *result) {
                                        self.apiResultGetByLocation = result;
                                        done = YES;
                                      } error:^(XMMError *error) {
                                        
                                      }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocation, @"getContentByLocation should return something");
}

- (void)testGetContentByLocationWithEnglishLanguage {
  NSLog(@"Test Suite - testGetContentByLocationWithEnglishLanguage");
  [[XMMEnduserApi sharedInstance] contentWithLat:@"46.615" withLon:@"14.263" withLanguage:@"en"
                                      completion:^(XMMContentByLocation *result) {
                                        self.apiResultGetByLocation = result;
                                        done = YES;
                                      } error:^(XMMError *error) {
                                        
                                      }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocation, @"getContentByLocation should return something");
}

//spotMap

- (void)testGetSpotMapFull {
  NSLog(@"Test Suite - testGetSpotMapFull");
  [[XMMEnduserApi sharedInstance] spotMapWithMapTags:@[@"spot1"] withLanguage:@"de"
                                          completion:^(XMMSpotMap *result) {
                                            self.apiResultGetSpotMap = result;
                                            done = YES;
                                          } error:^(XMMError *error) {
                                            
                                          }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetSpotMap, @"getSpotMap should return something");
}

- (void)testGetSpotMapWithEnglishLanguage {
  NSLog(@"Test Suite - testGetSpotMapWithEnglishLanguage");
  [[XMMEnduserApi sharedInstance] spotMapWithMapTags:@[@"stw"] withLanguage:@"en"
                                          completion:^(XMMSpotMap *result) {
                                            self.apiResultGetSpotMap = result;
                                            done = YES;
                                          } error:^(XMMError *error) {
                                            
                                          }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetSpotMap, @"getSpotMap should return something");
}

- (void)testGetSpotMapUmlaut {
  NSLog(@"Test Suite - testGetSpotMapWithEnglishLanguage");
  [[XMMEnduserApi sharedInstance] spotMapWithMapTags:@[@"Wörthersee"] withLanguage:@"en"
                                          completion:^(XMMSpotMap *result) {
                                            self.apiResultGetSpotMap = result;
                                            done = YES;
                                          } error:^(XMMError *error) {
                                            
                                          }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetSpotMap, @"getSpotMap should return something");
}


//contentList

- (void)testGetContentListFromApi {
  NSLog(@"Test Suite - testGetContentListFromApi");
  [[XMMEnduserApi sharedInstance] contentListWithPageSize:5 withLanguage:@"de" withCursor:@"null" withTags:@[@"spot1"]
                                               completion:^(XMMContentList *result) {
                                                 self.apiResultGetContentList = result;
                                                 done = YES;
                                               } error:^(XMMError *error) {
                                                 
                                               }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentList, @"getContentList should return something");
}

- (void)testGetContentListFromApiUmlaut {
  NSLog(@"Test Suite - testGetContentListFromApi");
  [[XMMEnduserApi sharedInstance] contentListWithPageSize:5 withLanguage:@"de" withCursor:@"null" withTags:@[@"Wörthersee"]
                                               completion:^(XMMContentList *result) {
                                                 self.apiResultGetContentList = result;
                                                 done = YES;
                                               } error:^(XMMError *error) {
                                                 
                                               }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentList, @"getContentList should return something");
}

//closestSpots

- (void)testClosestSpotsFromApi {
  NSLog(@"Test Suite - testClosestSpotsFromApi");
  [[XMMEnduserApi sharedInstance] closestSpotsWithLat:46.615 withLon:14.263 withRadius:1000 withLimit:5 withLanguage:@"de"
                                           completion:^(XMMClosestSpot *result) {
                                             self.apiResultClosestSpot = result;
                                             done = YES;
                                           } error:^(XMMError *error) {
                                             
                                           }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultClosestSpot, @"getContentList should return something");
}

#pragma mark - XMMContentBlocks Tests
//write some tests

#pragma mark - Helping methods
- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs {
  NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
  
  do {
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
    if([timeoutDate timeIntervalSinceNow] < 0.0)
      break;
  } while (!done);
  
  return done;
}

#pragma mark - Perfomance Test
/*
 - (void)testPerformanceExample {
 // This is an example of a performance test case.
 [self measureBlock:^{
 // Put the code you want to measure the time of here.
 }];
 }
 */

@end
