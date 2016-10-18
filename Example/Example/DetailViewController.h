//
//  DetailViewController.h
//  example
//
//  Created by Raphael Seher on 18/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "ViewController.h"

@interface DetailViewController : UITableViewController <XMMContentBlocksDelegate>

@property NSString *contentID;

@end
