//
//  XMMContentBlock15TableViewCell.m
//  XamoomSDK
//
//  Created by G0yter on 11.12.2020.
//  Copyright © 2020 xamoom GmbH. All rights reserved.
//

#import "XMMContentBlock15TableViewCell.h"

@implementation XMMContentBlock15TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline {
    NSString* formId = block.text;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* formUrl = [self getModifiedFormUrl:(NSString *)([defaults objectForKey:@"formUrl"])];
    NSString* primaryColor = [defaults objectForKey:@"template_primaryColor"];
    self.progressIndicator.color = [self colorFromHexString:[defaults objectForKey:@"template_primaryColor"] alpha:1];
    BOOL isFormActive = (BOOL)([defaults objectForKey:@"isFormActive"]);
    if (formUrl == nil || [formUrl isEqualToString:@""]) {
        formUrl = [NSString stringWithFormat:@"https://forms.xamoom.com"];
    }
    if (isFormActive == nil) {
        isFormActive = YES;
    }
    
    if (isFormActive) {
        NSMutableString *url = [NSMutableString new];
        [url appendString:@"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header><iframe src=\""];
        [url appendString:formUrl];
        [url appendString:@"/gfembed/?f="];
        [url appendString:formId];
        [url appendString:@"\" width=\"100%\"  height =\"850\" frameBorder=\"0\" scrolling=\"no\" onload=\"resizeIframe(this)\" class=\"gfiframe\"></iframe><script src=\"https://forms.xamoom.com/wp-content/plugins/gravity-forms-iframe-develop/assets/scripts/gfembed.js\" type=\"text/javascript\"></script><script>function resizeIframe(obj) {obj.style.height = obj.contentWindow.document.documentElement.scrollHeight + 'px';}</script>"];
        [self addWebView:url];
        
    } else {
        [self.contentView setHidden:YES];
    }
}

   
- (void) addWebView:(NSString *) url {
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];

    WKWebViewConfiguration *webConfiguration = [[WKWebViewConfiguration alloc] init];
    webConfiguration.userContentController = wkUController;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.webViewContainer.bounds.size.width, self.webViewContainer.bounds.size.width) configuration: webConfiguration];
    if (webView != nil) {
        webView.navigationDelegate = self;
        [self.progressIndicator startAnimating];
        [webView loadHTMLString:url baseURL:nil];
        [self.webViewContainer addSubview:webView];
    }
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.progressIndicator stopAnimating];
    [webView evaluateJavaScript:@"document.readyState" completionHandler:^(NSString *result, NSError *error){
        [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(NSString *height, NSError *error) {
            webView.scrollView.contentSize = CGSizeMake(webView.scrollView.contentSize.width, [height floatValue]);
        }];
    }];
}

- (UIColor *)colorFromHexString:(NSString *)hexString alpha: (double) alpha {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; 
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

-(NSString *) getModifiedFormUrl:(NSString *) formBaseUrl {
    NSMutableString* mutableUrl = [NSMutableString stringWithString:formBaseUrl];
    if([[formBaseUrl substringWithRange:NSMakeRange([formBaseUrl length] - 1, 1)]  isEqual: @"/"]) {
        [mutableUrl deleteCharactersInRange:NSMakeRange([formBaseUrl length] - 1, 1)];
    }
    return [NSString stringWithString:mutableUrl];
}

@end
