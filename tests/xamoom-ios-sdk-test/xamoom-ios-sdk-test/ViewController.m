//
//  ViewController.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 04.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "ViewController.h"
#import <RestKit/RestKit.h>
#import "XMEnduserApi.h"

@interface ViewController ()

@end

@implementation ViewController

XMEnduserApi *api;

- (void)viewDidLoad {
    [super viewDidLoad];
    api = [XMEnduserApi new];
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    //[api testDynamicMapping];
    [api getContentById:@"c1b98a0a44994d12876b2b4a0520d0b3" includeStyle:@"False" includeMenu:@"False" language:@"de"];
    //[api getContentByLocationIdentifier:@"0ana0" includeStyle:@"false" includeMenu:@"false" language:@"de"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testButtonPressed:(id)sender {
}

@end

