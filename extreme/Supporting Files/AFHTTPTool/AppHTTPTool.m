//
//  AppHTTPTool.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "AppHTTPTool.h"

@implementation AppHTTPTool

#pragma mark - 公共接口
/************************************************
 * 公共请求接口写在这里
 */



/************************************************/


#pragma mark - AFHTTPTool封装
#pragma mark 常规请求
+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithGET:(NSString *_Nonnull)url params:(id _Nullable)params result:(RequestResultBlock)result {
    return [AppHTTPTool requestWithGET:url params:params requestType:AFHTTPRequestTypeHTTP authorized:NO result:result];
}

+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithGET:(NSString *_Nonnull)url params:(id _Nullable)params authorized:(BOOL)authorized result:(RequestResultBlock)result {
    return [AppHTTPTool requestWithGET:url params:params requestType:AFHTTPRequestTypeHTTP authorized:authorized result:result];
}

+ (NSURLSessionDataTask *_Nonnull)requestWithGET:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result {
    [SVProgressHUD showWithStatus:@"数据加载中"];
    return [AFHTTPTool GET:url params:params requestType:requestType authorized:authorized result:^(BOOL success, id responseObj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (success) {
                result(YES, responseObj);
            }
            else {
                AFHTTPError *http_error = responseObj;
                if (!http_error.isUserLevel && [AFHTTPTool isClientLevel:http_error]) { // 提示除常见的系统级错误
                    RUN_AFTER(SVShowStatusDelayTime, ^{
                        [SVProgressHUD showErrorWithStatus:http_error.errorDescription];
                    });
                }
                else if ([http_error.errorCode isEqualToString:expired_token] || [http_error.errorCode isEqualToString:incorrect_token]) { // token失效或不正确
                    [AppUtils presentLoginVC];
                }
                result(NO, http_error);
            }
        });
    }];
}

+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithPOST:(NSString *_Nonnull)url params:(id _Nullable)params result:(RequestResultBlock)result {
    return [AppHTTPTool requestWithPOST:url params:params requestType:AFHTTPRequestTypeHTTP authorized:NO result:result];
}

+ (NSURLSessionDataTask *_Nonnull)JSONRequestWithPOST:(NSString *_Nonnull)url params:(id _Nullable)params result:(RequestResultBlock)result {
    return [AppHTTPTool requestWithPOST:url params:params requestType:AFHTTPRequestTypeJSON authorized:NO result:result];
}

+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithPOST:(NSString *_Nonnull)url params:(id _Nullable)params authorized:(BOOL)authorized result:(RequestResultBlock)result {
    return [AppHTTPTool requestWithPOST:url params:params requestType:AFHTTPRequestTypeHTTP authorized:authorized result:result];
}

+ (NSURLSessionDataTask *_Nonnull)JSONRequestWithPOST:(NSString *_Nonnull)url params:(id _Nullable)params authorized:(BOOL)authorized result:(RequestResultBlock)result {
    return [AppHTTPTool requestWithPOST:url params:params requestType:AFHTTPRequestTypeJSON authorized:authorized result:result];
}

+ (NSURLSessionDataTask *_Nonnull)requestWithPOST:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result {
    [SVProgressHUD showWithStatus:@"数据加载中"];
    return [AFHTTPTool POST:url params:params requestType:requestType authorized:authorized result:^(BOOL success, id responseObj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (success) {
                result(YES, responseObj);
            }
            else {
                AFHTTPError *http_error = responseObj;
                if (!http_error.isUserLevel && [AFHTTPTool isClientLevel:http_error]) {
                    RUN_AFTER(SVShowStatusDelayTime, ^{
                        [SVProgressHUD showErrorWithStatus:http_error.errorDescription];
                    });
                }
                else if ([http_error.errorCode isEqualToString:expired_token] || [http_error.errorCode isEqualToString:incorrect_token]) {
                    [AppUtils presentLoginVC];
                }
                result(NO, http_error);
            }
        });
    }];
}


+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithPUT:(NSString *_Nonnull)url params:(id _Nullable)params result:(RequestResultBlock)result {
    return [AppHTTPTool requestWithPUT:url params:params requestType:AFHTTPRequestTypeHTTP authorized:NO result:result];
}

