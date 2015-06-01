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
  
  //setup xamoom-ios-sdk
  [XMMEnduserApi sharedInstance].delegate = self;
  [[XMMEnduserApi sharedInstance] initCoreData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - XMMEnduserApi Delegates

- (void)savedContentToCoreDataWithContentId {
  NSLog(@"savedContentToCoreDataById");
  NSArray* fetchResult = [[XMMEnduserApi sharedInstance] fetchCoreDataContentWithType:@"id"];
  self.outputTextView.text = fetchResult.description;
}

- (void)savedContentToCoreDataWithLocation {
  NSLog(@"savedContentToCoreDataByLocation");
  NSArray* fetchResult = [[XMMEnduserApi sharedInstance] fetchCoreDataContentWithType:@"location"];
  self.outputTextView.text = fetchResult.description;
}

- (void)savedContentToCoreDataWithLocationIdentifier {
  NSLog(@"savedContentToCoreDataByLocationIdentifier");
  NSArray* fetchResult = [[XMMEnduserApi sharedInstance] fetchCoreDataContentWithType:@"id"];
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

-(void)didScanQR:(NSString *)result {
  self.outputTextView.text = result;
}

#pragma mark - Actions

- (IBAction)scanAction:(id)sender {
  [[XMMEnduserApi sharedInstance] setDelegate:self];
  [[XMMEnduserApi sharedInstance] setQrCodeViewControllerCancelButtonTitle:@"Abbrechen"];
  [[XMMEnduserApi sharedInstance] startQRCodeReaderFromViewController:self];
}

- (IBAction)getContentByIdAction:(id)sender {
  [[XMMEnduserApi sharedInstance] contentWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:YES includeMenu:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

- (IBAction)getContentByLocationIdentifierAction:(id)sender {
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:@"0ana0" includeStyle:YES includeMenu:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

- (IBAction)getContentByLocationAction:(id)sender {
  [[XMMEnduserApi sharedInstance] contentWithLat:@"46.615" withLon:@"14.263" withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

- (IBAction)getSpotMapAction:(id)sender {
  [[XMMEnduserApi sharedInstance] spotMapWithSystemId:0 withMapTags:@[@"stw",@"raphi"] withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

- (IBAction)getContentListAction:(id)sender {
  [[XMMEnduserApi sharedInstance] contentListWithPageSize:5 withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withCursor:@"null" withTags:@[@"artists"]];
}

- (IBAction)getContentByIdFull:(id)sender {
  [[XMMEnduserApi sharedInstance] contentWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:NO includeMenu:NO withLanguage:[XMMEnduserApi sharedInstance].systemLanguage full:YES];
}

- (IBAction)closestSpots:(id)sender {
  [[XMMEnduserApi sharedInstance] closestSpotsWithLat:46.615 withLon:14.263 withRadius:1000 withLimit:100 withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

- (IBAction)getContentByIdFromCoreDataAction:(id)sender {
  [[XMMEnduserApi sharedInstance] saveContentToCoreDataWithContentId:@"a3911e54085c427d95e1243844bd6aa3" includeStyle:YES includeMenu:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

- (IBAction)getContentByLocationIdentifierFromCoreDataAction:(id)sender {
  [[XMMEnduserApi sharedInstance] saveContentToCoreDataWithLocationIdentifier:@"0ana0" includeStyle:YES includeMenu:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

- (IBAction)getContentByLocationFromCoreData:(id)sender {
  [[XMMEnduserApi sharedInstance] saveContentToCoreDataWithLat:@"46.615" withLon:@"14.263" withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

- (IBAction)getContentFromRSSFeedAction:(id)sender {
  [[XMMEnduserApi sharedInstance] rssContentFeed];
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
