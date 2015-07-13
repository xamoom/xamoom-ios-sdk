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

NSString * const kContentId = @"f0da3d3d28d3418e9ccc4a6e9b3493c0";
NSString * const kLocationIdentifier = @"dkriw";

@interface ViewController () <QRCodeReaderDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //get apikey from file
  NSString* path = [[NSBundle mainBundle] pathForResource:@"api"
                                                   ofType:@"txt"];
  NSString* apiKey = [NSString stringWithContentsOfFile:path
                                               encoding:NSUTF8StringEncoding
                                                  error:NULL];
  
  [[XMMEnduserApi sharedInstance] setApiKey:apiKey];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - QRCodeReader Delegate Methods

-(void)didScanQR:(NSString *)result {
  self.outputTextView.text = result;
}

#pragma mark - Actions

- (IBAction)scanAction:(id)sender {
  [[XMMEnduserApi sharedInstance] setQrCodeViewControllerCancelButtonTitle:@"Abbrechen"];
  [[XMMEnduserApi sharedInstance] startQRCodeReaderFromViewController:self didLoad:^(NSString *locationIdentifier, NSString *url) {
    NSLog(@"LocationIdentifier: %@ und url: %@", locationIdentifier, url);
    self.outputTextView.text = [NSString stringWithFormat:@"LocationIdentifier: %@ und url: %@", locationIdentifier, url];
  }];
}


- (IBAction)getContentByIdAction:(id)sender {
  [[XMMEnduserApi sharedInstance] contentWithContentId:kContentId includeStyle:YES includeMenu:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                            completion:^(XMMResponseGetById *result){
                                              NSLog(@"finishedLoadDataById: %@", result.description);
                                              self.outputTextView.text = result.description;
                                            } error:^(XMMError *error) {
                                              NSLog(@"LoadDataById Error: %@", error);
                                            }
   ];
}

- (IBAction)getContentByLocationIdentifierAction:(id)sender {
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:kLocationIdentifier includeStyle:YES includeMenu:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                                     completion:^(XMMResponseGetByLocationIdentifier *result){
                                                       NSLog(@"finishedLoadDataByLocationIdentifier: %@", result.description);
                                                       self.outputTextView.text = result.description;
                                                     } error:^(XMMError *error) {
                                                       NSLog(@"LoadDataByLocationIdentifier Error: %@", error);
                                                     }];
}


- (IBAction)getContentByLocationAction:(id)sender {
  [[XMMEnduserApi sharedInstance] contentWithLat:@"46.615" withLon:@"14.263" withLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                      completion:^(XMMResponseGetByLocation *result){
                                        NSLog(@"finishedLoadDataByLocation: %@", result.description);
                                        self.outputTextView.text = result.description;
                                      } error:^(XMMError *error) {
                                        NSLog(@"LoadDataByLocation Error: %@", error);
                                      }
   ];
}

- (IBAction)getSpotMapAction:(id)sender {
  [[XMMEnduserApi sharedInstance] spotMapWithSystemId:0 withMapTags:@[@"stw",@"raphi"] withLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                           completion:^(XMMResponseGetSpotMap *result) {
                                             NSLog(@"finishedGetSpotMap: %@", result.description);
                                             self.outputTextView.text = result.description;
                                           } error:^(XMMError *error) {
                                             NSLog(@"GetSpotMap Error: %@", error);
                                           }
   ];
}

- (IBAction)getContentListAction:(id)sender {
  [[XMMEnduserApi sharedInstance] contentListWithPageSize:5 withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withCursor:@"null" withTags:@[@"artists"]
                                               completion:^(XMMResponseContentList *result){
                                                 NSLog(@"finishedGetContentList full: %@", result.description);
                                                 self.outputTextView.text = result.description;
                                               } error:^(XMMError *error) {
                                                 NSLog(@"GetContentList Error: %@", error);
                                               }
   ];
}

- (IBAction)getContentByIdFull:(id)sender {
  [[XMMEnduserApi sharedInstance] contentWithContentId:kContentId includeStyle:NO includeMenu:NO withLanguage:[XMMEnduserApi sharedInstance].systemLanguage full:YES
                                            completion:^(XMMResponseGetById *result){
                                              NSLog(@"finishedLoadDataById full: %@", result.description);
                                              self.outputTextView.text = result.description;
                                            } error:^(XMMError *error) {
                                              NSLog(@"LoadDataById full Error: %@", error);
                                            }
   ];
}

- (IBAction)closestSpots:(id)sender {
  [[XMMEnduserApi sharedInstance] closestSpotsWithLat:46.615 withLon:14.263 withRadius:1000 withLimit:100 withLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                           completion:^(XMMResponseClosestSpot *result){
                                             NSLog(@"finishedLoadClosestSpots: %@", result.description);
                                             self.outputTextView.text = result.description;
                                           } error:^(XMMError *error) {
                                             NSLog(@"LoadClosestSpots Error: %@", error);
                                           }
   ];
}

@end
