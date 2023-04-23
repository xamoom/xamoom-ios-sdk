//
//  XMMContentBlock16TableViewCell.m
//  XamoomSDK
//
//  Created by Vladyslav on 16.11.2022.
//

#import "XMMContentBlock16TableViewCell.h"

@interface XMMContentBlock16TableViewCell() <WKNavigationDelegate>


@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITableView *parentTableView;
@property (nonatomic, retain) id<XMMContentBlocksDelegate> contentBlocksDelegate;

@end

@implementation XMMContentBlock16TableViewCell

static BOOL *isRequestLocationClick = false;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api listManager:(XMMListManager *)listManager offline:(BOOL)offline delegate:(id)delegate {
    self.contentBlocksDelegate = delegate;
    self.parentTableView = tableView;
    
    NSBundle *bundle = [NSBundle bundleForClass:[XMMContentBlocks class]];
    NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
    NSBundle *nibBundle;
    if (url) {
      nibBundle = [NSBundle bundleWithURL:url];
    } else {
      nibBundle = bundle;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lang = [userDefaults stringForKey:@"language"];
    nibBundle = [NSBundle bundleWithPath:[[NSBundle bundleWithURL:url] pathForResource:lang ofType:@"lproj"]];
    
    NSString* iframeUrl = block.iframeUrl;
    NSString* title = block.title;
    BOOL isFullScreen  = block.fullScreen;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.progressIndicator.color = [self colorFromHexString:[defaults objectForKey:@"template_primaryColor"] alpha:1];
    self.iframeTitle.text = title;
    [self addWebView:iframeUrl];
    if (isFullScreen){
        [self webViewFullScreen:iframeUrl];
    }
}
   
- (void) addWebView:(NSString *) iframeUrl {
    
    NSString *htmlString;
    NSString *modifiedIframeUrl = [NSString stringWithFormat:@"<iframe width='100%%' height='90%%' src='%@'></iframe></body></html>", iframeUrl];
    NSString *reSizeHeder = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>";

    
    if ([iframeUrl containsString:@"iframe"]) {
        htmlString = [reSizeHeder stringByAppendingString:iframeUrl];
    } else {
        htmlString = [reSizeHeder stringByAppendingString:modifiedIframeUrl];
    }
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.webViewContainer.bounds.size.width, self.webViewContainer.bounds.size.height)];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.navigationDelegate = self;
    [self.progressIndicator startAnimating];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    [self.webView setOpaque: NO];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webViewContainer addSubview: self.webView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.progressIndicator stopAnimating];
}

- (void)webViewFullScreen: (NSString *) url {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:url forKey:@"iframeUrlNotificationObject"];
[[NSNotificationCenter defaultCenter] postNotificationName:
                       @"UIWebViewFullScreenNotification" object:nil userInfo:userInfo];
}


- (UIColor *)colorFromHexString:(NSString *)hexString alpha: (double) alpha {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

@end
