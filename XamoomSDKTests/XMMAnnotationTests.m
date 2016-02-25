//
//  XMMAnnotationTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 25/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMMAnnotation.h"

@interface XMMAnnotationTests : XCTestCase

@end

@implementation XMMAnnotationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
  XMMAnnotation *annotation = [[XMMAnnotation alloc] init];
  
  XCTAssert(annotation.coordinate.latitude == 0);
  XCTAssert(annotation.coordinate.longitude == 0);
}

- (void)testInitWithLocation {
  XMMAnnotation *annotation = [[XMMAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake(1, 1)];
  
  XCTAssert(annotation.coordinate.latitude == 1);
  XCTAssert(annotation.coordinate.longitude == 1);
}

- (void)testInitWithNameLocation {
  XMMAnnotation *annotation = [[XMMAnnotation alloc] initWithName:@"Name" withLocation:CLLocationCoordinate2DMake(1, 1)];
  
  XCTAssert([annotation.title isEqualToString:@"Name"]);
  XCTAssert(annotation.coordinate.latitude == 1);
  XCTAssert(annotation.coordinate.longitude == 1);
}

- (void)testMapItem {
  XMMAnnotation *annotation = [[XMMAnnotation alloc] init];
  XCTAssert(annotation.mapItem.placemark.coordinate.latitude == 0);
  XCTAssert(annotation.mapItem.placemark.coordinate.longitude == 0);
}
@end
