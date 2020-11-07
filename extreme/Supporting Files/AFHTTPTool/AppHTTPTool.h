//
//  AppHTTPTool.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPTool.h"

@interface AppHTTPTool : NSObject

/************************************************
 * 公共请求接口写在这里
 */
 

 
/************************************************/


/**
 GET-HTTP请求接口，无需授权
 
 @param url 访问URL
 @param params 参数
 @param result 返回结果
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithGET:(NSString *_Nonnull)url params:(id _Nullable)params result:(RequestResultBlock)result;

/**
 GET-HTTP请求接口，授权可选
 
 @param url 访问URL
 @param params 参数
 @param authorized 是否经授权的
 @param result 返回结果
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithGET:(NSString *_Nonnull)url params:(id _Nullable)params authorized:(BOOL)authorized result:(RequestResultBlock)result;


/**
 POST-HTTP请求接口，无需授权
 
 @param url 访问URL
 @param params 参数
 @param result 返回结果
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithPOST:(NSString *_Nonnull)url params:(id _Nullable)params result:(RequestResultBlock)result;

/**
 POST-JSON请求接口，无需授权
 
 @param url 访问URL
 @param params 参数
 @param result 返回结果
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *_Nonnull)JSONRequestWithPOST:(NSString *_Nonnull)url params:(id _Nullable)params result:(RequestResultBlock)result;

/**
 POST-HTTP请求接口，授权可选
 
 @param url 访问URL
 @param params 参数
 @param authorized 是否经授权的
 @param result 返回结果
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithPOST:(NSString *_Nonnull)url params:(id _Nullable)params authorized:(BOOL)authorized result:(RequestResultBlock)result;

/**
 POST-JSON请求接口，授权可选
 
 @param url 访问URL
 @param params 参数
 @param authorized 是否经授权的
 @param result 返回结果
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *_Nonnull)JSONRequestWithPOST:(NSString *_Nonnull)url params:(id _Nullable)params authorized:(BOOL)authorized result:(RequestResultBlock)result;


/**
 PUT-HTTP请求接口，无需授权
 
 @param url 访问URL
 @param params 参数
 @param result 返回结果
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithPUT:(NSString *_Nonnull)url params:(id _Nullable)params result:(RequestResultBlock)result;

/**
 PUT-HTTP请求接口，授权可选
 
 @param url 访问URL
 @param params 参数
 @param authorized 是否经授权的
 @param result 返回结果
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithPUT:(NSString *_Nonnull)url params:(id _Nullable)params authorized:(BOOL)authorized result:(RequestResultBlock)result;

/**
 PATCH-HTTP请求接口，无需授权
 
 @param url 访问URL
 @param params 参数
 @param result 返回结果
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithPATCH:(NSString *_Nonnull)url params:(id _Nullable)params result:(RequestResultBlock)result;

/**
 PATCH-HTTP请求接口，授权可选
 
 @param url 访问URL
 @param params 参数
 @param authorized 是否经授权的
 @param result 返回结果
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithPATCH:(NSString *_Nonnull)url params:(id _Nullable)params authorized:(BOOL)authorized result:(RequestResultBlock)result;

/**
 DELETE-HTTP请求接口，无需授权
 
 @param url 访问URL
 @param params 参数
 @param result 返回结果
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithDELETE:(NSString *_Nonnull)url params:(id _Nullable)params result:(RequestResultBlock)result;

/**
 DELETE-HTTP请求接口，授权可选
 
 @param url 访问URL
 @param params 参数
 @param authorized 是否经授权的
 @param result 返回结果
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithDELETE:(NSString *_Nonnull)url params:(id _Nullable)params authorized:(BOOL)authorized result:(RequestResultBlock)result;

@end
