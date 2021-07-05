//
//  AbilityAccountManager.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2019/9/5.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

@interface AbilityAccountManager : NSObject

/**
 登录
 
 @param username 用户名
 @param password 密码
 @param result 返回结果
 @return dataTask实例
 */
+ (NSURLSessionDataTask *)loginWithUserName:(NSString *)username password:(NSString *)password result:(RequestResultBlock)result;

/**
 获取昵称

 @param result 返回结果
 @return dataTask实例
 */
+ (NSURLSessionDataTask *)myNickNameResult:(RequestResultBlock)result;

@end
