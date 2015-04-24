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
    [api getContentFromApiById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];

    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdFullFull {
    NSLog(@"Test Suite - testGetContentByIdFull");
    [api getContentByIdFull:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de" full:@"True"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdWithoutStyle {
    NSLog(@"Test Suite - testGetContentByIdWithoutStyle");
    [api getContentFromApiById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"False" includeMenu:@"True" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdWithoutMenu {
    NSLog(@"Test Suite - testGetContentByIdWithoutMenu");
    [api getContentFromApiById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"False" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdWithoutStyleAndMenu {
    NSLog(@"Test Suite - testGetContentByIdWithoutStyleAndMenu");
    [api getContentFromApiById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"False" includeMenu:@"False" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByIdWithEnglishLanguage {
    NSLog(@"Test Suite - testGetContentByIdWithEnglishLanguage");
    [api getContentFromApiById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"False" withLanguage:@"en"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

//LocationIdentifier

- (void)testGetContentByLocationIdentifierFull {
    NSLog(@"Test Suite - testGetContentByLocationIdentifierFull");
    [api getContentFromApiByLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithoutStyle {
    NSLog(@"Test Suite - testGetContentByLocationIdentifierWithoutStyle");
    [api getContentFromApiByLocationIdentifier:@"0ana0" includeStyle:@"False" includeMenu:@"True" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithoutMenu {
    NSLog(@"Test Suite - testGetContentByLocationIdentifierWithoutMenu");
    [api getContentFromApiByLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"false" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithoutStyleAndMenu {
    NSLog(@"Test Suite - testGetContentByLocationIdentifierWithoutStyleAndMenu");
    [api getContentFromApiByLocationIdentifier:@"0ana0" includeStyle:@"False" includeMenu:@"False" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocationIdentifierWithEnglishLanguage {
    NSLog(@"Test Suite - testGetContentByLocationIdentifierWithEnglishLanguage");
    [api getContentFromApiByLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" withLanguage:@"en"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

//location

- (void)testGetContentByLocationFull {
    NSLog(@"Test Suite - testGetContentByLocationFull");
    [api getContentFromApiWithLat:@"46.615" withLon:@"14.263" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:10.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetByLocation, @"getContentByLocation should return something");
}

- (void)testGetContentByLocationWithEnglishLanguage {
    NSLog(@"Test Suite - testGetContentByLocationWithEnglishLanguage");
    [api getContentFromApiWithLat:@"46.615" withLon:@"14.263" withLanguage:@"en"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetByLocation, @"getContentByLocation should return something");
}

//spotMap

- (void)testGetSpotMapFull {
    NSLog(@"Test Suite - testGetSpotMapFull");
    [api getSpotMapWithSystemId:@"6588702901927936" withMapTags:@"stw" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetSpotMap, @"getSpotMap should return something");
}

- (void)testGetSpotMapWithEnglishLanguage {
    NSLog(@"Test Suite - testGetSpotMapWithEnglishLanguage");
    [api getSpotMapWithSystemId:@"6588702901927936" withMapTags:@"stw" withLanguage:@"en"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetSpotMap, @"getSpotMap should return something");
}

//contentList

- (void)testGetContentListFromApi {
    NSLog(@"Test Suite - testGetContentListFromApi");
    [api getContentListFromApi:@"6588702901927936" withLanguage:@"de" withPageSize:4 withCursor:@"null"];
    
    XCTAssertTrue([self waitForCompletion:10.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetContentList, @"getContentList should return something");
}

#pragma mark API Core Data tests

- (void)testGetContentByIdFromCoreData {
    NSLog(@"Test Suite - testGetContentByIdFromCoreData");
    [api getContentForCoreDataById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.fetchResult, @"fetchResult should not be nil");
}

- (void)testGetContentByLocationIdentifierFromCoreData {
    NSLog(@"Test Suite - testGetContentByLocationIdentifierFromCoreData");
    [api getContentForCoreDataByLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.fetchResult, @"fetchResult should not be nil");
}

- (void)testFinishedLoadCoreDataById {
    NSLog(@"Test Suite - testFinishedLoadCoreDataById");
    
    XCTAssertNotNil([api fetchCoreDataContentByType:@"id"], @"fetchCoreDataContent should return something");
}

- (void)testFinishedLoadCoreDataByLocation {
    NSLog(@"Test Suite - testFinishedLoadCoreDataByLocation");
    
    XCTAssertNotNil([api fetchCoreDataContentByType:@"location"], @"fetchCoreDataContent should return something");
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

- (void)savedContentToCoreDataById {
    self.fetchResult = [api fetchCoreDataContentByType:@"id"];
    done = YES;
}

- (void)savedContentToCoreDataByLocation {
    self.fetchResult = [api fetchCoreDataContentByType:@"location"];
    done = YES;
}

-(void)savedContentToCoreDataByLocationIdentifier {
    self.fetchResult = [api fetchCoreDataContentByType:@"id"];
    done = YES;
}

- (void)didLoadDataById:(XMMResponseGetById *)result {
    self.apiResultGetContentById = result;
    done = YES;
}

- (void)didLoadDataByLocationIdentifier:(XMMResponseGetByLocationIdentifier *)result {
    self.apiResultGetByLocationIdentifier = result;
    done = YES;
}

- (void)didLoadDataByLocation:(XMMResponseGetByLocation *)result {
    self.apiResultGetByLocation = result;
    done = YES;
}

- (void)didLoadDataBySpotMap:(XMMResponseGetSpotMap *)result {
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
