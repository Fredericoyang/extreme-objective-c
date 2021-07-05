//
//  EFMacros.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

@class EFBaseNavigationController;
@class EFNavigationBar;

//MARK: - OS
#define OS_VERSION    [UIDevice currentDevice].systemVersion.floatValue


//MARK: - App
#define APP_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUILD     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define APP_NAME      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]


//MARK: - Application
#define APPLICATION            [UIApplication sharedApplication]
#define APP_DELEGATE           APPLICATION.delegate
#define WINDOW                 APPLICATION.keyWindow
#define STATUSBAR_HEIGHT       [APPLICATION statusBarFrame].size.height
#define SAFEAREA_INSETS        WINDOW.safeAreaInsets
#define USER_DEFAULTS          [NSUserDefaults standardUserDefaults]
#define NOTIFICATION_CENTER    [NSNotificationCenter defaultCenter]


//MARK: - ViewController
#define NAVIGATION_CONTROLLER    ((EFBaseNavigationController *)self.navigationController)
#define NAVI_CTRL_ROOT_VC        NAVIGATION_CONTROLLER.viewControllers.firstObject
#define NAVIGATION_BAR           (self.navigationBar)
#define NAVIGATION_HEIGHT        FRAME_HEIGHT(NAVIGATION_BAR)
#define TOP_LAYOUT_HEIGHT        (STATUSBAR_HEIGHT+NAVIGATION_HEIGHT)
#define TOOLBAR_HEIGHT           FRAME_HEIGHT(NAVIGATION_CONTROLLER.toolbar)
#define TABBAR_HEIGHT            FRAME_HEIGHT(self.tabBarController.tabBar)


//MARK: - CGRect
#define SCREEN_WIDTH     FRAME_WIDTH(WINDOW)
#define SCREEN_HEIGHT    FRAME_HEIGHT(WINDOW)
#define SCREEN_CENTER    CENTER(WINDOW)

#define FRAME_ORIGIN(v)    (v.frame.origin)
#define FRAME_X(v)         (v.frame.origin.x)
#define FRAME_Y(v)         (v.frame.origin.y)

#define FRAME_SIZE(v)      (v.frame.size)
#define FRAME_WIDTH(v)     (v.frame.size.width)
#define FRAME_HEIGHT(v)    (v.frame.size.height)

#define BOUNDS_ORIGIN(v)    (v.bounds.origin)
#define BOUNDS_X(v)         (v.bounds.origin.x)
#define BOUNDS_Y(v)         (v.bounds.origin.y)

#define BOUNDS_SIZE(v)      (v.bounds.size)
#define BOUNDS_WIDTH(v)     (v.bounds.size.width)
#define BOUNDS_HEIGHT(v)    (v.bounds.size.height)

#define CENTER(v)           (v.center)
#define CENTER_X(v)         (v.center.x)
#define CENTER_Y(v)         (v.center.y)


//MARK: - UIKit
//MARK: UIFont
#define FONT_SIZE(s)              [UIFont systemFontOfSize:s]
#define FONT_SIZE_WEIGHT(s, w)    [UIFont systemFontOfSize:s weight:w]
#define FONT_NAME_SIZE(f, s)      [UIFont fontWithName:f size:s]

//MARK: UIColor
#define COLOR_RGB(rgbValue) [EFUtils colorWithRGB:rgbValue] //COLOR_RGB(rgbValue) is deprecated, use COLOR_HEXSTRING(hexString) instead, see EFUtils.h for more.
#define COLOR_RGB_ALPHA(rgbValue, alphaValue) [EFUtils colorWithRGB:rgbValue alpha:alphaValue] //COLOR_RGB_ALPHA(rgbValue, alphaValue) is deprecated, use COLOR_HEXSTRING_ALPHA(hexString, alphaValue) instead, see EFUtils.h for more.

//MARK: UIImage
#define IMAGE(i)    [UIImage imageNamed:i]


//MARK: - Tools
//MARK: String with format, Log with format, ...
#define STRING_FORMAT(f, ...)    [NSString stringWithFormat:f, ##__VA_ARGS__]
#define LOG_FORMAT(f, ...)       NSLog((@"[LOG]%s(line %d): " f), __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define EFDeprecated(d)          __attribute__((deprecated(d)))
//TODO: Deprecated
#define FORMAT_STRING(f, ...)    [NSString stringWithFormat:(f @" [WARNING]FORMAT_STRING(f, ...) is deprecated, use STRING_FORMAT(f, ...) instead."), ##__VA_ARGS__]
#define LOG(f, ...)              NSLog(@"[LOG]%s(line %d): " f @" [WARNING]LOG(f, ...) is deprecated, use LOG_FORMAT(f, ...) instead.", __FUNCTION__, __LINE__, ##__VA_ARGS__)

//MARK: Object weak or strong in block
#define WeakObject(o)      autoreleasepool{} __weak typeof(o) o##Weak = o
#define StrongObject(o)    autoreleasepool{} __strong typeof(o) o = o##Weak
//TODO: Deprecated
#define WeakObj(o)      autoreleasepool{} __weak typeof(o) o##Weak = o; NSLog(@"[WARNING]%s(line %d): @WeakObj() is deprecated, use @WeakObject() instead.", __FUNCTION__, __LINE__)
#define StrongObj(o)    autoreleasepool{} __strong typeof(o) o = o##Weak; NSLog(@"[WARNING]%s(line %d): @StrongObj() is deprecated, use @StrongObject() instead.", __FUNCTION__, __LINE__)

//MARK: GCD
/**
 延后一段时间执行块中的代码
 
 @param s 单位：秒 (seconds)
 @param b block
 */
#define RUN_AFTER(s, b)    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(s * NSEC_PER_SEC)), dispatch_get_main_queue(), b)
