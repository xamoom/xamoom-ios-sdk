//
//  DetailViewController.m
//  example
//
//  Created by Raphael Seher on 18/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "DetailViewController.h"
#import <XamoomSDK.h>

@interface DetailViewController ()

@property XMMEnduserApi *api;
@property XMMContentBlocks *blocks;

@end

@implementation DetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestingIDs" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
  NSString *apikey = [dict objectForKey:@"APIKEY"];
  NSString *devkey = [dict objectForKey:@"X-DEVKEY"];
  
  NSDictionary *httpHeaders = @{@"Content-Type":@"application/vnd.api+json",
                                @"User-Agent":@"XamoomSDK iOS | SDK Example | dev",
                                @"APIKEY":apikey,
                                @"X-DEVKEY":devkey};
  
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:httpHeaders];
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:@"https://xamoom-cloud-dev.appspot.com/_api/v2/consumer/"] session:[NSURLSession sessionWithConfiguration:config]];
  
  self.api = [[XMMEnduserApi alloc] initWithRestClient:restClient];

  self.blocks = [[XMMContentBlocks alloc] initWithTableView:self.tableView api:self.api];
  self.blocks.delegate = self;
  
  if (self.contentID) {
    [self.api contentWithID:self.contentID completion:^(XMMContent *content, NSError *error) {
      [self.blocks displayContent:content];
    }];
  }
  
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(offlineReady)
   name:kManagedContextReadyNotification
   object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kManagedContextReadyNotification object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)offlineReady {
  NSLog(@"offlineReady");
}

- (void)didClickContentBlock:(NSString *)contentID {
  NSLog(@"didClickContentBlock");
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
