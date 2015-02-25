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

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)clickTestButton1:(id)sender;
- (IBAction)clickTestButton2:(id)sender;
- (IBAction)scanAction:(id)sender;

@end
