//
//  XMMWebViewController.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 14.01.19.
//

#import "XMMWebViewController.h"
#import <WebKit/WebKit.h>

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
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *lang = [userDefaults stringForKey:@"language"];
  self.bundle = [NSBundle bundleWithPath:[[NSBundle bundleWithURL:url] pathForResource:lang ofType:@"lproj"]];
  
  if (_navigationBarColor == nil) {
    _navigationBarColor = UIColor.whiteColor;
  }
  
  [self.navigationController.navigationBar setTintColor:_navigationBarColor];
  [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
  [self.navigationController.navigationBar setShadowImage:nil];
  [self.navigationController.navigationBar setTranslucent: YES];
  
  NSString* title = NSLocalizedStringFromTableInBundle(@"webviewcontroller.back", @"Localizable", self.bundle, nil);
  self.navigationController.navigationBar.topItem.title = title;

  WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
  WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration: configuration];
  web.navigationDelegate = self;
  NSString *secureUrlString = [self.url stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
  NSURL *urlFromString = [NSURL URLWithString:secureUrlString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlFromString];
  [request setHTTPShouldHandleCookies:NO];
  [web loadRequest:request];
  [self.view addSubview:web];
}

@end
