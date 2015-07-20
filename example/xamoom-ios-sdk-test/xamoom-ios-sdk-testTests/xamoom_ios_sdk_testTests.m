//
//  xamoom_ios_sdk_testTests.m
//  xamoom-ios-sdk-testTests
//
//  Created by Raphael Seher on 04.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "XMMEnduserApi.h"

NSString * const kContentId = @"f0da3d3d28d3418e9ccc4a6e9b3493c0";
NSString * const kLocationIdentifier = @"dkriw";
float const kTimeWaiting = 30.0;

@interface xamoom_ios_sdk_testTests : XCTestCase
{
  BOOL done;
}

@property XMMEnduserApi *api;
@property NSMutableArray *apiResultRSS;
@property XMMResponseGetById *apiResultGetContentById;
@property XMMResponseGetByLocationIdentifier *apiResultGetByLocationIdentifier;
@property XMMResponseGetByLocation *apiResultGetByLocation;
@property XMMResponseGetSpotMap *apiResultGetSpotMap;
@property XMMResponseContentList *apiResultGetContentList;
@property XMMResponseClosestSpot *apiResultClosestSpot;
@property NSArray* fetchResult;
@property NSString* qrScanResult;

@end

@implementation xamoom_ios_sdk_testTests

@synthesize api;

- (void)setUp {
  NSLog(@"Test Suite - setUp");
  [super setUp];
  
  //reset variables
  done = NO;
  
  self.apiResultRSS = nil;
  self.apiResultGetContentById = nil;
  self.apiResultGetByLocationIdentifier = nil;
  self.apiResultGetByLocation = nil;
  self.apiResultGetSpotMap = nil;
  self.apiResultGetContentList = nil;
  self.fetchResult = nil;
}

- (void)tearDown {
  api = nil;
  
  [super tearDown];
  NSLog(@"Test Suite - tearDown");
}

#pragma mark - Tests

- (void)testApiBaseUrl {
  NSLog(@"Test Suite - testApiBaseUrl");
  
  XCTAssertNotNil([XMMEnduserApi sharedInstance].apiBaseURL, @"api.apiBaseURL should not be nil");
}

- (void)testSystemLanguage {
  NSLog(@"Test Suite - testSystemLanguage");
  
  XCTAssertNotNil([XMMEnduserApi sharedInstance].systemLanguage, @"api.systemLanguage should not be nil");
}

#pragma mark API request tests

- (void)testGetContentByIdFullFull {
  NSLog(@"Test Suite - testGetContentByIdFull");
  [[XMMEnduserApi sharedInstance] contentWithContentId:kContentId includeStyle:YES includeMenu:YES withLanguage:@"de" full:YES completion:^(XMMResponseGetById *result) {
    self.apiResultGetContentById = result;
    done = YES;
  } error:^(XMMError *error) {
    
  }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdFullFullWithoutLanguage {
  NSLog(@"Test Suite - testGetContentByIdFull");
  [[XMMEnduserApi sharedInstance] contentWithContentId:kContentId includeStyle:YES includeMenu:YES withLanguage:@"" full:YES completion:^(XMMResponseGetById *result) {
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
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:kLocationIdentifier includeStyle:YES includeMenu:YES withLanguage:@"de" completion:^(XMMResponseGetByLocationIdentifier *result) {
    self.apiResultGetByLocationIdentifier = result;
    done = YES;
  } error:^(XMMError *error) {
    
  }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithoutStyle {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithoutStyle");
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:kLocationIdentifier includeStyle:NO includeMenu:YES withLanguage:@"de"
                                                     completion:^(XMMResponseGetByLocationIdentifier *result) {
                                                       self.apiResultGetByLocationIdentifier = result;
                                                       done = YES;
                                                     } error:^(XMMError *error) {
                                                       
                                                     }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithoutMenu {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithoutMenu");
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:kLocationIdentifier includeStyle:YES includeMenu:NO withLanguage:@"de"
                                                     completion:^(XMMResponseGetByLocationIdentifier *result) {
                                                       self.apiResultGetByLocationIdentifier = result;
                                                       done = YES;
                                                     } error:^(XMMError *error) {
                                                       
                                                     }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithoutStyleAndMenu {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithoutStyleAndMenu");
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:kLocationIdentifier includeStyle:NO includeMenu:NO withLanguage:@"de"
                                                     completion:^(XMMResponseGetByLocationIdentifier *result) {
                                                       self.apiResultGetByLocationIdentifier = result;
                                                       done = YES;
                                                     } error:^(XMMError *error) {
                                                       
                                                     }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithEnglishLanguage {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithEnglishLanguage");
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:kLocationIdentifier includeStyle:YES includeMenu:YES withLanguage:@"en"
                                                     completion:^(XMMResponseGetByLocationIdentifier *result) {
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
                                      completion:^(XMMResponseGetByLocation *result) {
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
                                      completion:^(XMMResponseGetByLocation *result) {
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
  [[XMMEnduserApi sharedInstance] spotMapWithMapTags:@[@"stw"] withLanguage:@"de"
                                           completion:^(XMMResponseGetSpotMap *result) {
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
                                           completion:^(XMMResponseGetSpotMap *result) {
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
  [[XMMEnduserApi sharedInstance] contentListWithPageSize:5 withLanguage:@"de" withCursor:@"null" withTags:@[@"artists"]
   completion:^(XMMResponseContentList *result) {
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
   completion:^(XMMResponseClosestSpot *result) {
     self.apiResultClosestSpot = result;
     done = YES;
   } error:^(XMMError *error) {
     
   }];
  
  XCTAssertTrue([self waitForCompletion:kTimeWaiting], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultClosestSpot, @"getContentList should return something");
}

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
