//
//  AFHTTPTool.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPConfig.h"

/*
 进度的block
 progress: 进度参数
 */
typedef void(^_Nullable ProgressBlock)(NSProgress *_Nullable progress);

/*
 返回结果
 success: API执行是否成功
 responseObj: 返回结果
 */
typedef void(^_Nullable RequestResultBlock)(BOOL success, id _Nullable responseObj);


#pragma mark - AFHTTPError
@interface AFHTTPError : NSObject

@property (copy, nonatomic, nonnull) NSString *url;
@property (copy, nonatomic, nonnull) NSString *errorCode;
@property (copy, nonatomic, nonnull) NSString *errorDescription;
@property (copy, nonatomic, nullable) NSString *errorMessage;
@property (strong, nonatomic, nullable) id errorResponse;
@property (assign, nonatomic) BOOL isUserLevel;

- (instancetype _Nonnull)initWithError:(NSError *_Nonnull)error url:(NSString *_Nonnull)url;
- (instancetype _Nonnull)initWithErrorCode:(NSString *_Nonnull)errorCode errorDescription:(NSString *_Nonnull)errorDescription url:(NSString *_Nonnull)url;

@end


#pragma mark - AFHTTPRequestProperties
@interface AFHTTPRequestProperties : NSObject

@property (assign, nonatomic) AFHTTPMethodType methodType;
@property (copy, nonatomic, nonnull) NSString *url;
@property (strong, nonatomic, nullable) id params;
@property (assign, nonatomic) AFHTTPRequestType requestType;
@property (assign, nonatomic) BOOL authorized;
@property (strong, nonatomic) RequestResultBlock result;
@property (copy, nonatomic, nonnull) NSString *info_string;

@end


#pragma mark - AFHTTPRetryView
@interface AFHTTPRetryView : UIView

@property (assign, nonatomic) CGFloat borderWidth;
@property (strong, nonatomic, nullable) UIColor *borderColor;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic, nonnull) AFHTTPRequestProperties *requestProperties;
@property (copy, nonatomic, readonly, nonnull) NSString *retry_info;
@property (strong, nonatomic, nonnull) void(^retryBlock)(id _Nullable sender);

@end


#pragma mark - AFHTTPTool
@interface AFHTTPTool : NSObject

/**
 获取 manager实例

 @param requestType 请求类型
 @return AFHTTPSessionManager实例
 */
+ (AFHTTPSessionManager *_Nonnull)managerForRequestType:(AFHTTPRequestType)requestType;

/**
 是否客户端级别错误(排除常见系统级别错误以外的错误)，常见系统级别错误包括但不限于“未连接互联网”、“请求访问超时”、“服务器访问失败”、“服务器未正确配置”、“接口不存在”、“服务器错误”、“token不正确”、“token超时”。
 @param http_error AFHTTPError实例
 @return YES 客户端级别错误 NO 常见系统级别错误
 */
+ (BOOL)isClientLevel:(AFHTTPError *_Nonnull)http_error;
/**
 打印请求日志

 @param requestProperties AFHTTPRequestProperties实例
 */
+ (void)printRequestLog:(AFHTTPRequestProperties *_Nonnull)requestProperties;
/**
 打印响应日志

 @param requestProperties AFHTTPRequestProperties实例
 @param responseObject 响应对象实例
 */
+ (void)printResponseLog:(AFHTTPRequestProperties *_Nonnull)requestProperties response:(id _Nullable)responseObject;

/**
 通用GET请求接口
 
 @param url 访问URL
 @param params 参数
 @param requestType 请求类型
 @param authorized 是否经授权的
 @param result 返回结果
 @return NSURLSessionDataTask实例
 */
+ (NSURLSessionDataTask *_Nonnull)GET:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result;

/**
 通用POST请求接口
 
 @param url 访问URL
 @param params 参数
 @param requestType 请求类型
 @param authorized 是否经授权的
 @param result 返回结果
 @return NSURLSessionDataTask实例
 */
+ (NSURLSessionDataTask *_Nonnull)POST:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result;


/**
 通用PUT请求接口

 @param url 访问URL
 @param params 参数
 @param requestType 请求类型
 @param authorized 是否经授权的
 @param result 返回结果
 @return NSURLSessionDataTask实例
 */
+ (NSURLSessionDataTask *_Nonnull)PUT:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result;

/**
 通用PATCH请求接口
 
 @param url 访问URL
 @param params 参数
 @param requestType 请求类型
 @param authorized 是否经授权的
 @param result 返回结果
 @return NSURLSessionDataTask实例
 */
+ (NSURLSessionDataTask *_Nonnull)PATCH:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result;

/**
 通用DELETE请求接口
 
 @param url 访问URL
 @param params 参数
 @param requestType 请求类型
 @param authorized 是否经授权的
 @param result 返回结果
 @return NSURLSessionDataTask实例
 */
+ (NSURLSessionDataTask *_Nonnull)DELETE:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result;

@end
