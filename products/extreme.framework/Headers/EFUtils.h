//
//  EFUtils.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFUtils : NSObject

/**
 获取 storyboard中控制器的实例
 
 @param storyboardName storyboard文件名，不含后缀
 @param storyboardID 控制器的 storyboard ID
 @return 控制器实例
 */
+ (id _Nonnull)sharedStoryboardInstanceWithStoryName:(NSString *_Nonnull)storyboardName storyboardID:(NSString *_Nonnull)storyboardID;


/**
 检查字符串值是否合法

 @param stringValue 字符串值
 @param regExp 用于检查的正则表达式
 @return 检查结果，YES 合法 NO 不合法
 */
+ (BOOL)checkValue:(NSString *_Nonnull)stringValue byRegExp:(NSString *_Nonnull)regExp;


/**
 对象判空

 @param object 对象
 @return 检查结果，YES 不存在或为空 NO 不为空
 */
+ (BOOL)objectIsNullOrEmpty:(id _Nonnull)object;

/**
 字符串判空
 
 @param string 字符串值
 @return 检查结果，YES 不存在或为空 NO 不为空
 */
+ (BOOL)stringIsNullOrEmpty:(NSString *_Nonnull)string;

/**
 指定键值转换为字符串

 @param dictionary 字典对象
 @param key 键
 @return 转换的字符串，如果指定键值不是 NSString或者 NSNumber，则返回 nil
 */
+ (NSString *_Nullable)stringFromDictionary:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key;

/**
 判断字典指定键值是否为空
 
 @param dictionary 字典对象
 @param key 键
 @return 检查结果，YES 不存在或为空 NO 不为空
 */
+ (BOOL)objectIsNull:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key;

/**
 判断字典所有键值是否存在空
 
 @param dictionary 字典对象
 @return 检查结果，YES 至少一个键值存在空 NO 均不为空
 */
+ (BOOL)validDictionary:(NSDictionary *_Nonnull)dictionary;

/**
 判断字典指定键值是否等于指定数值

 @param value 数值
 @param dictionary 字典
 @param key 键
 @return 检查结果，YES 等于 NO 不等于
 */
+ (BOOL)objectValueIsEqualTo:(NSInteger)value dictionary:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key;

/**
 将NSNumber转换为BOOL
 
 @param number NSNumber实例
 @return 转换number中对应的boolValue，如果为nil则返回NO
 */
+ (BOOL)boolValueFromNumber:(NSNumber *_Nonnull)number;


/**
 日期对象转日期字符串，例如：2017-07-12 16:00

 @param date NSDate 对象
 @return 返回转格式之后的字符串
 */
+ (NSString *_Nullable)stringFromDate:(NSDate *_Nonnull)date;

/**
 日期对象转日期字符串或日期时间字符串，例如：2017-07-12 或 2017-07-12 16:00

 @param date NSDate 对象
 @param dateTime 转格式之后返回的是日期字符串还是日期时间字符串，会自动指定一个模版
 @return 返回转格式之后的字符串
 */
+ (NSString *_Nullable)stringFromDate:(NSDate *_Nonnull)date dateTime:(BOOL)dateTime;

/**
 日期对象转日期字符串，可自定义显示
 
 @param date NSDate 对象
 @param dateFormat 转换格式模版模版
 @return 返回转格式之后的字符串
 */
+ (NSString *_Nullable)stringFromDate:(NSDate *_Nonnull)date dateFormat:(NSString *_Nonnull)dateFormat;

/**
 日期字符串转格式
 
 @param dateString 转格式之前的日期字符串 yyyy-MM-dd
 @param dateFormat 转换格式模版模版
 @return 返回转格式之后的字符串
 */
+ (NSString *_Nullable)stringFromDateString:(NSString *_Nonnull)dateString dateFormat:(NSString *_Nonnull)dateFormat;

/**
 日期字符或日期时间字符串转格式
 
 @param dateString 转格式之前的日期字符串  yyyy-MM-dd或日期时间字符串 yyyy-MM-dd HH:mm:ss，由 dateTime 决定
 @param dateTime 传入转格式之前的是日期字符串还是日期时间字符串
 @param dateFormat 转换格式模版模版
 @return 返回转格式之后的字符串
 */
+ (NSString *_Nullable)stringFromDateTimeString:(NSString *_Nonnull)dateString dateTime:(BOOL)dateTime dateFormat:(NSString *_Nonnull)dateFormat;


//MARK: DES加解密
/******字符串转base64（包括DES加密）******/
#define __BASE64( text )        [EFUtils base64StringFromText:text]

/******base64（通过DES解密）转字符串******/
#define __TEXT( base64 )        [EFUtils textFromBase64String:base64]

/************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 **********************************************************/
+ (NSString *_Nullable)base64StringFromText:(NSString *_Nonnull)text;

/************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 **********************************************************/
+ (NSString *_Nullable)textFromBase64String:(NSString *_Nonnull)base64;

@end
