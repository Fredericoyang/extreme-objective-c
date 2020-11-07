//
//  NormalBaseWebViewController.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/12/22.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

@interface NormalBaseWebViewController : EFBaseWebViewController

/**
 要显示Web页面的URL
 */
@property (copy, nonatomic, nonnull) NSString *url;

/**
 Web页面导航操作时是否刷新页面，如“前进”、“后退”
 */
@property (assign, nonatomic) BOOL needReloadByStep;


// Web view代理基类
- (BOOL)webView:(UIWebView *_Nonnull)webView shouldStartLoadWithRequest:(NSURLRequest *_Nonnull)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *_Nonnull)webView;
- (void)webViewDidFinishLoad:(UIWebView *_Nonnull)webView;
- (void)webView:(UIWebView *_Nonnull)webView didFailLoadWithError:(NSError *_Nullable)error;

@end
