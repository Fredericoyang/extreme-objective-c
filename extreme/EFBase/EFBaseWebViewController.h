//
//  EFBaseWebViewController.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFBaseViewController.h"
#import <WebKit/WebKit.h>

@class WKWebView;
@class WKNavigation;
@class WKUserContentController;
@class WKScriptMessage;

@interface EFBaseWebViewController : EFBaseViewController <WKNavigationDelegate, WKScriptMessageHandler>

@property (strong, nonatomic, nonnull) WKWebView *webView;

/**
 注入 JS回调方法
 */
@property (strong, nonatomic, nullable) NSArray<NSString *> *scriptMessageHandlers;
/**
 移除所有 JS回调方法
 */
- (void)removeAllScriptMessageHandlers;

/**
 Web页是否已重新加载过
 */
@property (assign, nonatomic, getter=isReloaded) BOOL reloaded;

/**
 请求 URL，并在 web view中显示，通过项目中的基类设置。(Setup in EFBaseWebViewController based view controller.)

 @param URL_string 请求网址
 */
- (void)loadURL:(NSString *_Nonnull)URL_string;

//MARK: Based on web kit navigation delegate
- (void)webView:(WKWebView *_Nonnull)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation;
- (void)webView:(WKWebView *_Nonnull)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
- (void)webView:(WKWebView *_Nonnull)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *_Nonnull)error;
- (void)webViewWebContentProcessDidTerminate:(WKWebView *_Nonnull)webView;

//MARK: Web kit script message handler
- (void)userContentController:(WKUserContentController *_Nonnull)userContentController didReceiveScriptMessage:(WKScriptMessage *_Nonnull)message;

@end
