//
//  NormalBaseWebViewController.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/12/22.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

@interface NormalBaseWebViewController : EFBaseWebViewController

/**
 要显示 Web页面的 URL
 */
@property (copy, nonatomic, nonnull) NSString *url;

/**
 Web页面导航操作时是否刷新页面，如“前进”、“后退”
 */
@property (assign, nonatomic) BOOL needReloadByStep;


//MARK: Based on web kit navigation delegate
- (void)webView:(WKWebView *_Nonnull)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation;
- (void)webView:(WKWebView *_Nonnull)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
- (void)webView:(WKWebView *_Nonnull)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *_Nonnull)error;
- (void)webViewWebContentProcessDidTerminate:(WKWebView *_Nonnull)webView;

@end
