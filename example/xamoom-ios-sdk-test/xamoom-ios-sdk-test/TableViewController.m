//
//  TableViewController.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 27.07.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@property XMMContentBlocks *contentBlocks;

@end

@implementation TableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 150.0;
  
  self.contentBlocks = [[XMMContentBlocks alloc] initWithLanguage:[XMMEnduserApi sharedInstance].systemLanguage withWidth:self.tableView.bounds.size.width];
  self.contentBlocks.delegate = self;
  
  [[XMMEnduserApi sharedInstance] contentWithContentId:@"d8be762e9b644fc4bb7aedfa8c0e17b7" includeStyle:NO includeMenu:NO withLanguage:@"" full:YES
                                            completion:^(XMMResponseGetById *result) {
                                              [self.contentBlocks displayContentBlocksByIdResult:result];
                                            } error:^(XMMError *error) {
                                            }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.contentBlocks.itemsToDisplay[indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.contentBlocks.itemsToDisplay count];
}

-(void)reloadTableViewForContentBlocks {
  [self.tableView reloadData];
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
