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

@interface xamoom_ios_sdk_testTests : XCTestCase <XMMEnderuserApiDelegate>
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

@end

@implementation xamoom_ios_sdk_testTests

@synthesize api;

- (void)setUp {
  NSLog(@"Test Suite - setUp");
  [super setUp];
  
  //setup api
  api = [[XMMEnduserApi alloc] init];
  api.delegate = self;
  [api initCoreData];
  
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
  api.delegate = nil;
  api = nil;
  
  [super tearDown];
  NSLog(@"Test Suite - tearDown");
}

#pragma mark - Tests

- (void)testApiDelegate {
  NSLog(@"Test Suite - testApiDelegate");
  
  XCTAssertNotNil(api.delegate, @"api.delegate should not be nil");
}

- (void)testApiBaseUrl {
  NSLog(@"Test Suite - testApiBaseUrl");
  
  XCTAssertNotNil(api.apiBaseURL, @"api.apiBaseURL should not be nil");
}

- (void)testRssBaseUrl {
  NSLog(@"Test Suite - testRssBaseUrl");
  
  XCTAssertNotNil(api.rssBaseUrl, @"api.rssBaseUrl should not be nil");
}

- (void)testSystemLanguage {
  NSLog(@"Test Suite - testSystemLanguage");
  
  XCTAssertNotNil(api.systemLanguage, @"api.systemLanguage should not be nil");
}

- (void)testIsCoreDataInitialized {
  NSLog(@"Test Suite - testIsCoreDataInitialized");
  
  XCTAssertTrue(api.isCoreDataInitialized, @"api.isCoreDataInitialized should not be nil");
}

#pragma mark API request tests

//Id

