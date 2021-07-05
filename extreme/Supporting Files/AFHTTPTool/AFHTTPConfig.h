//
//  AFHTTPConfig.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

//MARK: 响应结果
static NSString *result_key = @"result";

//MARK: 状态码自定义
static NSString *statusCode_key = @"code"; // 服务端返回的错误码字段
static NSString *message_key = @"msg";     // 服务端返回的错误消息字段
//MARK: 常用状态码定义
static NSString *statusCode_success = @"0";            // 请求成功状态码
static NSString *statusCode_expiredToken = @"40008";   // token不正确的状态码
static NSString *statusCode_incorrectToken = @"40009"; // token已过期的状态码

/**
 请求方法，Get/POST/PUT/PATCH/DELETE
 */
typedef NS_ENUM(NSInteger, AFHTTPMethodType) {
    AFHTTPMethodTypeGet,      // Get
    AFHTTPMethodTypePost,     // Post
    AFHTTPMethodTypePut,      // Put
    AFHTTPMethodTypePatch,    // Patch
    AFHTTPMethodTypeDelete    // Delete
};

/**
 请求类型，HTTP/JSON
 */
typedef NS_ENUM(NSInteger, AFHTTPRequestType) {
    AFHTTPRequestTypeHTTP,    // HTTP
    AFHTTPRequestTypeJSON     // JSON
};
