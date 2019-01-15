//
//  XMMWebViewController.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 14.01.19.
//

#import "XMMWebViewController.h"

@interface XMMWebViewController ()

@end

@implementation XMMWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
  [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
  [self.navigationController.navigationBar setShadowImage:nil];
  [self.navigationController.navigationBar setTranslucent: YES];
  
  UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
  NSURL *urlFromString = [NSURL URLWithString:self.url];
  NSURLRequest *request = [NSURLRequest requestWithURL:urlFromString];
  [web loadRequest:request];
  [self.view addSubview:web];
}

@end
