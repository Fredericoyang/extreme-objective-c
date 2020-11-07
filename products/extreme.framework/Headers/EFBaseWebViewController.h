//
//  EFBaseWebViewController.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "EFBaseViewController.h"

@interface EFBaseWebViewController : EFBaseViewController

@property (strong, nonatomic, nonnull) UIWebView *webView;

/**
 Web页是否已重新加载过
 */
@property (assign, nonatomic, getter=isReloaded) BOOL reloaded;

/**
 请求 URL，并在 Web View 中显示，通过项目中的基类设置。(Setup in based view controller.)

 @param URL_string 请求网址
 */
- (void)loadURL:(NSString *_Nonnull)URL_string;

// Base of web view delegate
- (BOOL)webView:(UIWebView *_Nonnull)webView shouldStartLoadWithRequest:(NSURLRequest *_Nonnull)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *_Nonnull)webView;
- (void)webViewDidFinishLoad:(UIWebView *_Nonnull)webView;
- (void)webView:(UIWebView *_Nonnull)webView didFailLoadWithError:(NSError *_Nullable)error;

@end
