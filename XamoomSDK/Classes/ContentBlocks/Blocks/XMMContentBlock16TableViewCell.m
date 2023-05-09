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
    
    NSString* iframeHtml = [self getIframeHtml:iframeUrl];
    int cellHeight = [self extractHeightfromLink:iframeHtml];
    [self recizeTabelViewCell:cellHeight];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.progressIndicator.color = [self colorFromHexString:[defaults objectForKey:@"template_primaryColor"] alpha:1];
    self.iframeTitle.text = title;
    [self addWebView:iframeHtml];
    if (isFullScreen){
        [self webViewFullScreen:iframeUrl];
    }
}

- (int) extractHeightfromLink:(NSString *)link {
    int heightValue = 0;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"height=['\"](\\d+)" options:0 error:nil];
    NSTextCheckingResult *result = [regex firstMatchInString:link options:0 range:NSMakeRange(0, link.length)];
    if (result) {
        NSRange heightRange = [result rangeAtIndex:1];
        NSString* heightString = [link substringWithRange:heightRange];
        heightValue = [heightString intValue];
    }
    return heightValue;
}

- (NSString *) getIframeHtml:(NSString *)iframeUrl {
    NSString *iframeHtml;
    NSString *reSizeHeder = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>";
    NSString *modifiedIframeUrl = [NSString stringWithFormat:@"<iframe width='100%%' height='200' src='%@'></iframe></body></html>", iframeUrl];
    if ([iframeUrl containsString:@"iframe"]) {
        iframeHtml = [reSizeHeder stringByAppendingString:iframeUrl];
    } else {
        iframeHtml = [reSizeHeder stringByAppendingString:modifiedIframeUrl];
    }
    return iframeHtml;
}

- (void) recizeTabelViewCell:(int)cellHeight {
    int newCellHeight = cellHeight;
    if (cellHeight == 0) {
        newCellHeight = 150;
    }
    self.webViewContainerHeightConstraint.constant = newCellHeight + 50;
    [self.webViewContainer layoutIfNeeded];
}
   
- (void) addWebView:(NSString *) iframeHtml {
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.webViewContainer.bounds.size.width, self.webViewContainer.bounds.size.height)];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.navigationDelegate = self;
    [self.progressIndicator startAnimating];
    [self.webView loadHTMLString:iframeHtml baseURL:nil];
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
