//
//  ViewController.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 04.02.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMEnduserApi.h"

@interface ViewController : UIViewController <XMEnderuserApiDelegate>

@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

- (IBAction)scanAction:(id)sender;

- (IBAction)getContentByIdAction:(id)sender;
- (IBAction)getContentByLocationIdentifierAction:(id)sender;
- (IBAction)getContentByLocationAction:(id)sender;
- (IBAction)getSpotMapAction:(id)sender;

- (IBAction)getContentByIdFromCoreDataAction:(id)sender;
- (IBAction)getContentByLocationIdentifierFromCoreDataAction:(id)sender;

- (IBAction)getContentFromRSSFeedAction:(id)sender;

@end
