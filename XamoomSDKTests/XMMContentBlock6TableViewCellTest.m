//
//  XMMContentBlock6TableViewCellTest.m
//  XamoomSDK
//
//  Created by Raphael Seher on 18/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XMMContentBlock6TableViewCell.h"
#import "XMMOfflineFileManager.h"
#import "XMMEnduserApi.h"

@interface XMMContentBlock6TableViewCellTest : XCTestCase

@end

@implementation XMMContentBlock6TableViewCellTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testconfigureForCellOffline {
  XMMContentBlock6TableViewCell *cell = [[XMMContentBlock6TableViewCell alloc] init];
  
  XMMContentBlock *block = [[XMMContentBlock alloc] init];
  block.fileID = @"www.xamoom.com/file.jpg";
  
  XMMOfflineFileManager *mockFileManager = OCMClassMock([XMMOfflineFileManager class]);
  cell.fileManager = mockFileManager;
  
  XMMEnduserApi *mockApi = OCMClassMock([XMMEnduserApi class]);
  OCMStub([mockApi contentWithID:[OCMArg any] options:1 completion:[OCMArg any]] ).andDo(^(NSInvocation *invocation) {
    void (^passedBlock)(XMMContent *content, NSError *error);
    [invocation getArgument: &passedBlock atIndex: 4];
    XMMContent *content = [[XMMContent alloc] init];
    content.imagePublicUrl = block.fileID;
    passedBlock(content, nil);
  });
  
  [cell configureForCell:block tableView:nil indexPath:nil style:nil api:mockApi offline:YES];
  
  OCMVerify([mockFileManager urlForSavedData:[OCMArg isEqual:block.fileID]]);
}

@end
