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

@end

@implementation xamoom_ios_sdk_testTests

@synthesize api;

- (void)setUp {
    NSLog(@"Test Suite - setUp");
    [super setUp];
    api = [[XMMEnduserApi alloc] init];
    api.delegate = self;
    [api initCoreData];
    done = NO;
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

- (void)testGetContentById {
    NSLog(@"Test Suite - testGetContentById");
    [api getContentFromApiById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];

    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetContentById, @"getContentById should return something");
}

- (void)testGetContentByLocationIdentifierAction {
    NSLog(@"Test Suite - testGetContentByLocationIdentifierAction");
    [api getContentFromApiByLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetByLocationIdentifier, @"getContentByLocationIdentifier should return something");
}

- (void)testGetContentByLocation {
    NSLog(@"Test Suite - testGetContentByLocation");
    [api getContentFromApiWithLat:@"46.615" withLon:@"14.263" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetByLocation, @"getContentByLocation should return something");
}

- (void)testGetSpotMap {
    NSLog(@"Test Suite - testGetSpotMap");
    [api getSpotMapWithSystemId:@"6588702901927936" withMapTag:@"stw" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
    XCTAssertNotNil(self.apiResultGetSpotMap, @"getSpotMap should return something");
}

- (void)testGetContentByIdFromCoreData {
    NSLog(@"Test Suite - testGetContentByIdFromCoreData");
    [api getContentForCoreDataById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
}

- (void)testGetContentByLocationIdentifierFromCoreData {
    NSLog(@"Test Suite - testGetContentByLocationIdentifierFromCoreData");
    [api getContentForCoreDataByLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
    
    XCTAssertTrue([self waitForCompletion:5.0], @"Failed to get any results in time");
}

- (void)testFinishedLoadCoreData {
    NSLog(@"Test Suite - testFinishedLoadCoreData");
    
    XCTAssertNotNil([api fetchCoreDataContentByType:@"id"], @"fetchCoreDataContent should return something");
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

- (void)didLoadCoreData {
    NSArray* fetchResult = [api fetchCoreDataContentByType:@"id"];
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

- (void)didLoadRSS:(NSMutableArray *)result {
    self.apiResultRSS = result;
    done = YES;
}

#pragma mark - Perfomance Test

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
