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
    [api initCoreData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XMMEnduserApi Delegates

- (void)savedContentToCoreData {
    NSArray* fetchResult = [api fetchCoreDataContentByType:@"id"];
    NSLog(@"finishedLoadCoreData: %@", fetchResult);
    self.outputTextView.text = fetchResult.description;
}

- (void)savedContentToCoreDataById {
    NSLog(@"savedContentToCoreDataById");
}

- (void)savedContentToCoreDataByLocation {
    NSLog(@"savedContentToCoreDataByLocation");
}

- (void)savedContentToCoreDataByLocationIdentifier {
    NSLog(@"savedContentToCoreDataByLocationIdentifier");
}

- (void)didLoadDataById:(XMMResponseGetById *)result {
    NSLog(@"finishedLoadDataById: %@", result.description);
    self.outputTextView.text = result.description;
}

- (void)didLoadDataByLocationIdentifier:(XMMResponseGetByLocationIdentifier *)result {
    NSLog(@"finishedLoadDataByLocationIdentifier: %@", result);
    self.outputTextView.text = result.description;
}

- (void)didLoadDataByLocation:(XMMResponseGetByLocation *)result {
    NSLog(@"finishedLoadDataByLocation: %@", result);
    self.outputTextView.text = result.description;
}

- (void)didLoadDataBySpotMap:(XMMResponseGetSpotMap *)result {
    NSLog(@"finishedLoadDataBySpotMap: %@", result);
    self.outputTextView.text = result.description;
}

- (void)didLoadRSS:(NSMutableArray *)result {
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
    NSLog(@"readerDidCancel");
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Actions

- (IBAction)scanAction:(id)sender
{
    [api startQRCodeReader:self
            withAPIRequest:YES];
}

- (IBAction)getContentByIdAction:(id)sender {
    [api getContentFromApiById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
}

- (IBAction)getContentByLocationIdentifierAction:(id)sender {
    [api getContentFromApiByLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
}

- (IBAction)getContentByLocationAction:(id)sender {
    [api getContentFromApiWithLat:@"46.615" withLon:@"14.263" withLanguage:@"de"];
}

- (IBAction)getSpotMapAction:(id)sender {
    [api getSpotMapWithSystemId:@"6588702901927936" withMapTag:@"stw" withLanguage:@"de"];
}

- (IBAction)getContentByIdFromCoreDataAction:(id)sender {
    [api getContentForCoreDataById:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
}

- (IBAction)getContentByLocationIdentifierFromCoreDataAction:(id)sender {
    [api getContentForCoreDataByLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
}

- (IBAction)getContentFromRSSFeedAction:(id)sender {
    [api getContentFromRSSFeed];
}

- (void)fetchCoreDataContentByYourOwn {
    //check if coreData is initialized
    if(api.isCoreDataInitialized) {
        //get the context
        NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
        
        //make your own fetchRequest
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMMCoreDataGetById"];
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        NSLog(@"HERE: %@", fetchedObjects);
    }
    else {
        NSLog(@"CoreData is not initialized.");
    }
}

@end
