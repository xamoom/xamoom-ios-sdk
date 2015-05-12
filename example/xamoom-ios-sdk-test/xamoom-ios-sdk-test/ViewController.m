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
  
  //init xamoom-ios-sdk
  api = [[XMMEnduserApi alloc] init];
  api.delegate = self;
  [api initCoreData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - XMMEnduserApi Delegates

- (void)savedContentToCoreDataWithContentId {
  NSLog(@"savedContentToCoreDataById");
  NSArray* fetchResult = [api fetchCoreDataContentWithType:@"id"];
  self.outputTextView.text = fetchResult.description;
}

- (void)savedContentToCoreDataWithLocation {
  NSLog(@"savedContentToCoreDataByLocation");
  NSArray* fetchResult = [api fetchCoreDataContentWithType:@"location"];
  self.outputTextView.text = fetchResult.description;
}

- (void)savedContentToCoreDataWithLocationIdentifier {
  NSLog(@"savedContentToCoreDataByLocationIdentifier");
  NSArray* fetchResult = [api fetchCoreDataContentWithType:@"id"];
  self.outputTextView.text = fetchResult.description;
}

- (void)didLoadDataWithContentId:(XMMResponseGetById *)result {
  NSLog(@"finishedLoadDataById: %@", result.description);
  self.outputTextView.text = result.description;
}

- (void)didLoadDataWithLocationIdentifier:(XMMResponseGetByLocationIdentifier *)result {
  NSLog(@"finishedLoadDataByLocationIdentifier: %@", result);
  self.outputTextView.text = result.description;
}

- (void)didLoadDataWithLocation:(XMMResponseGetByLocation *)result {
  NSLog(@"finishedLoadDataByLocation: %@", result);
  self.outputTextView.text = result.description;
}

- (void)didLoadSpotMap:(XMMResponseGetSpotMap *)result {
  NSLog(@"finishedLoadDataBySpotMap: %@", result);
  self.outputTextView.text = result.description;
}

- (void)didLoadContentList:(XMMResponseContentList *)result {
  NSLog(@"XMMResponseContentList: %@", result);
  self.outputTextView.text = result.description;
}

- (void)didLoadRSS:(NSMutableArray *)result {
  NSLog(@"finishedLoadRSS: %@", result);
  self.outputTextView.text = [NSString stringWithFormat:@"Loader RSS: %@", result];
}

-(void)didLoadClosestSpots:(XMMResponseClosestSpot *)result {
  NSLog(@"XMMResponseClosestSpot: %@", result);
  self.outputTextView.text = result.description;
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
  [api startQRCodeReaderFromViewController:self
                              withLanguage:@"DE"];
}

- (IBAction)getContentByIdAction:(id)sender {
  [api contentWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
}

- (IBAction)getContentByLocationIdentifierAction:(id)sender {
  [api contentWithLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
}

- (IBAction)getContentByLocationAction:(id)sender {
  [api contentWithLat:@"46.615" withLon:@"14.263" withLanguage:@"de"];
}

- (IBAction)getSpotMapAction:(id)sender {
  [api spotMapWithSystemId:@"6588702901927936" withMapTags:@"stw" withLanguage:@"de"];
}

- (IBAction)getContentListAction:(id)sender {
  [api contentListWithSystemId:@"6588702901927936" withLanguage:@"de" withPageSize:4 withCursor:@"null"];
}

- (IBAction)getContentByIdFull:(id)sender {
  [api contentWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"False" includeMenu:@"False" withLanguage:@"de" full:@"True"];
}

- (IBAction)closestSpots:(id)sender {
  [api closestSpotsWithLat:46.615 withLon:14.263 withRadius:1000 withLimit:5 withLanguage:@"de"];
}

- (IBAction)getContentByIdFromCoreDataAction:(id)sender {
  [api saveContentToCoreDataWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
}

- (IBAction)getContentByLocationIdentifierFromCoreDataAction:(id)sender {
  [api saveContentToCoreDataWithLocationIdentifier:@"0ana0" includeStyle:@"True" includeMenu:@"True" withLanguage:@"de"];
}

- (IBAction)getContentByLocationFromCoreData:(id)sender {
  [api saveContentToCoreDataWithLat:@"46.615" withLon:@"14.263" withLanguage:@"de"];
}

- (IBAction)getContentFromRSSFeedAction:(id)sender {
  [api rssContentFeed];
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
