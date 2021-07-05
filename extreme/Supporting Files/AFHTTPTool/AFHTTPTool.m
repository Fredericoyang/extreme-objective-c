//
//  AFHTTPTool.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "AFHTTPTool.h"

#pragma mark - 请求错误自定义类
@implementation AFHTTPError

#pragma mark 系统级错误

- (instancetype)initWithError:(NSError *_Nonnull)error url:(NSString *_Nonnull)url {
    self = [super init];
    if (self) {
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data) {
            _errorResponse = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:nil];
        }
        if (!_errorResponse) {
            _errorCode = STRING_FORMAT(@"%ld", (long)error.code);
            _errorDescription = error.localizedDescription;
            if (data) {
                _errorMessage = @"For more detail see errorResponse";
                _errorResponse = [NSString stringWithUTF8String:[data bytes]];
            }
        }
        else {
            _errorCode = _errorResponse[@"status"]?[_errorResponse[@"status"] stringValue]:@"-999";
            _errorDescription = _errorResponse[@"error"]?:@"未知错误";
            _errorMessage = _errorResponse[@"message"]?:@"无消息内容";
        }
        _url = url;
    }
    return self;
}

#pragma mark 用户级错误

- (instancetype)initWithErrorCode:(NSString *_Nonnull)errorCode errorDescription:(NSString *_Nonnull)errorDescription url:(NSString *_Nonnull)url {
    self = [super init];
    if (self) {
        _isUserLevel = YES;
        _errorCode = errorCode;
        _errorDescription = errorDescription;
        _url = url;
    }
    return self;
}

@end


@implementation AFHTTPRequestProperties

@end


#pragma mark - 请求错误自定义视图类

@implementation AFHTTPRetryView {
    UILabel *_info_label;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGE(@"extreme.bundle/net_error")];
    imageView.alpha = 0.65;
    [self addSubview:imageView];
    _info_label = [[UILabel alloc] init];
    _info_label.font = FONT_SIZE(14);
    _info_label.textColor = COLOR_HEXSTRING(@"#999999");
    _info_label.textAlignment = NSTextAlignmentCenter;
    _info_label.numberOfLines = 0;
    _info_label.text = @"未连接互联网";
    [self addSubview:_info_label];
    UIButton *retry_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [retry_button setTitle:@"点击重试" forState:UIControlStateNormal];
    [retry_button setTitleColor:COLOR_HEXSTRING(@"#448ACA") forState:UIControlStateNormal];
    retry_button.titleLabel.font = FONT_SIZE(14);
    [retry_button addTarget:self action:@selector(tapToRetry:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:retry_button];
    imageView.sd_layout
    .widthIs(90)
    .heightIs(90)
    .topSpaceToView(self, 0)
    .centerXEqualToView(self);
    _info_label.sd_layout
    .widthIs(200)
    .autoHeightRatio(0)
    .centerXEqualToView(self)
    .topSpaceToView(imageView, 0);
    retry_button.sd_layout
    .widthIs(200)
    .heightIs(30)
    .centerXEqualToView(self)
    .topSpaceToView(_info_label, 0);
}


- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (void)setRetry_info:(NSString *_Nonnull)retry_info {
    _retry_info = retry_info;
    _info_label.text = retry_info;
}


- (void)tapToRetry:(UIButton *)button {
    if (_retryBlock) {
        _retryBlock(button);
    }
}

@end


@implementation AFHTTPTool

#pragma mark - 显示自定义错误提示

