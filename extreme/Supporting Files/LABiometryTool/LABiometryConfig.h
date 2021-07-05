//
//  LABiometryConfig.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/13.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>

typedef NS_ENUM(NSInteger, LABiometryErrorType) {
    LABiometryError_AuthenticationFailed = LAErrorAuthenticationFailed,  // 尝试失败次数过多
    LABiometryError_UserCancel           = LAErrorUserCancel,            // 用户取消
    LABiometryError_UserFallback         = LAErrorUserFallback,          // 备选验证
    LABiometryError_PasscodeNotSet       = LAErrorPasscodeNotSet,        // 没有设置密码
    LABiometryError_BiometryNotAvailable = LAErrorBiometryNotAvailable,  // 不支持验证功能
    LABiometryError_BiometryNotEnrolled  = LAErrorBiometryNotEnrolled,   // 没有添加生物特征数据
    LABiometryError_BiometryLockout      = LAErrorBiometryLockout        // 验证功能被锁定
};
