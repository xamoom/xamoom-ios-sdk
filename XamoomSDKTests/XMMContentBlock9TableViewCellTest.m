//
//  XMMContentBlock9TableViewCellTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 02/01/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "XMMContentBlock9TableViewCell.h"
#import "XMMContentBlock.h"

@interface XMMContentBlock9TableViewCellTest : XCTestCase

@property id mockedApi;
@property XMMContentBlocks *contentBlocks;

@end

@implementation XMMContentBlock9TableViewCellTest

- (void)setUp {
  [super setUp];
  UITableView *tableView = [[UITableView alloc] init];

  self.mockedApi = OCMClassMock([XMMEnduserApi class]);
  self.contentBlocks = [[XMMContentBlocks alloc] initWithTableView:tableView api:self.mockedApi];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testThatContentBlock9CellConfigures {
  [self.contentBlocks displayContent:[self contentWithBlockType9]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock9TableViewCell *testCell = (XMMContentBlock9TableViewCell *)cell;
  
  XCTAssertNotNil(testCell);
  XCTAssertNotNil(testCell.mapAdditionView);
  XCTAssertNotNil(testCell.locationManager);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Block Title"]);
  XCTAssertFalse(testCell.loadingIndicator.hidden);
}

- (void)testThatContentBlock9CellDisplayesSpotMap {
  [self.contentBlocks displayContent:[self contentWithBlockType9]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  
  Boolean __block firstCall = YES;
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 7];
    XMMSpot *spot = [[XMMSpot alloc] init];
    spot.name = @"Spot";
    spot.spotDescription = @"Description";
    spot.latitude = 46.615472;
    spot.longitude = 14.2598533;
    
    if (firstCall) {
      firstCall = NO;
      passedBlock(@[spot], true, @"1", nil);
    } else {
      passedBlock(@[spot], false, @"", nil);
    }
  };
  
  [[[self.mockedApi stub] andDo:completion] spotsWithTags:[OCMArg any] pageSize:100 cursor:[OCMArg any] options:XMMSpotOptionsIncludeContent|XMMSpotOptionsWithLocation sort:0 completion:[OCMArg any]];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock9TableViewCell *testCell = (XMMContentBlock9TableViewCell *)cell;
  
  XMMAnnotation *annotation = (XMMAnnotation *)[testCell.mapView.annotations firstObject];
  
  OCMVerify([self.mockedApi spotsWithTags:[OCMArg any] pageSize:100 cursor:[OCMArg isNil] options:XMMSpotOptionsIncludeContent|XMMSpotOptionsWithLocation sort:0 completion:[OCMArg any]]);
  OCMVerify([self.mockedApi spotsWithTags:[OCMArg any] pageSize:100 cursor:[OCMArg isEqual:@"1"] options:XMMSpotOptionsIncludeContent|XMMSpotOptionsWithLocation sort:0 completion:[OCMArg any]]);
  XCTAssertNotNil(testCell);
  XCTAssertNotNil(testCell.mapAdditionView);
  XCTAssertNotNil(testCell.locationManager);
  XCTAssert([testCell.titleLabel.text isEqualToString:@"Block Title"]);
  XCTAssertTrue(testCell.loadingIndicator.hidden);
  XCTAssert(testCell.mapView.annotations.count > 0);
  XCTAssert(annotation.coordinate.latitude == 46.615472);
  XCTAssert(annotation.coordinate.longitude == 14.2598533);
  XCTAssert([annotation.distance containsString:@"Distance:"]);
}

- (void)testThatContentBlock9CellAnnotationViewOpensAndCloses {
  [self.contentBlocks displayContent:[self contentWithBlockType9]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  
  void (^completion)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 7];
    XMMSpot *spot = [[XMMSpot alloc] init];
    spot.name = @"Spot";
    spot.spotDescription = @"Description";
    spot.latitude = 46.615472;
    spot.longitude = 14.2598533;
    passedBlock(@[spot], false, @"1", nil);
  };
  
  [[[self.mockedApi stub] andDo:completion] spotsWithTags:[OCMArg any] pageSize:100 cursor:[OCMArg any] options:XMMSpotOptionsIncludeContent|XMMSpotOptionsWithLocation sort:0 completion:[OCMArg any]];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock9TableViewCell *testCell = (XMMContentBlock9TableViewCell *)cell;
  
  XMMAnnotation *annotation = (XMMAnnotation *)[testCell.mapView.annotations firstObject];
  MKAnnotationView *annotationView = [testCell mapView:testCell.mapView viewForAnnotation:annotation];
  
  [testCell mapView:testCell.mapView didSelectAnnotationView:annotationView];
  XCTAssert(testCell.mapAdditionViewBottomConstraint.constant == 0);
  XCTAssert([testCell.mapAdditionView.spotTitleLabel.text isEqualToString:@"Spot"]);
  XCTAssert([testCell.mapAdditionView.spotDescriptionLabel.text isEqualToString:@"Description"]);
  
  [testCell mapView:testCell.mapView didDeselectAnnotationView:annotationView];
  XCTAssert(testCell.mapAdditionViewBottomConstraint.constant == testCell.mapAdditionViewHeightConstraint.constant + 10);
}

