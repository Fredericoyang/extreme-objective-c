//
//  AppUtils.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "AppUtils.h"

@implementation AppUtils

/// 示例代码
+ (BOOL)checkUserName:(NSString *_Nonnull)userName {
    return [EFUtils validateString:userName byRegExp:@"^1\\d{10}$"];
}

+ (BOOL)checkUserPassword:(NSString *_Nonnull)userPassword {
    return [EFUtils validateString:userPassword byRegExp:@"^[0-9a-zA-Z]{6,18}"];
}
/// 示例代码


//MARK:登录跳转
+ (void)presentLoginVC {
    // 移除不正确的 token
    NSString *token = [USER_DEFAULTS objectForKey:@"Token"];
    if (token) {
        [USER_DEFAULTS removeObjectForKey:@"Token"];
        [USER_DEFAULTS synchronize];
    }
    
    RUN_AFTER(SVShowStatusDelayTime, ^{
        EFBaseNavigationController *loginNC = [EFUtils sharedControllerInstanceWithStoryName:@"Login" andStoryboardID:@"Login_NC"];
        loginNC.originalViewController = (EFBaseViewController *)ROOT_VC;
        [ROOT_VC presentViewController:loginNC animated:YES completion:nil];
    });
}

@end
