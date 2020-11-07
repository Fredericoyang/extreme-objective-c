//
//  EFBaseWebViewController.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "EFBaseWebViewController.h"
#import "EFMacros.h"
#import "PodHeaders.h"

@interface EFBaseWebViewController () <UIWebViewDelegate>

@end

@implementation EFBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_RGB(0xffffff);
    self.title = @"页面载入中";
    
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = COLOR_RGB_ALPHA(0xffffff, 0);
    _webView.delegate = self;
    [self.view sd_addSubviews:@[_webView]];
    
    _webView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    if (self.webView.loading) {
        [self.webView stopLoading];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadURL:(NSString *)URL_string {
    NSURL *URL = [[NSURL alloc] initWithString:URL_string];
    [_webView loadRequest:[NSURLRequest requestWithURL:URL]];
}

#pragma mark - 导航
- (void)back:(id)sender {
    [SVProgressHUD dismiss];
    if (self.webView.loading) {
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
    [SVProgressHUD dismiss];
    if (self.webView.loading) {
        [self.webView stopLoading];
    }
    if (self.previousViewController) {
        [NAVIGATION_CONTROLLER popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Web view delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (![request.URL.scheme isEqualToString:@"tel"] && ![request.URL.scheme isEqualToString:@"itms-apps"] && ![request.URL.host isEqualToString:@"coding.net"]) {
        [SVProgressHUD show];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (self.webView.canGoBack || self.webView.canGoForward) {
        UIBarButtonItem *back_barButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"extreme.bundle/back") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
        UIBarButtonItem *close_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
        self.navigationItem.leftBarButtonItems = @[back_barButtonItem, close_barButtonItem];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    LOG(@"[ERROR] %@", error.localizedDescription);
}

@end
