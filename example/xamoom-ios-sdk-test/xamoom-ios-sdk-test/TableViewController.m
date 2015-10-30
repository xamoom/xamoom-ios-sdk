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
  self.tableView.delegate = self;
  
  self.contentBlocks = [[XMMContentBlocks alloc] initWithLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
  
  self.tableView.dataSource = self.contentBlocks;
  
  if (self.contentId == nil) {
    self.contentId = @"8f51819db5c6403d8455593322437c07";
  }
  
  [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId includeStyle:NO includeMenu:NO withLanguage:@"" full:YES
                                            completion:^(XMMContentById *result) {
                                              self.contentBlocks.content = result.content;
                                              [self.tableView reloadData];
                                              [self.tableView setNeedsLayout];
                                              [self.tableView layoutIfNeeded];
                                              [self.tableView reloadData]; 
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[XMMContentBlock6TableViewCell class]]) {
    XMMContentBlock6TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TableViewController *vc = [storyboard  instantiateViewControllerWithIdentifier:@"TableViewController"];

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
