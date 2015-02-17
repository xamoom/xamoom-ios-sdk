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
    //[api getContentByLocation:@"46.61505684231224" lon:@"14.2624694108963" language:@"de"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)testButtonPressed:(id)sender {
    [api getContentByIdFromCoreData:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" language:@"de"];
    //[api getContentByLocationIdentifierFromCoreData:@"0ana0" includeStyle:@"True" includeMenu:@"True" language:@"de"];
    //[api getContentByLocationFromCoreData:@"46.61505684231224" lon:@"14.2624694108963" language:@"de"];
}

- (void)finishedLoadData:(RKMappingResult *)results {
    NSLog(@"finishedLoadData: %@", results);
}

-(void)finishedLoadCoreData {
    NSLog(@"FetchData: %@", [api fetchCoreDataContentBy:@"ID"]);
}

@end

