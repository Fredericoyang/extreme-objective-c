//
//  ActivityBaseWebViewController.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/12/22.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "ActivityBaseWebViewController.h"

@interface ActivityBaseWebViewController () <WKNavigationDelegate, WKScriptMessageHandler>

@end

@implementation ActivityBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.reloaded = YES;
    [self loadURL:self.url];
}


- (void)setUrl:(NSString *)url {
    _url = url;
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [super webView:webView didCommitNavigation:navigation];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
    
    if (self.needReloadByStep && !self.isReloaded) {
        self.reloaded = YES;
        [webView reload];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [super webView:webView didFailNavigation:navigation withError:error];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [super webViewWebContentProcessDidTerminate:webView];
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [super userContentController:userContentController didReceiveScriptMessage:message];
}

@end
