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
    api.rssBaseUrl = @"http://xamoom.com/feed/";
    [api initRestkitCoreData];
    [api getContentFromRSSFeed];
    
    [api getContentById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" language:@"de"];
    [api getContentByLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" language:@"de"];
    [api getContentByLocation:@"46.615" lon:@"14.263" language:@"de"];
    
    [api getContentByIdFromCoreData:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" language:@"de"];
    [api getContentByLocationIdentifierFromCoreData:@"0ana0" includeStyle:@"True" includeMenu:@"True" language:@"de"];
    [api deleteCoreDataEntityBy:@"a3911e54085c427d95e1243844bd6aa3"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishedLoadCoreData {
    NSArray* fetchResult = [api fetchCoreDataContentBy:@"id"];
    XMMCoreDataGetById *firstEntity = fetchResult.firstObject;
    NSLog(@"fetchResult: %@", firstEntity);
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

- (void)finishedLoadRSS:(NSMutableArray *)result {
    for (XMMRSSEntry *item in result) {
        NSLog(@"finishedLoadRSS: %@", item);
    }
    
    XMMRSSEntry *item = result.firstObject;
    [self.webView loadHTMLString:item.content baseURL:nil];

}

- (IBAction)clickTestButton1:(id)sender {
    
}

- (IBAction)clickTestButton2:(id)sender {
    
}

- (IBAction)scanAction:(id)sender
{
    static QRCodeReaderViewController *reader = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        reader                        = [QRCodeReaderViewController new];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
    });
    reader.delegate = self;
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        NSLog(@"Completion with result: %@", resultAsString);
    }];
    
    [self presentViewController:reader animated:YES completion:NULL];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
