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

@interface ViewController () <QRCodeReaderDelegate>

@end

@implementation ViewController

XMMEnduserApi *api;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    api = [[XMMEnduserApi alloc] init];
    api.delegate = self;
    [api initRestkitCoreData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XMMEnduserApi Delegates

- (void)finishedLoadCoreData {
    NSArray* fetchResult = [api fetchCoreDataContentBy:@"id"];
    for (XMMCoreDataGetById *entity in fetchResult) {
        self.outputTextView.text = entity.description;
    }
    NSLog(@"finishedLoadCoreData: %@", fetchResult);
}

- (void)finishedLoadDataById:(XMMResponseGetById *)result {
    NSLog(@"finishedLoadDataById: %@", result.description);
    self.outputTextView.text = result.description;
}

- (void)finishedLoadDataByLocationIdentifier:(XMMResponseGetByLocationIdentifier *)result {
    NSLog(@"finishedLoadDataByLocationIdentifier: %@", result);
    self.outputTextView.text = result.description;
}

- (void)finishedLoadDataByLocation:(XMMResponseGetByLocation *)result {
    NSLog(@"finishedLoadDataByLocation: %@", result);
    self.outputTextView.text = result.description;
}

- (void)finishedLoadDataBySpotMap:(XMMResponseGetSpotMap *)result {
    NSLog(@"finishedLoadDataBySpotMap: %@", result);
    for (XMMResponseGetSpotMapItem *item in result.items) {
        NSLog(@"Item: %@", item.displayName);
    }
}

- (void)finishedLoadRSS:(NSMutableArray *)result {
    for (XMMRSSEntry *item in result) {
        NSLog(@"finishedLoadRSS: %@", item);
        self.outputTextView.text = item.description;
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Completion with result: %@", result);
        self.outputTextView.text = result;
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Actions

- (IBAction)scanAction:(id)sender
{
    [api startQRCodeReader:self
            withAPIRequest:YES];
}

- (IBAction)getContentByIdAction:(id)sender {
    [api getContentById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" language:@"de"];
}

- (IBAction)getContentByLocationIdentifierAction:(id)sender {
    [api getContentByLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" language:@"de"];
}

- (IBAction)getContentByLocationAction:(id)sender {
    [api getContentByLocation:@"46.615" lon:@"14.263" language:@"de"];
}

- (IBAction)getSpotMapAction:(id)sender {
    [api getSpotMap:@"6588702901927936" mapTag:@"stw" language:@"de"];
}

- (IBAction)getContentByIdFromCoreDataAction:(id)sender {
    [api getContentByIdFromCoreData:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" language:@"de"];
}

- (IBAction)getContentByLocationIdentifierFromCoreDataAction:(id)sender {
    [api getContentByLocationIdentifierFromCoreData:@"0ana0" includeStyle:@"True" includeMenu:@"True" language:@"de"];
}

- (IBAction)getContentFromRSSFeedAction:(id)sender {
    [api getContentFromRSSFeed];
}




@end