+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithPUT:(NSString *_Nonnull)url params:(id _Nullable)params authorized:(BOOL)authorized result:(RequestResultBlock)result {
    return [AppHTTPTool requestWithPUT:url params:params requestType:AFHTTPRequestTypeHTTP authorized:authorized result:result];
}

+ (NSURLSessionDataTask *_Nonnull)requestWithPUT:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result {
    [SVProgressHUD showWithStatus:@"数据加载中"];
    return [AFHTTPTool PUT:url params:params requestType:requestType authorized:authorized result:^(BOOL success, id responseObj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (success) {
                result(YES, responseObj);
            }
            else {
                AFHTTPError *http_error = responseObj;
                if (!http_error.isUserLevel && [AFHTTPTool isClientLevel:http_error]) {
                    RUN_AFTER(SVShowStatusDelayTime, ^{
                        [SVProgressHUD showErrorWithStatus:http_error.errorDescription];
                    });
                }
                else if ([http_error.errorCode isEqualToString:expired_token] || [http_error.errorCode isEqualToString:incorrect_token]) {
                    [AppUtils presentLoginVC];
                }
                result(NO, http_error);
            }
        });
    }];
}

+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithPATCH:(NSString *_Nonnull)url params:(id _Nullable)params result:(RequestResultBlock)result {
    return [AppHTTPTool requestWithPATCH:url params:params requestType:AFHTTPRequestTypeHTTP authorized:NO result:result];
}

+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithPATCH:(NSString *_Nonnull)url params:(id _Nullable)params authorized:(BOOL)authorized result:(RequestResultBlock)result {
    return [AppHTTPTool requestWithPATCH:url params:params requestType:AFHTTPRequestTypeHTTP authorized:authorized result:result];
}

+ (NSURLSessionDataTask *_Nonnull)requestWithPATCH:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result {
    [SVProgressHUD showWithStatus:@"数据加载中"];
    return [AFHTTPTool PATCH:url params:params requestType:requestType authorized:authorized result:^(BOOL success, id responseObj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (success) {
                result(YES, responseObj);
            }
            else {
                AFHTTPError *http_error = responseObj;
                if (!http_error.isUserLevel && [AFHTTPTool isClientLevel:http_error]) {
                    RUN_AFTER(SVShowStatusDelayTime, ^{
                        [SVProgressHUD showErrorWithStatus:http_error.errorDescription];
                    });
                }
                else if ([http_error.errorCode isEqualToString:expired_token] || [http_error.errorCode isEqualToString:incorrect_token]) {
                    [AppUtils presentLoginVC];
                }
                result(NO, http_error);
            }
        });
    }];
}

+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithDELETE:(NSString *_Nonnull)url params:(id _Nullable)params result:(RequestResultBlock)result {
    return [AppHTTPTool requestWithDELETE:url params:params requestType:AFHTTPRequestTypeHTTP authorized:NO result:result];
}

+ (NSURLSessionDataTask *_Nonnull)HTTPRequestWithDELETE:(NSString *_Nonnull)url params:(id _Nullable)params authorized:(BOOL)authorized result:(RequestResultBlock)result {
    return [AppHTTPTool requestWithDELETE:url params:params requestType:AFHTTPRequestTypeHTTP authorized:authorized result:result];
}

+ (NSURLSessionDataTask *_Nonnull)requestWithDELETE:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result {
    [SVProgressHUD showWithStatus:@"数据加载中"];
    return [AFHTTPTool DELETE:url params:params requestType:requestType authorized:authorized result:^(BOOL success, id responseObj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (success) {
                result(YES, responseObj);
            }
            else {
                AFHTTPError *http_error = responseObj;
                if (!http_error.isUserLevel && [AFHTTPTool isClientLevel:http_error]) {
                    RUN_AFTER(SVShowStatusDelayTime, ^{
                        [SVProgressHUD showErrorWithStatus:http_error.errorDescription];
                    });
                }
                else if ([http_error.errorCode isEqualToString:expired_token] || [http_error.errorCode isEqualToString:incorrect_token]) {
                    [AppUtils presentLoginVC];
                }
                result(NO, http_error);
            }
        });
    }];
}

@end
