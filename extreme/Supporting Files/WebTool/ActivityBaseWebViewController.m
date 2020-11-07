//
//  ActivityBaseWebViewController.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/12/22.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "ActivityBaseWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ActivityBaseWebViewController ()

@end

@implementation ActivityBaseWebViewController {
    JSContext *_jsContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reloaded = YES;
    [self loadURL:self.url];
    
    _jsContext = [[JSContext alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUrl:(NSString *)url {
    _url = url;
}


#pragma mark - Web view delegate

- (BOOL)webView:(UIWebView *_Nonnull)webView shouldStartLoadWithRequest:(NSURLRequest *_Nonnull)request navigationType:(UIWebViewNavigationType)navigationType {
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *_Nonnull)webView {
    [super webViewDidStartLoad:webView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *_Nonnull)webView {
    [super webViewDidFinishLoad:webView];
    
    if (self.needReloadByStep && !self.isReloaded) {
        self.reloaded = YES;
        [self.webView reload];
    }
    
    _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        LOG(@"JS调App异常：%@", exceptionValue);
    };
    @WeakObj(self);
    _jsContext[@"iOS_login"] = ^() {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            EFBaseNavigationController *userNC = [EFUtils sharedStoryboardInstanceWithStoryName:@"Login" storyboardID:@"Login_NC"];
            userNC.originalViewController = self;
            [self presentViewController:userNC animated:YES completion:nil];
        });
    };
}

- (void)webView:(UIWebView *_Nonnull)webView didFailLoadWithError:(NSError *_Nullable)error {
    [super webView:webView didFailLoadWithError:error];
    
    LOG(@"[ERROR] %@", error.localizedDescription);
}

@end