- (void)testThatContentBlock9CellAnnotationViewWithCustomMarker {
  [self.contentBlocks displayContent:[self contentWithBlockType9]];
  self.contentBlocks.style.customMarker = @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFIAAABuCAYAAAC0lERNAAAAAXNSR0IArs4c6QAAA51JREFUeAHt3b9u2lAcxXFjEwmWTCxZ2BO1S6Q+QdfmJSIixvRVGFHS5CHStU8QKVMEO0OzMLGABCa9P1RbJ3+aBp2qC18vPuB7LPmje21vzjK2fyLQeO0sl5eXH8qyPGs0GiePj48H6/W69dq4Xfkvz/NFsnhIFjdFUVz0er3759f+BHI4HO6lAYNUOu12u81Op1O02+0slZ/3dup3mlTZfD7PptNpOZlMVgn0KgGc9/v9ZQVRQwZiGvBjf3//0+HhYSsA2V4KLBaLbDQaLWaz2W2acJ8rzFyGDgLx+PgYREF5HlutVhZGYZWODarjG8i4J8ZyjplYHWD/tsDR0VErzMIuRm4g48ES90SW89t4ejRmZpiFXQ2ZZE/iwaIDyX8XCLOwqyHjFSeE2bYTCLOwqyHjPbHZbG53FkZnYVa9Y+tTGxpDAEgDT6tAqoaRgTTwtAqkahgZSANPq0CqhpGBNPC0CqRqGBlIA0+rQKqGkYE08LQKpGoYGUgDT6tAqoaRgTTwtAqkahgZSANPq0CqhpGBNPC0CqRqGBlIA0+rQKqGkYE08LQKpGoYGUgDT6tAqoaRgTTwtAqkahgZSANPq0CqhpGBNPC0CqRqGBlIA0+rQKqGkYE08LQKpGoYGUgDT6tAqoaRgTTwtAqkahgZSANPq0CqhpGBNPC0CqRqGBlIA0+rQKqGkYE08LQKpGoYGUgDT6tAqoaRgTTwtAqkahgZSANPq0CqhpGBNPC0CqRqGBlIA0+rQKqGkYE08LQKpGoYGUgDT6tAqoaRgTTwtAqkahgZSANPq0CqhpGBNPC0CqRqGBlIA0+rQKqGkYE08LQKpGoYGUgDT6tAqoaRgTTwtAqkahgZSANPq0CqhpGBNPC0CqRqGBlIA0+rQKqGkYE08LQKpGoYGUgDT6tAqoaRgTTwtAqkahgZSANPq0CqhpE3kHmeL1arlXGa3ayGWdjF1W8g06eNH+KT8GzbCYRZgvwZrQ1k+rTxzXQ6Lbc7DaPDLH3N+HsNWRTFxWQyWTEr3z855vN5FmZhV0P2er37NCuvRqMR6/udluPxOKy+hV0N+bt7PpvNbu/u7tLExPNPnmETRmGVJt/XalyjCrEfDod7aTdID5/Tbrfb7HQ6RbvdztL01WE7l8uyzGIpxz0xlnOs3oRw3u/3lxXGE8jqz+vr64/L5fIsgX5JN9OD6vPw1fFd28crTrzZxEM57onVct41h/9yvb8Ac8Xb13FwJIEAAAAASUVORK5CYII=";
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock9TableViewCell *testCell = (XMMContentBlock9TableViewCell *)cell;
  
  XCTAssertNotNil(testCell.customMapMarker);
}

- (void)testThatContentBlock9CellAnnotationViewWithCustomMarkerSVG {
  [self.contentBlocks displayContent:[self contentWithBlockType9]];
  self.contentBlocks.style.customMarker = @"data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTE4LDIyQTIsMiAwIDAsMCAyMCwyMFY0QzIwLDIuODkgMTkuMSwyIDE4LDJIMTJWOUw5LjUsNy41TDcsOVYySDZBMiwyIDAgMCwwIDQsNFYyMEEyLDIgMCAwLDAgNiwyMkgxOFoiIC8+PC9zdmc+";
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  
  UITableViewCell *cell = [self.contentBlocks tableView:self.contentBlocks.tableView cellForRowAtIndexPath:indexPath];
  XMMContentBlock9TableViewCell *testCell = (XMMContentBlock9TableViewCell *)cell;
  
  XCTAssertNotNil(testCell.customMapMarker);
}

# pragma mark - helper

- (XMMContent *)contentWithBlockType9 {
  XMMContent *content = [[XMMContent alloc] init];
  
  content.title = @"Content Title";
  content.contentDescription = @"Some content description";
  content.language = @"de";
  
  XMMContentBlock *block1 = [[XMMContentBlock alloc] init];
  block1.title = @"Block Title";
  block1.spotMapTags = @[@"tag1"];
  block1.publicStatus = YES;
  block1.blockType = 9;
  block1.showContent = YES;
  
  XMMContentBlock *block2 = [[XMMContentBlock alloc] init];
  block2.title = nil;
  block1.spotMapTags = nil;
  block2.publicStatus = YES;
  block2.blockType = 9;
  block2.showContent = YES;
  
  content.contentBlocks = [[NSArray alloc] initWithObjects:block1, block2, nil];
  
  return content;
}

@end
