//
//  XMMWebViewController.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 14.01.19.
//

#import "XMMWebViewController.h"

@interface XMMWebViewController ()
@property (nonatomic) NSBundle *bundle;
@end

@implementation XMMWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  if (url) {
    self.bundle = [NSBundle bundleWithURL:url];
  } else {
    self.bundle = bundle;
  }
  
  if (_navigationBarColor == nil) {
    _navigationBarColor = UIColor.whiteColor;
  }
  
  [self.navigationController.navigationBar setTintColor:_navigationBarColor];
  [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
  [self.navigationController.navigationBar setShadowImage:nil];
  [self.navigationController.navigationBar setTranslucent: YES];
  
  NSString* title = NSLocalizedStringFromTableInBundle(@"webviewcontroller.back", @"Localizable", self.bundle, nil);
  self.navigationController.navigationBar.topItem.title = title;

  UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
  NSString *secureUrlString = [self.url stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
  NSURL *urlFromString = [NSURL URLWithString:secureUrlString];
  NSURLRequest *request = [NSURLRequest requestWithURL:urlFromString];
  [web loadRequest:request];
  [self.view addSubview:web];
}

@end