- (void)testGetContentByIdFull {
  NSLog(@"Test Suite - testGetContentByIdFull");
  [api contentWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdFullFull {
  NSLog(@"Test Suite - testGetContentByIdFull");
  [api contentWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de" full:@"True"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdWithoutStyle {
  NSLog(@"Test Suite - testGetContentByIdWithoutStyle");
  [api contentWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"False" includeMenu:@"True" withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdWithoutMenu {
  NSLog(@"Test Suite - testGetContentByIdWithoutMenu");
  [api contentWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"False" withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdWithoutStyleAndMenu {
  NSLog(@"Test Suite - testGetContentByIdWithoutStyleAndMenu");
  [api contentWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"False" includeMenu:@"False" withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdWithEnglishLanguage {
  NSLog(@"Test Suite - testGetContentByIdWithEnglishLanguage");
  [api contentWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"False" withLanguage:@"en"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

//LocationIdentifier

- (void)testGetContentByLocationIdentifierFull {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierFull");
  [api contentWithLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithoutStyle {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithoutStyle");
  [api contentWithLocationIdentifier:@"0ana0" includeStyle:@"False" includeMenu:@"True" withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithoutMenu {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithoutMenu");
  [api contentWithLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"false" withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithoutStyleAndMenu {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithoutStyleAndMenu");
  [api contentWithLocationIdentifier:@"0ana0" includeStyle:@"False" includeMenu:@"False" withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithEnglishLanguage {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierWithEnglishLanguage");
  [api contentWithLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" withLanguage:@"en"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

//location

- (void)testGetContentByLocationFull {
  NSLog(@"Test Suite - testGetContentByLocationFull");
  [api contentWithLat:@"46.615" withLon:@"14.263" withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocation, @"getContentByLocation should return something");
}

- (void)testGetContentByLocationWithEnglishLanguage {
  NSLog(@"Test Suite - testGetContentByLocationWithEnglishLanguage");
  [api contentWithLat:@"46.615" withLon:@"14.263" withLanguage:@"en"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetByLocation, @"getContentByLocation should return something");
}

//spotMap

- (void)testGetSpotMapFull {
  NSLog(@"Test Suite - testGetSpotMapFull");
  [api spotMapWithSystemId:@"6588702901927936" withMapTags:@"stw" withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetSpotMap, @"getSpotMap should return something");
}

- (void)testGetSpotMapWithEnglishLanguage {
  NSLog(@"Test Suite - testGetSpotMapWithEnglishLanguage");
  [api spotMapWithSystemId:@"6588702901927936" withMapTags:@"stw" withLanguage:@"en"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetSpotMap, @"getSpotMap should return something");
}

//contentList

- (void)testGetContentListFromApi {
  NSLog(@"Test Suite - testGetContentListFromApi");
  [api contentListWithSystemId:@"6588702901927936" withLanguage:@"de" withPageSize:4 withCursor:@"null"];
  
  XCTAssertTrue([self waitForCompletion:10.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultGetContentList, @"getContentList should return something");
}

//closestSpots

- (void)testClosestSpotsFromApi {
  NSLog(@"Test Suite - testClosestSpotsFromApi");
  [api closestSpotsWith:46.615 andLon:14.263 withRadius:1000 withLimit:5 withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.apiResultClosestSpot, @"getContentList should return something");
  
}

#pragma mark API Core Data tests

- (void)testGetContentByIdFromCoreData {
  NSLog(@"Test Suite - testGetContentByIdFromCoreData");
  [api saveContentToCoreDataWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:15.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.fetchResult, @"fetchResult should not be nil");
}

- (void)testGetContentByLocationIdentifierFromCoreData {
  NSLog(@"Test Suite - testGetContentByLocationIdentifierFromCoreData");
  [api saveContentToCoreDataWithLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
  
  XCTAssertTrue([self waitForCompletion:25.0], @"Failed to get any results in time");
  XCTAssertNotNil(self.fetchResult, @"fetchResult should not be nil");
}

- (void)testFinishedLoadCoreDataById {
  NSLog(@"Test Suite - testFinishedLoadCoreDataById");
  
  XCTAssertNotNil([api fetchCoreDataContentWithType:@"id"], @"fetchCoreDataContent should return something");
}

- (void)testFinishedLoadCoreDataByLocation {
  NSLog(@"Test Suite - testFinishedLoadCoreDataByLocation");
  
  XCTAssertNotNil([api fetchCoreDataContentWithType:@"location"], @"fetchCoreDataContent should return something");
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

#pragma mark - XMMEnduserApi Delegates

- (void)savedContentToCoreData {
  done = YES;
}

- (void)savedContentToCoreDataWithContentId {
  self.fetchResult = [api fetchCoreDataContentWithType:@"id"];
  done = YES;
}

- (void)savedContentToCoreDataWithLocation {
  self.fetchResult = [api fetchCoreDataContentWithType:@"location"];
  done = YES;
}

-(void)savedContentToCoreDataWithLocationIdentifier {
  self.fetchResult = [api fetchCoreDataContentWithType:@"id"];
  done = YES;
}

- (void)didLoadDataWithContentId:(XMMResponseGetById *)result {
  self.apiResultGetContentById = result;
  done = YES;
}

- (void)didLoadDataWithLocationIdentifier:(XMMResponseGetByLocationIdentifier *)result {
  self.apiResultGetByLocationIdentifier = result;
  done = YES;
}

- (void)didLoadDataWithLocation:(XMMResponseGetByLocation *)result {
  self.apiResultGetByLocation = result;
  done = YES;
}

- (void)didLoadSpotMap:(XMMResponseGetSpotMap *)result {
  self.apiResultGetSpotMap = result;
  done = YES;
}

- (void)didLoadContentList:(XMMResponseContentList *)result {
  self.apiResultGetContentList = result;
  done = YES;
}

- (void)didLoadRSS:(NSMutableArray *)result {
  self.apiResultRSS = result;
  done = YES;
}

- (void)didLoadClosestSpots:(XMMResponseClosestSpot *)result {
  self.apiResultClosestSpot = result;
  done = YES;
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
