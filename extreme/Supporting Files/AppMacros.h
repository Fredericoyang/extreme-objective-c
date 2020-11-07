//
//  AppMacros.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

//MARK: Application
#define APP_DELEGATE        APPLICATION.delegate
#define ROOT_VC             APP_DELEGATE.window.rootViewController


//MARK: 服务器环境
#define TEST_ENV            [USER_DEFAULTS integerForKey:@"Test Env"]
#define API_ENV             (TEST_ENV>0 ? TEST_ENV : api_env)

#define HTTP_URL(url)       FORMAT_STRING(@"%@%@", API_ENV==1 ? DEV_BaseURL : (API_ENV==2 ? RC_BaseURL : (API_ENV==3 ? PRO_BaseURL:DEV_BaseURL)), url)
#define FILE_URL(url)       FORMAT_STRING(@"%@%@", API_ENV==1 ? FileDEV_BaseURL : (API_ENV==2 ? FileRC_BaseURL : (API_ENV==3 ? FilePRO_BaseURL:FileDEV_BaseURL)), url)
#define ABILITY_URL(url)    FORMAT_STRING(@"%@%@", API_ENV==1 ? AbilityDEV_BaseURL : (API_ENV==2 ? AbilityRC_BaseURL : (API_ENV==3 ? AbilityPRO_BaseURL:AbilityDEV_BaseURL)), url)
