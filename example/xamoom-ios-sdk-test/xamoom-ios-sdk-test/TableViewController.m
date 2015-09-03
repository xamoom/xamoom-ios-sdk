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
  self.contentBlocks.showAllStoreLinks = YES;
  
  if (self.contentId == nil) {
    self.contentId = @"8f51819db5c6403d8455593322437c07";
  }
  
  [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId includeStyle:NO includeMenu:NO withLanguage:@"" full:YES
                                            completion:^(XMMContentById *result) {
                                              [self.contentBlocks displayContentBlocksWithIdResult:result];
                                            } error:^(XMMError *error) {
                                            }];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseAllSounds" object:self];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  if ([(self.contentBlocks.itemsToDisplay)[indexPath.row] isKindOfClass:[XMMContentBlock6TableViewCell class]]) {
    XMMContentBlock6TableViewCell *cell = (self.contentBlocks.itemsToDisplay)[indexPath.row];
    
    TableViewController *vc = [[TableViewController alloc] init];
    [vc setContentId:cell.contentId];
    [self.navigationController pushViewController:vc animated:YES];
  }
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
