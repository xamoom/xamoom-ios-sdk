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

- (IBAction)testButtonPressed:(id)sender;

@end

