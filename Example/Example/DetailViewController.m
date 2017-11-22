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

@property XMMContentBlocks *blocks;

@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
  [self.blocks viewWillAppear];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.blocks = [[XMMContentBlocks alloc] initWithTableView:self.tableView api:self.api];
  self.blocks.delegate = self;
  self.blocks.offline = self.api.offline;
  self.blocks.showAllStoreLinks = YES;
  
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
  [self.blocks viewWillDisappear];
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
  
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  DetailViewController *vc = (DetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
  vc.api = self.api;
  vc.contentID = contentID;
  [self.navigationController pushViewController:vc animated:YES];
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
