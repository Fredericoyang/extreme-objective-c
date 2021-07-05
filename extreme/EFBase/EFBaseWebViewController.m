//
//  EFBaseWebViewController.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFBaseWebViewController.h"
#import "EFUtils.h"
#import "PodHeaders.h"

@interface EFBaseWebViewController ()

@end

@implementation EFBaseWebViewController {
    WKUserContentController *_userContentController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_HEXSTRING(@"#FFFFFF");
    self.title = @"页面载入中";
    
    //这个类主要用来做 native与 JavaScript的交互管理
    _userContentController = [[WKUserContentController alloc] init];
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = _userContentController;
    config.processPool = [[WKProcessPool alloc] init];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
    _webView.scrollView.backgroundColor = COLOR_HEXSTRING_ALPHA(@"#FFFFFF", 0);
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    [self.view sd_addSubviews:@[_webView]];
    
    _webView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, SAFEAREA_INSETS.bottom, 0));
    
    self.navigationItem.leftItemsSupplementBackButton = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.webView.isLoading) {
        [SVProgressHUD dismiss];
        [self.webView stopLoading];
    }
}


#pragma mark - 加载页面与脚本

- (void)setScriptMessageHandlers:(NSArray *)scriptMessageHandlers {
    if (!scriptMessageHandlers) {
        _scriptMessageHandlers = nil;
        return;
    }
    _scriptMessageHandlers = scriptMessageHandlers;
    for (NSString *message_name in scriptMessageHandlers) {
        [_userContentController addScriptMessageHandler:self name:message_name];
    }
}

- (void)removeAllScriptMessageHandlers {
    for (NSString *message_name in self.scriptMessageHandlers) {
        [_userContentController removeScriptMessageHandlerForName:message_name];
    }
}

- (void)loadURL:(NSString *)URL_string {
    NSURL *URL = [[NSURL alloc] initWithString:URL_string];
    [_webView loadRequest:[NSURLRequest requestWithURL:URL]];
}


#pragma mark - 导航

- (void)back:(id)sender {
    if (self.webView.isLoading) {
        [SVProgressHUD dismiss];
        [self.webView stopLoading];
    }
    if (self.webView.canGoBack) {
        if (self.isReloaded) {
            self.reloaded = NO;
        }
        [self.webView goBack];
    }
    else {
        [self close:sender];
    }
}

- (void)close:(id)sender {
    if (self.webView.isLoading) {
        [SVProgressHUD dismiss];
        [self.webView stopLoading];
    }
    if (self.previousViewController) {
        [NAVIGATION_CONTROLLER popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    if (![webView.URL.scheme isEqualToString:@"tel"] && ![webView.URL.scheme isEqualToString:@"itms-apps"] && ![webView.URL.host isEqualToString:@"coding.net"]) {
        [SVProgressHUD show];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError *_Nullable error) {
        self.title = result;
    }];
    
    if (self.webView.canGoBack || self.webView.canGoForward) {
        UIBarButtonItem *back_barButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"extreme.bundle/back") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
        UIBarButtonItem *close_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
        self.navigationItem.leftBarButtonItems = @[back_barButtonItem, close_barButtonItem];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    LOG_FORMAT(@"[ERROR] %@", error.localizedDescription);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}

@end
