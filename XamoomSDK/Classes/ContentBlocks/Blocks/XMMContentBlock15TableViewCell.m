//
//  XMMContentBlock15TableViewCell.m
//  XamoomSDK
//
//  Created by G0yter on 11.12.2020.
//  Copyright © 2020 xamoom GmbH. All rights reserved.
//

#import "XMMContentBlock15TableViewCell.h"

@interface XMMContentBlock15TableViewCell()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITableView *parentTableView;
@property (nonatomic, retain) id<XMMContentBlocksDelegate> contentBlocksDelegate;

@end

@implementation XMMContentBlock15TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api listManager:(XMMListManager *)listManager offline:(BOOL)offline delegate:(id)delegate {
    self.contentBlocksDelegate = delegate;
    self.parentTableView = tableView;
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
        [url appendString:formUrl];
        [url appendString:@"/gfembed/?f="];
        [url appendString:formId];
        [self addWebView:url];
        
    } else {
        [self.contentView setHidden:YES];
    }
}

   
- (void) addWebView:(NSString *) url {
    
    NSString *resizeScript = @"function resize() { window.webkit.messageHandlers.test.postMessage(document.body.scrollHeight);} window.onload = resize;";
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, shrink-to-fit=YES'); meta.setAttribute('initial-scale', '1.0'); meta.setAttribute('maximum-scale', '1.0'); meta.setAttribute('minimum-scale', '1.0'); meta.setAttribute('user-scalable', 'no'); document.getElementsByTagName('head')[0].appendChild(meta);";
    

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserScript *wkUScriptResize = [[WKUserScript alloc] initWithSource:resizeScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    [wkUController addUserScript:wkUScriptResize];
    [wkUController addScriptMessageHandler:self name:@"test"];

    WKWebViewConfiguration *webConfiguration = [[WKWebViewConfiguration alloc] init];
    webConfiguration.userContentController = wkUController;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.webViewContainer.bounds.size.width, self.webViewContainer.bounds.size.height) configuration: webConfiguration];
    self.webView.scrollView.scrollEnabled = NO;
    if (self.webView != nil) {
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;
        [self.progressIndicator startAnimating];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self.webViewContainer addSubview:self.webView];
    }
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if([message.name isEqualToString:@"test"]) {
        [self.webView evaluateJavaScript:@"document.documentElement.outerHTML.toString()" completionHandler:^(id html, NSError *error) {
            [self.contentBlocksDelegate onQuizHTMLResponse:html];
        }];
        if(message.body != nil) {
            float newHeight = [message.body floatValue] + 10;
            float oldHeight = self.webViewContainerHeightConstraint.constant;
            if(newHeight != oldHeight) {
                self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webView.frame.size.width, newHeight);
                if(fabs([message.body floatValue] -                 self.webViewContainerHeightConstraint.constant) > 3) {
                    self.webViewContainerHeightConstraint.constant = newHeight;
                    
                    [self.parentTableView beginUpdates];
                    [self.parentTableView endUpdates];
                    
                    [self.parentTableView layoutIfNeeded];
                        
                }
            }
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.progressIndicator stopAnimating];
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
