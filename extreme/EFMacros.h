//
//  EFMacros.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "EFBaseNavigationController.h"

//MARK: Device Target
#if TARGET_IPHONE_SIMULATOR
    #define SIMULATOR 1
#elif TARGET_OS_IPHONE
    #define SIMULATOR 0
#endif


//MARK: OS
#define OS_VERSION    [UIDevice currentDevice].systemVersion.floatValue


//MARK: App
#define APP_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUILD     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define APP_NAME      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]


//MARK: Application，see APP_DELEGATE in AppMacros
#define APPLICATION            [UIApplication sharedApplication]
#define WINDOW                 APPLICATION.keyWindow
#define SAFEAREA_INSETS        WINDOW.safeAreaInsets
#define STATUSBAR_HEIGHT       [APPLICATION statusBarFrame].size.height
#define USER_DEFAULTS          [NSUserDefaults standardUserDefaults]
#define NOTIFICATION_CENTER    [NSNotificationCenter defaultCenter]


//MARK: ViewController
#define NAVIGATION_CONTROLLER    ((EFBaseNavigationController *)self.navigationController)
#define NAVI_CTRL_ROOT_VC        NAVIGATION_CONTROLLER.viewControllers[0]
#define NAVIGATION_HEIGHT        FRAME_HEIGHT(NAVIGATION_CONTROLLER.navigationBar)
#define TOP_LAYOUT_HEIGHT        (STATUSBAR_HEIGHT+NAVIGATION_HEIGHT)
#define TABBAR_HEIGHT            FRAME_HEIGHT(self.tabBarController.tabBar)
#define TOOLBAR_HEIGHT           FRAME_HEIGHT(NAVIGATION_CONTROLLER.toolbar)


//MARK: CGRect
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

#define CENTER(v)          (v.center)


//MARK: UIFont
#define FONT_SIZE(s)              [UIFont systemFontOfSize:s]
#define FONT_SIZE_WEIGHT(s, w)    [UIFont systemFontOfSize:s weight:w]
#define FONT_NAME_SIZE(f, s)      [UIFont fontWithName:f size:s]


//MARK: UIColor
/**
 十六进制颜色码转RGB
 
 @param rgbValue 十六进制码，0xFF0000
 @return UIColor
 */
#define COLOR_RGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**
 十六进制颜色码转RGB，带不透明度
 
 @param rgbValue 十六进制码，0xFF0000
 @param alphaValue 不透明度，0.1～1
 @return UIColor
 */
#define COLOR_RGB_ALPHA(rgbValue, alphaValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]


//MARK: UIKit
#define IMAGE(i)    [UIImage imageNamed:i]


//MARK: Tools
#define FORMAT_STRING(f, ...)    [NSString stringWithFormat:f, ##__VA_ARGS__]
#define LOG(f, ...)              NSLog((@"[LOG]%s(line %d): " f), __FUNCTION__, __LINE__, ##__VA_ARGS__)


//MARK: object weak or strong in block
#define WeakObj(o)      autoreleasepool{} __weak typeof(o) o##Weak = o
#define StrongObj(o)    autoreleasepool{} __strong typeof(o) o = o##Weak


//MARK: GCD
/**
 延后一段时间执行块中的代码
 
 @param s 单位：秒 (seconds)
 @param b block
 */
#define RUN_AFTER(s, b)    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(s * NSEC_PER_SEC)), dispatch_get_main_queue(), b)
