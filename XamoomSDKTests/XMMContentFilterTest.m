//
//  XMMContentFilterTest.m
//  XamoomSDKTests
//
//  Created by Raphael Seher on 23/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMFilter.h"

@interface XMMContentFilterTest : XCTestCase

@property NSString *nameFilter;
@property NSArray *tags;
@property NSDate *fromDate;
@property NSDate *toDate;
@property NSString *relatedSpotID;

@end

@implementation XMMContentFilterTest

- (void)setUp {
  [super setUp];
  
  _nameFilter = @"Name";
  _tags = [NSArray arrayWithObjects:@"Tag1", @"Tag2", nil];
  _toDate = [NSDate dateWithTimeIntervalSinceNow:0];
  _fromDate = [NSDate dateWithTimeIntervalSinceNow:1];
  _relatedSpotID = @"12345";
}

- (void)testCreateFilterWithBuilder {
  XMMFilterBuilder *builder = [XMMFilterBuilder new];
  builder.name = _nameFilter;
  builder.tags = _tags;
  builder.toDate = _toDate;
  builder.fromDate = _fromDate;
  builder.relatedSpotID = _relatedSpotID;
  
  XMMFilter *filter = [[XMMFilter alloc] initWithBuilder:builder];
  
  XCTAssertEqual(filter.name, _nameFilter);
  XCTAssertEqual(filter.tags, _tags);
  XCTAssertEqual(filter.toDate, _toDate);
  XCTAssertEqual(filter.fromDate, _fromDate);
  XCTAssertEqual(filter.relatedSpotID, _relatedSpotID);
}

- (void)testCreateFilterWithBuilderBlock {
  XMMFilter *filter =
  [XMMFilter makeWithBuilder:^(XMMFilterBuilder *builder) {
    builder.name = _nameFilter;
    builder.tags = _tags;
    builder.toDate = _toDate;
    builder.fromDate = _fromDate;
    builder.relatedSpotID = _relatedSpotID;
  }];
  
  XCTAssertEqual(filter.name, _nameFilter);
  XCTAssertEqual(filter.tags, _tags);
  XCTAssertEqual(filter.toDate, _toDate);
  XCTAssertEqual(filter.fromDate, _fromDate);
  XCTAssertEqual(filter.relatedSpotID, _relatedSpotID);
}

@end
