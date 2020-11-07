//
//  AFHTTPConfig.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

//MARK: 响应结果
static NSString *result_key = @"result";

//MARK: 错误码自定义
static NSString *errorCode_key = @"code"; // 服务端返回的错误码字段
static NSString *errorMsg_key = @"msg";   // 服务端返回的错误消息字段
static NSString *expired_token = @"40008";     // token不正确的错误码
static NSString *incorrect_token = @"40009";   // token已过期的错误码

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
