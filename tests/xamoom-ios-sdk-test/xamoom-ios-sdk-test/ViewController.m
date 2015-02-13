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

    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    api = [[XMMEnduserApi alloc] init];
    api.delegate = self;
    //[api getContentById:@"c1b98a0a44994d12876b2b4a0520d0b3" includeStyle:@"True" includeMenu:@"True" language:@"de"];
    //[api getContentByLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" language:@"de"];
    //[api getContentByLocation:@"46.61505684231224" lon:@"14.2624694108963" language:@"de"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testButtonPressed:(id)sender {
    
}

-(void)finishedLoadData {
    NSLog(@"Finished loading data: %@", api.apiResult);
}

@end

