//
//  AppUtils.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "AppUtils.h"

@implementation AppUtils

+ (BOOL)checkUserName:(NSString *_Nonnull)userName {
    return [EFUtils checkValue:userName byRegExp:@"^1\\d{10}$"];
}

+ (BOOL)checkUserPassword:(NSString *_Nonnull)userPassword {
    return [EFUtils checkValue:userPassword byRegExp:@"^[0-9a-zA-Z]{6,18}"];
}


+ (void)presentLoginVC {
    // 移除不正确的 token
    NSString *token = [USER_DEFAULTS objectForKey:@"token"];
    if (token) {
        [USER_DEFAULTS removeObjectForKey:@"token"];
        [USER_DEFAULTS synchronize];
    }
    
    RUN_AFTER(SVShowStatusDelayTime, ^{
        EFBaseNavigationController *loginNC = [EFUtils sharedStoryboardInstanceWithStoryName:@"Login" storyboardID:@"Login_NC"];
        loginNC.originalViewController = (EFBaseViewController *)ROOT_VC;
        [ROOT_VC presentViewController:loginNC animated:YES completion:nil];
    });
}

@end
