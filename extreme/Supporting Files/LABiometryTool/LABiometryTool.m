//
//  LABiometryTool.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/13.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "LABiometryTool.h"

@implementation LABiometryError

- (instancetype _Nonnull)initWithError:(NSError *_Nonnull)error {
    self = [super init];
    if (self) {
        _errorCode = error.code;
        _errorDescription = error.localizedDescription;
    }
    return self;
}

@end


@implementation LABiometryTool {
    LAContext *_context;
}

+ (instancetype _Nonnull)sharedLABiometryTool {
    static LABiometryTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LABiometryTool alloc] init];
    });
    return instance;
}

- (void)canOwnerAuthorization:(LABiometryResultBlock)resultBlock {
    NSError *error = nil;
    if (!_context) {
        _context = [[LAContext alloc] init];
    }
    BOOL can = [_context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (can) {
        resultBlock(YES, nil);
    }
    else { // 被锁定时开启验证密码功能以解锁，解锁成功依然判定可以使用验证功能
        __block LABiometryError *la_error = [[LABiometryError alloc] initWithError:error];
        if (LABiometryError_BiometryLockout == la_error.errorCode) { // 被锁定时开启验证密码功能以解锁
            [_context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"需要先输入本机密码" reply:^(BOOL success, NSError *_Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        resultBlock(YES, nil);
                    }
                    else {
                        la_error = [[LABiometryError alloc] initWithError:error];
                        resultBlock(NO, la_error);
                    }
                });
            }];
        }
        else {
            resultBlock(NO, la_error);
        }
    }
}

- (BOOL)isLABiometryDeviceAvailable {
    [self canOwnerAuthorization:^(BOOL success, id resultObject) {
        if (success) {
            self.isLABiometryDeviceAvailable = YES;
        }
        else {
            LABiometryError *la_error = resultObject;
            if (LABiometryError_BiometryNotAvailable == la_error.errorCode) {
                self.isLABiometryDeviceAvailable = NO;
            }
            else {
                self.isLABiometryDeviceAvailable = YES;
            }
        }
    }];
    return _isLABiometryDeviceAvailable;
}

- (void)ownerAuthorizationWithDescription:(NSString *_Nonnull)description resultBlock:(LABiometryResultBlock)resultBlock {
    [self canOwnerAuthorization:^(BOOL success, id resultObject) {
        if (success) {
            NSString *localizedReason = @"";
            switch (self->_context.biometryType) {
                case LABiometryTypeNone:
                    break;
                case LABiometryTypeTouchID:
                    localizedReason = STRING_FORMAT(@"%@ 需要确认你是本人", description);
                    self->_context.localizedFallbackTitle = self->_fallbackButtonTitle?:nil;
                    break;
                case LABiometryTypeFaceID:
                    localizedReason = STRING_FORMAT(@"%@ 需要确认你是本人", description);
                    self->_context.localizedFallbackTitle = self->_fallbackButtonTitle?:nil;
                    break;
            }
            [self->_context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReason reply:^(BOOL success, NSError *_Nullable error) {
                self->_context = nil; // 销毁验证实例
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        resultBlock(YES, nil);
                    }
                    else {
                        LABiometryError *la_error = [[LABiometryError alloc] initWithError:error];
                        resultBlock(NO, la_error);
                    }
                });
            }];
        }
        else {
            LABiometryError *la_error = resultObject;
            resultBlock(NO, la_error);
        }
    }];
}

@end
