//
//  AppConfig.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

//MARK: For examples under here
//MARK: ENUM

//TODO: 1.Type demo
typedef NS_ENUM(NSInteger, type) {
    type1 = 1,
    type2,
    type3
};


//MARK: - Server Config
//MARK: HTTPTool URLs

//TODO: 1.API
static NSString *const DEV_BaseURL        = @"http://www.xfmwk.com:2000";
static NSString *const RC_BaseURL         = @"";
static NSString *const PRO_BaseURL        = @"";

//TODO: 2.File
static NSString *const FileDEV_BaseURL    = @"";
static NSString *const FileRC_BaseURL     = @"";
static NSString *const FilePRO_BaseURL    = @"";

//TODO: 3.Ability
static NSString *const AbilityDEV_BaseURL = @"http://www.xfmwk.com:2000";
static NSString *const AbilityRC_BaseURL  = @"";
static NSString *const AbilityPRO_BaseURL = @"";


//MARK: HTTPRequest

//TODO: 1.Per page size
static NSUInteger const ContactHTTPRequestPerPageSize = 10;

//TODO: 2.AFHTTPTool request timeout
static NSTimeInterval const AFHTTPToolRequestTimeout = 20;


//MARK: >>>>>>Do not commit git and push to remote if you change under config<<<<<<

//TODO: 1.API environment
static NSInteger const api_env = 1; // 1 开发环境(DEV) 2 预生产环境(RC) 3 生产环境(PRO)

//TODO: 2.Enable print API log or not
#define PrintRequestLog  1   // 1 打印(print) 0 不打印(do not print)
#define PrintResponseLog 1


//MARK: AppKey or account, token, ...etc for a thirdpart SDK
static NSString *const appKey = @"enter app key here";


//MARK: - UIKit

//TODO: 1.Theme Colors
#define THEME_COLOR COLOR_RGB(0x313131)
#define THEME_COLOR_LIGHT COLOR_RGB(0xffffff)

//TODO: 2.SVProgressHUD
static NSTimeInterval const SVProgressHUDMinimumDismissTimeInterval = 3.0;

//TODO: 3.Show HTTP error delay time
static const NSTimeInterval SVShowStatusDelayTime = 0.5;
