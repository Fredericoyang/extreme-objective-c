//
//  LABiometryTool.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/13.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "LABiometryConfig.h"

#pragma mark - LABiometryError
@interface LABiometryError : NSObject

/**
 错误码
 */
@property (assign, nonatomic) LABiometryErrorType errorCode;
/**
 错误描述
 */
@property (copy, nonatomic, nullable) NSString *errorDescription;

/**
 通过 NSError初始化

 @param error NSError 实例
 @return LABiometryError 实例
 */
- (instancetype _Nonnull)initWithError:(NSError *_Nonnull)error;

@end


@interface LABiometryTool : NSObject

/**
 TouchID/FaceID 验证结果回调
 */
typedef void(^_Nonnull LABiometryResultBlock)(BOOL success, id _Nullable resultObject);

/**
 获取触控 ID或者面容ID组件实例

 @return 触控 ID或者面容ID实例
 */
+ (instancetype _Nonnull)sharedLABiometryTool;

/**
 是否支持触控 ID或者面容ID验证
 */
@property (assign, nonatomic) BOOL isLABiometryDeviceAvailable;

/**
 备用按钮说明，最佳6个字长以内，最多不超过10个字长，以汉字为例 (best 6 word length, and less than 10 word length for Chinese example)
 */
@property (copy, nonatomic, nullable) NSString *fallbackButtonTitle;

/**
 机主身份验证，通过触控 ID或者面容ID验证

 @param description 描述
 @param resultBlock 验证结果
 */
- (void)ownerAuthorizationWithDescription:(NSString *_Nonnull)description resultBlock:(LABiometryResultBlock)resultBlock;

@end
