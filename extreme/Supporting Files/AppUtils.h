//
//  AppUtils.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppUtils : NSObject

/**
 检查用户名是否合法

 @param userName 用户名
 @return 检查结果，YES 合法 NO 不合法
 */
+ (BOOL)checkUserName:(NSString *_Nonnull)userName;

/**
 检查用户密码是否合法

 @param userPassword 用户密码
 @return 检查结果，YES 合法 NO 不合法
 */
+ (BOOL)checkUserPassword:(NSString *_Nonnull)userPassword;


/**
 弹出登录页
 */
+ (void)presentLoginVC;

@end