+ (void)showHTTPRetryView:(AFHTTPRequestProperties *_Nonnull)requestProperties {
    // 只显示一次
    BOOL isHTTPRetryViewShow = NO;
    for (UIView *subview in APP_DELEGATE.window.subviews) {
        if (10001 == subview.tag) {
            isHTTPRetryViewShow = YES;
            break;
        }
    }
    if (isHTTPRetryViewShow) {
        return;
    }
    
    AFHTTPRetryView *retryView = [[AFHTTPRetryView alloc] init];
    retryView.backgroundColor = COLOR_HEXSTRING(@"#FFFFFF");
    retryView.borderWidth = 0.5;
    retryView.borderColor = COLOR_HEXSTRING(@"#E6E6E6");
    retryView.cornerRadius = 3;
    retryView.requestProperties = requestProperties;
    retryView.retry_info = requestProperties.info_string;
    retryView.retryBlock = ^(id sender) {
        for (UIView *subview in APP_DELEGATE.window.subviews) {
            if (10001 == subview.tag) {
                AFHTTPRequestProperties *requestProperties = ((AFHTTPRetryView *)subview.subviews[0]).requestProperties;
                [subview removeFromSuperview];
                switch (requestProperties.methodType) {
                    case (AFHTTPMethodTypeGet):
                    {
                        [AFHTTPTool GET:requestProperties.url params:requestProperties.params requestType:requestProperties.requestType authorized:requestProperties.authorized result:requestProperties.result];
                    }
                        break;
                    case (AFHTTPMethodTypePost):
                    {
                        [AFHTTPTool POST:requestProperties.url params:requestProperties.params requestType:requestProperties.requestType authorized:requestProperties.authorized result:requestProperties.result];
                    }
                        break;
                    case (AFHTTPMethodTypePut):
                    {
                        [AFHTTPTool PUT:requestProperties.url params:requestProperties.params requestType:requestProperties.requestType authorized:requestProperties.authorized result:requestProperties.result];
                    }
                        break;
                    case (AFHTTPMethodTypePatch):
                    {
                        [AFHTTPTool PATCH:requestProperties.url params:requestProperties.params requestType:requestProperties.requestType authorized:requestProperties.authorized result:requestProperties.result];
                    }
                        break;
                    case (AFHTTPMethodTypeDelete):
                    {
                        [AFHTTPTool DELETE:requestProperties.url params:requestProperties.params requestType:requestProperties.requestType authorized:requestProperties.authorized result:requestProperties.result];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    };
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.tag = 10001;
    backgroundView.backgroundColor = COLOR_HEXSTRING_ALPHA(@"#000000", 0.3);
    [backgroundView addSubview:retryView];
    [APP_DELEGATE.window addSubview:backgroundView];
    
    retryView.sd_layout
    .widthIs(230)
    .heightIs(150)
    .centerXEqualToView(backgroundView)
    .centerYEqualToView(backgroundView);
    
    backgroundView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}


#pragma mark - 获取manager实例

+ (AFHTTPSessionManager *_Nonnull)managerForRequestType:(AFHTTPRequestType)requestType {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (AFHTTPRequestTypeHTTP == requestType) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else if (AFHTTPRequestTypeJSON == requestType) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    manager.requestSerializer.timeoutInterval = AFHTTPToolRequestTimeout;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}


#pragma mark - 常规请求
/**
 是否客户端级别错误
 */
+ (BOOL)isClientLevel:(AFHTTPError *_Nonnull)http_error {
    if ([http_error.errorDescription isEqualToString:@"已取消"]) {
        return YES;
    }
    return !([http_error.errorCode isEqualToString:@"-1009"] || [http_error.errorCode isEqualToString:@"-1001"] || [http_error.errorCode isEqualToString:@"-1004"] || [http_error.errorCode isEqualToString:@"-1002"] || [http_error.errorCode isEqualToString:@"404"] || [http_error.errorCode isEqualToString:@"500"]);
}

/**
 打印请求日志
 */
NSString *AFHTTPMethodTypeString(AFHTTPMethodType methodType) {
    NSString *methodType_string;
    switch (methodType) {
        case AFHTTPMethodTypeGet:
            methodType_string = @"Get";
            break;
        case AFHTTPMethodTypePost:
            methodType_string = @"Post";
            break;
        case AFHTTPMethodTypePut:
            methodType_string = @"Put";
            break;
        case AFHTTPMethodTypePatch:
            methodType_string = @"Patch";
            break;
        case AFHTTPMethodTypeDelete:
            methodType_string = @"Delete";
            break;
        default:
            methodType_string = nil;
            break;
    }
    return methodType_string;
}

/**
 打印请求日志
 */
+ (void)printRequestLog:(AFHTTPRequestProperties *_Nonnull)requestProperties {
#if PrintRequestLog
    LOG_FORMAT(@"##################");
    LOG_FORMAT(@"----发送%@请求----", AFHTTPMethodTypeString(requestProperties.methodType));
    LOG_FORMAT(@"%@", requestProperties.url);
    LOG_FORMAT(@"----请求类型---");
    LOG_FORMAT(@"%@", requestProperties.requestType==AFHTTPRequestTypeHTTP?@"HTTP":@"JSON");
    LOG_FORMAT(@"---以下为参数---");
    LOG_FORMAT(@"%@", requestProperties.params);
    LOG_FORMAT(@"---以上为参数---");
    LOG_FORMAT(@"##################");
#endif
}

/**
 打印响应日志
 */
+ (void)printResponseLog:(AFHTTPRequestProperties *_Nonnull)requestProperties response:(id _Nullable)responseObject {
#if PrintResponseLog
    LOG_FORMAT(@"==================");
    LOG_FORMAT(@"----%@请求响应----", AFHTTPMethodTypeString(requestProperties.methodType));
    LOG_FORMAT(@"%@", requestProperties.url);
    LOG_FORMAT(@"----请求类型---");
    LOG_FORMAT(@"%@", requestProperties.requestType==AFHTTPRequestTypeHTTP?@"HTTP":@"JSON");
    LOG_FORMAT(@"---以下为参数---");
    LOG_FORMAT(@"%@", requestProperties.params);
    LOG_FORMAT(@"以下为数据");
    LOG_FORMAT(@"%@", responseObject);
    LOG_FORMAT(@"以上为数据");
    LOG_FORMAT(@"==================");
#endif
}

+ (NSURLSessionDataTask *_Nonnull)GET:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result {
    AFHTTPRequestProperties *requestProperties = [[AFHTTPRequestProperties alloc] init];
    requestProperties.methodType = AFHTTPMethodTypeGet;
    requestProperties.url = url;
    requestProperties.params = params;
    requestProperties.requestType = requestType;
    requestProperties.authorized = authorized;
    requestProperties.result = result;
    [AFHTTPTool printRequestLog:requestProperties];
    
    AFHTTPSessionManager *manager = [AFHTTPTool managerForRequestType:requestType];
    NSMutableDictionary *headers;
    if (authorized) {
        headers = [[NSMutableDictionary alloc] init];
        NSString *token = [USER_DEFAULTS objectForKey:@"Token"];
        if (token) {
#if PrintResponseLog
            LOG_FORMAT(@"----Header Token:%@----", STRING_FORMAT(@"Bearer %@", token));
#endif
            [headers setValue:STRING_FORMAT(@"Bearer %@", token) forKey:@"Authorization"];
        }
#if PrintResponseLog
        else { // 开发时添加默认值，避免接口报错
            [headers setValue:@"Bearer " forKey:@"Authorization"];
        }
#endif
    }
    return [manager GET:url parameters:params headers:headers progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [AFHTTPTool printResponseLog:requestProperties response:responseObject];
        
        if ([EFUtils objectValueIsEqualTo:statusCode_success dictionary:responseObject withKey:statusCode_key]) {
            result(YES, responseObject);
        }
        else {
            AFHTTPError *http_error = [[AFHTTPError alloc] initWithErrorCode:[EFUtils stringFromDictionary:responseObject withKey:statusCode_key]?:@"-999" errorDescription:[EFUtils stringFromDictionary:responseObject withKey:message_key]?:@"服务器未指明的错误" url:url];
            result(NO, http_error);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        AFHTTPError *http_error = [[AFHTTPError alloc] initWithError:error url:url];
        if (![AFHTTPTool isClientLevel:http_error]) { // 常见系统级别错误，显示带重试按钮的错误提示
            requestProperties.info_string = http_error.errorDescription;
            [AFHTTPTool showHTTPRetryView:requestProperties];
        }
        result(NO, http_error);
    }];
}


+ (NSURLSessionDataTask *_Nonnull)POST:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result {
    AFHTTPRequestProperties *requestProperties = [[AFHTTPRequestProperties alloc] init];
    requestProperties.methodType = AFHTTPMethodTypePost;
    requestProperties.url = url;
    requestProperties.params = params;
    requestProperties.requestType = requestType;
    requestProperties.authorized = authorized;
    requestProperties.result = result;
    [AFHTTPTool printRequestLog:requestProperties];
    
    AFHTTPSessionManager *manager = [AFHTTPTool managerForRequestType:requestType];
    NSMutableDictionary *headers;
    if (authorized) {
        headers = [[NSMutableDictionary alloc] init];
        NSString *token = [USER_DEFAULTS objectForKey:@"Token"];
        if (token) {
#if PrintResponseLog
        LOG_FORMAT(@"----Header Token:%@----", STRING_FORMAT(@"Bearer %@", token));
#endif
            [headers setValue:STRING_FORMAT(@"Bearer %@", token) forKey:@"Authorization"];
        }
#if PrintResponseLog
        else { // 开发时添加默认值，避免接口报错
            [headers setValue:@"Bearer " forKey:@"Authorization"];
        }
#endif
    }
    return [manager POST:url parameters:params headers:headers progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [AFHTTPTool printResponseLog:requestProperties response:responseObject];
        
        if ([EFUtils objectValueIsEqualTo:statusCode_success dictionary:responseObject withKey:statusCode_key]) {
            result(YES, responseObject);
        }
        else {
            AFHTTPError *http_error = [[AFHTTPError alloc] initWithErrorCode:[EFUtils stringFromDictionary:responseObject withKey:statusCode_key]?:@"-999" errorDescription:[EFUtils stringFromDictionary:responseObject withKey:message_key]?:@"服务器未指明的错误" url:url];
            result(NO, http_error);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        AFHTTPError *http_error = [[AFHTTPError alloc] initWithError:error url:url];
        if (![AFHTTPTool isClientLevel:http_error]) {
            requestProperties.info_string = http_error.errorDescription;
            [AFHTTPTool showHTTPRetryView:requestProperties];
        }
        result(NO, http_error);
    }];
}


#pragma mark - Rest请求
+ (NSURLSessionDataTask *_Nonnull)PUT:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result {
    AFHTTPRequestProperties *requestProperties = [[AFHTTPRequestProperties alloc] init];
    requestProperties.methodType = AFHTTPMethodTypePut;
    requestProperties.url = url;
    requestProperties.params = params;
    requestProperties.requestType = requestType;
    requestProperties.authorized = authorized;
    requestProperties.result = result;
    [AFHTTPTool printRequestLog:requestProperties];
    
    AFHTTPSessionManager *manager = [AFHTTPTool managerForRequestType:requestType];
    NSMutableDictionary *headers;
    if (authorized) {
        headers = [[NSMutableDictionary alloc] init];
        NSString *token = [USER_DEFAULTS objectForKey:@"Token"];
        if (token) {
#if PrintResponseLog
        LOG_FORMAT(@"----Header Token:%@----", STRING_FORMAT(@"Bearer %@", token));
#endif
            [headers setValue:STRING_FORMAT(@"Bearer %@", token) forKey:@"Authorization"];
        }
#if PrintResponseLog
        else { // 开发时添加默认值，避免接口报错
            [headers setValue:@"Bearer " forKey:@"Authorization"];
        }
#endif
    }
    return [manager PUT:url parameters:params headers:headers success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [AFHTTPTool printResponseLog:requestProperties response:responseObject];
        
        if ([EFUtils objectValueIsEqualTo:statusCode_success dictionary:responseObject withKey:statusCode_key]) {
            result(YES, responseObject);
        }
        else {
            AFHTTPError *http_error = [[AFHTTPError alloc] initWithErrorCode:[EFUtils stringFromDictionary:responseObject withKey:statusCode_key]?:@"-999" errorDescription:[EFUtils stringFromDictionary:responseObject withKey:message_key]?:@"服务器未指明的错误" url:url];
            result(NO, http_error);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        AFHTTPError *http_error = [[AFHTTPError alloc] initWithError:error url:url];
        if (![AFHTTPTool isClientLevel:http_error]) {
            requestProperties.info_string = http_error.errorDescription;
            [AFHTTPTool showHTTPRetryView:requestProperties];
        }
        result(NO, http_error);
    }];
}


+ (NSURLSessionDataTask *_Nonnull)PATCH:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result {
    AFHTTPRequestProperties *requestProperties = [[AFHTTPRequestProperties alloc] init];
    requestProperties.methodType = AFHTTPMethodTypePatch;
    requestProperties.url = url;
    requestProperties.params = params;
    requestProperties.requestType = requestType;
    requestProperties.authorized = authorized;
    requestProperties.result = result;
    [AFHTTPTool printRequestLog:requestProperties];
    
    AFHTTPSessionManager *manager = [AFHTTPTool managerForRequestType:requestType];
    NSMutableDictionary *headers;
    if (authorized) {
        headers = [[NSMutableDictionary alloc] init];
        NSString *token = [USER_DEFAULTS objectForKey:@"Token"];
        if (token) {
#if PrintResponseLog
        LOG_FORMAT(@"----Header Token:%@----", STRING_FORMAT(@"Bearer %@", token));
#endif
            [headers setValue:STRING_FORMAT(@"Bearer %@", token) forKey:@"Authorization"];
        }
#if PrintResponseLog
        else { // 开发时添加默认值，避免接口报错
            [headers setValue:@"Bearer " forKey:@"Authorization"];
        }
#endif
    }
    return [manager PATCH:url parameters:params headers:headers success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [AFHTTPTool printResponseLog:requestProperties response:responseObject];
        
        if ([EFUtils objectValueIsEqualTo:statusCode_success dictionary:responseObject withKey:statusCode_key]) {
            result(YES, responseObject);
        }
        else {
            AFHTTPError *http_error = [[AFHTTPError alloc] initWithErrorCode:[EFUtils stringFromDictionary:responseObject withKey:statusCode_key]?:@"-999" errorDescription:[EFUtils stringFromDictionary:responseObject withKey:message_key]?:@"服务器未指明的错误" url:url];
            result(NO, http_error);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        AFHTTPError *http_error = [[AFHTTPError alloc] initWithError:error url:url];
        if (![AFHTTPTool isClientLevel:http_error]) {
            requestProperties.info_string = http_error.errorDescription;
            [AFHTTPTool showHTTPRetryView:requestProperties];
        }
        result(NO, http_error);
    }];
}


+ (NSURLSessionDataTask *_Nonnull)DELETE:(NSString *_Nonnull)url params:(id _Nullable)params requestType:(AFHTTPRequestType)requestType authorized:(BOOL)authorized result:(RequestResultBlock)result {
    AFHTTPRequestProperties *requestProperties = [[AFHTTPRequestProperties alloc] init];
    requestProperties.methodType = AFHTTPMethodTypeDelete;
    requestProperties.url = url;
    requestProperties.params = params;
    requestProperties.requestType = requestType;
    requestProperties.authorized = authorized;
    requestProperties.result = result;
    [AFHTTPTool printRequestLog:requestProperties];
    
    AFHTTPSessionManager *manager = [AFHTTPTool managerForRequestType:requestType];
    NSMutableDictionary *headers;
    if (authorized) {
        headers = [[NSMutableDictionary alloc] init];
        NSString *token = [USER_DEFAULTS objectForKey:@"Token"];
        if (token) {
#if PrintResponseLog
        LOG_FORMAT(@"----Header Token:%@----", STRING_FORMAT(@"Bearer %@", token));
#endif
            [headers setValue:STRING_FORMAT(@"Bearer %@", token) forKey:@"Authorization"];
        }
#if PrintResponseLog
        else { // 开发时添加默认值，避免接口报错
            [headers setValue:@"Bearer " forKey:@"Authorization"];
        }
#endif
    }
    return [manager DELETE:url parameters:params headers:headers success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [AFHTTPTool printResponseLog:requestProperties response:responseObject];
        
        if ([EFUtils objectValueIsEqualTo:statusCode_success dictionary:responseObject withKey:statusCode_key]) {
            result(YES, responseObject);
        }
        else {
            AFHTTPError *http_error = [[AFHTTPError alloc] initWithErrorCode:[EFUtils stringFromDictionary:responseObject withKey:statusCode_key]?:@"-999" errorDescription:[EFUtils stringFromDictionary:responseObject withKey:message_key]?:@"服务器未指明的错误" url:url];
            result(NO, http_error);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        AFHTTPError *http_error = [[AFHTTPError alloc] initWithError:error url:url];
        if (![AFHTTPTool isClientLevel:http_error]) {
            requestProperties.info_string = http_error.errorDescription;
            [AFHTTPTool showHTTPRetryView:requestProperties];
        }
        result(NO, http_error);
    }];
}

@end
