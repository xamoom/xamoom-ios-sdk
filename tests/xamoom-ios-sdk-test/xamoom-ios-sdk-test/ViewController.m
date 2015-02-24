//
//  ViewController.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 04.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "ViewController.h"
#import <RestKit/RestKit.h>
#import "XMMEnduserApi.h"

@interface ViewController ()

@end

@implementation ViewController

XMMEnduserApi *api;

- (void)viewDidLoad {
    [super viewDidLoad];

    //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    api = [[XMMEnduserApi alloc] init];
    api.delegate = self;
    [api initRestkitCoreData];
    //[api getContentById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" language:@"de"];
    //[api getContentByLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" language:@"de"];
    //[api getContentByLocation:@"46.615" lon:@"14.263" language:@"de"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testButtonPressed:(id)sender {
    //[api getContentByIdFromCoreData:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" language:@"de"];
    [api getContentByLocationIdentifierFromCoreData:@"0ana0" includeStyle:@"True" includeMenu:@"True" language:@"de"];
}

- (IBAction)test2ButtonPressen:(id)sender {
    //[api getContentByIdFromCoreData:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" language:@"de"];
    [api getContentByLocationIdentifierFromCoreData:@"3fi7c" includeStyle:@"True" includeMenu:@"True" language:@"de"];
}

- (void)finishedLoadCoreData {
    //NSArray* fetchResult = [api fetchCoreDataContentBy:@"locationIdentifier"];
    //XMMCoreDataGetByLocationIdentifier *firstEntity = fetchResult.firstObject;
    //NSLog(@"fetchResult: %@", firstEntity);
}

- (void)finishedLoadDataById:(XMMResponseGetById *)result {
    NSLog(@"finishedLoadDataById: %@", result.content.contentBlocks);
}

- (void)finishedLoadDataByLocationIdentifier:(XMMResponseGetByLocationIdentifier *)result {
    NSLog(@"finishedLoadDataByLocationIdentifier: %@", result);
}

- (void)finishedLoadDataByLocation:(XMMResponseGetByLocation *)result {
    NSLog(@"finishedLoadDataByLocation: %@", result);
}
 
@end
