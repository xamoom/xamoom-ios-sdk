//
//  XMMContentBlock16TableViewCell.m
//  XamoomSDK
//
//  Created by Vladyslav on 16.11.2022.
//

#import "XMMContentBlock16TableViewCell.h"

@interface XMMContentBlock16TableViewCell()


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
    self.coverViewLabel.text = NSLocalizedStringFromTableInBundle(@"quiz.coverview.label", @"Localizable", nibBundle, nil);
    
    NSString* formId = block.iframeUrl;
    Boolean* fullscreen  = block.fullScreen;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    NSString* formUrl = [self getModifiedFormUrl:(NSString *)([defaults objectForKey:@"formUrl"])];
    NSString* primaryColor = [defaults objectForKey:@"template_primaryColor"];
    self.progressIndicator.color = [self colorFromHexString:[defaults objectForKey:@"template_primaryColor"] alpha:1];
//    BOOL isFormActive = (BOOL)([defaults objectForKey:@"isFormActive"]);
//    if (formUrl == nil || [formUrl isEqualToString:@""]) {
//        formUrl = [NSString stringWithFormat:@"https://forms.xamoom.com"];
//    }
//    if (isFormActive == nil) {
//        isFormActive = YES;
//    }
//
//    if (isFormActive) {
//        NSMutableString *url = [NSMutableString new];
//        [url appendString:formUrl];
//        [url appendString:@"/gfembed/?f="];
//        [url appendString:formId];
//        [self addWebView:url];
//
//    } else {
//        [self.contentView setHidden:YES];
//    }
}

   
- (void) addWebView:(NSString *) url {
    
    NSString *resizeScript = @"function resize() { window.webkit.messageHandlers.test.postMessage(document.body.scrollHeight);} window.onload = resize;";
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, shrink-to-fit=YES'); meta.setAttribute('initial-scale', '1.0'); meta.setAttribute('maximum-scale', '1.0'); meta.setAttribute('minimum-scale', '1.0'); meta.setAttribute('user-scalable', 'no'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    NSString *locationRequestScript = @"const delegate = (selector) => (cb) => (e) => e.target.matches(selector) && cb(e); const inputDelegate = delegate('input[type=button]'); document.addEventListener('touchend', inputDelegate((el) => window.webkit.messageHandlers.buttonPressed.postMessage('buttonPressed')));";
    
//    NSString *formChangeScript = @"document.forms[0].addEventListener('select', ()=>{window.webkit.messageHandlers.formChanged.postMessage('formChanged'));});";
    NSString *formChangeScript = @"const delegate1 = (selector) => (cb) => (e) => e.target.matches(selector) && cb(e); const inputDelegate1 = delegate1('input[type=text]'); document.addEventListener('click', inputDelegate1((el) => window.webkit.messageHandlers.formChanged.postMessage('formChanged')));";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserScript *wkUScriptResize = [[WKUserScript alloc] initWithSource:resizeScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserScript *wkUScriptlocationRequest = [[WKUserScript alloc] initWithSource:locationRequestScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserScript *wkUScriptFormChange = [[WKUserScript alloc] initWithSource:formChangeScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    [wkUController addUserScript:wkUScriptResize];
    [wkUController addScriptMessageHandler:self name:@"test"];
    
    [wkUController addUserScript:wkUScriptlocationRequest];
    [wkUController addScriptMessageHandler:self name:@"buttonPressed"];
    
    [wkUController addUserScript:wkUScriptFormChange];
    [wkUController addScriptMessageHandler:self name:@"formChanged"];

    WKWebViewConfiguration *webConfiguration = [[WKWebViewConfiguration alloc] init];
    webConfiguration.userContentController = wkUController;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.webViewContainer.bounds.size.width, self.webViewContainer.bounds.size.height) configuration: webConfiguration];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    if (self.webView != nil) {
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;
        [self.progressIndicator startAnimating];
        NSMutableURLRequest *pageLoadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [pageLoadRequest setHTTPShouldHandleCookies:NO];
        [self.webView loadRequest:pageLoadRequest];
        [self.webViewContainer addSubview:self.webView];
    }
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if([message.name isEqualToString:@"test"]) {
        [self.webView evaluateJavaScript:@"document.documentElement.outerHTML.toString()" completionHandler:^(id html, NSError *error) {
            [self.contentBlocksDelegate onQuizHTMLResponse:html];
        }];
        if(message.body != nil) {
            float newHeight = [message.body floatValue] + 15;
            float oldHeight = self.webViewContainerHeightConstraint.constant;
            if(newHeight != oldHeight) {
                self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webViewContainer.frame.size.width, newHeight);
                if(fabs([message.body floatValue] - self.webViewContainerHeightConstraint.constant) > 3) {
                    self.webViewContainerHeightConstraint.constant = newHeight;
                    
                    [self.parentTableView beginUpdates];
                    [self.parentTableView endUpdates];
                    
                    [self.parentTableView layoutIfNeeded];
                        
                }
            }
        }
    } else if ([message.name isEqualToString:@"buttonPressed"] && !isRequestLocationClick) {
//        [[UIApplication sharedApplication] sendAction:@selector(becomeCurrent) to:nil from:nil forEvent:nil];
        self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webViewContainer.frame.size.width, self.webViewContainerHeightConstraint.constant + 350);
        self.webViewContainerHeightConstraint.constant = self.webViewContainerHeightConstraint.constant + 350;
//        [self.webView endEditing:NO];
//        self.parentTableView.frame = CGRectMake(self.parentTableView.frame.origin.x, self.parentTableView.frame.origin.y, self.parentTableView.frame.size.width, self.webViewContainerHeightConstraint.constant);
        [self.parentTableView beginUpdates];
        [self.parentTableView endUpdates];
        [self.parentTableView layoutIfNeeded];
        isRequestLocationClick = true;
//        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        
    } else if ([message.name isEqualToString:@"formChanged"] && isRequestLocationClick) {
        self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webViewContainer.frame.size.width, self.webViewContainerHeightConstraint.constant - 350);
        self.webViewContainerHeightConstraint.constant = self.webViewContainerHeightConstraint.constant - 350;
        [self.parentTableView beginUpdates];
        [self.parentTableView endUpdates];
        [self.parentTableView layoutIfNeeded];
        isRequestLocationClick = false;
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

//-(NSString *) getModifiedFormUrl:(NSString *) formBaseUrl {
//    NSMutableString* mutableUrl = [NSMutableString stringWithString:formBaseUrl];
//    if([[formBaseUrl substringWithRange:NSMakeRange([formBaseUrl length] - 1, 1)]  isEqual: @"/"]) {
//        [mutableUrl deleteCharactersInRange:NSMakeRange([formBaseUrl length] - 1, 1)];
//    }
//    return [NSString stringWithString:mutableUrl];
//}

@end
