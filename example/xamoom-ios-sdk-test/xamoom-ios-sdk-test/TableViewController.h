//
//  TableViewController.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 27.07.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "ViewController.h"
#import "XMMContentBlocks.h"

@interface TableViewController : UIViewController <UITableViewDelegate ,XMMContentBlocksDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSString* contentId;

@end
