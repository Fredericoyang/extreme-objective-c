//
//  EFUtils.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFConfig.h"
#import "EFMacros.h"

@interface EFUtils : NSObject

//MARK: - 验证值是否合法 Validate the value
/**
 对象判空。(Validate the object is nil or null.)

 @param object 对象实例
 @return 检查结果，YES 不存在或为空 NO 不为空
 */
+ (BOOL)objectIsNilOrNull:(id _Nonnull)object;

/**
 字符串判空。(Validate the string is nil or null or empty.)
 
 @param string NSString实例
 @return 检查结果，YES 不存在或为空 NO 不为空
 */
+ (BOOL)stringIsNilOrNullOrEmpty:(NSString *_Nonnull)string;

/**
 使用正则表达式验证字符串值。(Validate the string by a regular expression.)

 @param string NSString实例
 @param regExp 用于验证的正则表达式
 @return 检查结果，YES 合法 NO 不合法
 */
+ (BOOL)validateString:(NSString *_Nonnull)string byRegExp:(NSString *_Nonnull)regExp;

/**
 字典中指定键值判空。(Validate the key value in a dictionary is nil or null.)
 
 @param dictionary NSDictionary实例
 @param key 键
 @return 检查结果，YES 不存在或为空 NO 不为空
 */
+ (BOOL)objectValueIsNilOrNull:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key;

/**
 字典中指定键值是否等于指定数值。(Validate the key value in a dictionary is equal to another integer value in a NSNumber or NSString object or not.)

 @param value NSNumber或者 NSString实例，其中包含一个整数值
 @param dictionary NSDictionary实例
 @param key 键
 @return 检查结果，YES 等于 NO 不等于
 */
+ (BOOL)objectValueIsEqualTo:(id _Nonnull)value dictionary:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key;

/**
 字典中所有的值都不为空，注意之前 +validDictionary: 返回的值已发生反转。(Validate all values in a dictionary is all not empty, note that the returned value from +validDictionary: has been reversed.)
 
 @param dictionary NSDictionary实例
 @return 检查结果，YES 均不为空 NO 不是字典或者字典中至少一个键值不存在或为空
 */
+ (BOOL)validateDictionary:(NSDictionary *_Nonnull)dictionary;


//MARK: - 转换 Conversions
/**
 字典中指定键值转换为字符串。(String value from the key value in a dictionary.)

 @param dictionary NSDictionary实例
 @param key 键
 @return 转换的字符串，如果指定键值不是 NSString或者 NSNumber，则返回 nil，可以为空
 */
+ (NSString *_Nullable)stringFromDictionary:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key;

/**
 将NSNumber转换为BOOL。(Bool value from a NSNumber object.)
 
 @param number NSNumber实例
 @return 转换number中对应的boolValue，若number不存在或为空则直接返回NO
 */
+ (BOOL)boolValueFromNumber:(NSNumber *_Nullable)number;

/**
 JSON(字典或数组)转 JSON字符串。(JSON to string.)
 
 @param json JSON，一般是以 NSDictionary或 NSArray为根
 @return 转换后的 JSON字符串
 */
+ (NSString *_Nullable)JSONToString:(id _Nonnull)json;

/**
 JSON字符串转 JSON(字典或数组)。(String to JSON.)

 @param jsonString JSON字符串
 @return 转换后的 JSON，一般是以 NSDictionary或 NSArray为根
 */
+ (id _Nullable)stringToJSON:(NSString *_Nonnull)jsonString;


//MARK: - 日期格式字符串格式化 Date fomartter
/**
 日期对象转日期时间字符串，例如：2017-07-12 16:00。(NSDate to date string with date and time format.)

 @param date NSDate实例
 @return 转格式之后的字符串
 */
+ (NSString *_Nullable)stringFromDate:(NSDate *_Nonnull)date;

/**
 日期对象转日期字符串(例如：2017-07-12)或日期时间字符串(例如：2017-07-12 16:00)。(NSDate to date string with date format or date and time format.)

 @param date NSDate实例
 @param dateTime 转格式会自动指定哪个日期格式显示模版，YES 日期时间字符串 NO 日期字符串
 @return 转格式之后的字符串
 */
+ (NSString *_Nullable)stringFromDate:(NSDate *_Nonnull)date dateTime:(BOOL)dateTime;

/**
 日期对象转日期格式字符串，可自定义日期格式显示模版。(NSDate to date string with your date fomartter.)
 
 @param date NSDate实例
 @param dateFormat 转格式指定的自定义日期格式显示模版
 @return 转格式之后的字符串
 */
+ (NSString *_Nullable)stringFromDate:(NSDate *_Nonnull)date dateFormat:(NSString *_Nonnull)dateFormat;

/**
 日期字符串(例如：2017-07-12)转格式。(Date string with date format to date string with your date fomartter.)
 
 @param dateFormattedString 转格式之前传入的日期字符串，例如：2017-07-12
 @param dateFormat 转格式指定的自定义日期格式显示模版
 @return 转格式之后的字符串
 */
+ (NSString *_Nullable)stringFromDateFormattedString:(NSString *_Nonnull)dateFormattedString dateFormat:(NSString *_Nonnull)dateFormat;

/**
 日期字符串(例如：2017-07-12)或日期时间字符串(例如：2017-07-12 16:00)转格式。(Date string with date format or date and time format to date string with your date fomartter.)
 
 @param dateFormattedString 转格式之前传入的日期字符串(例如：2017-07-12)或日期时间字符串(例如：2017-07-12 16:00)，由 dateTime决定
 @param dateTime 转格式之前传入的是日期字符串还是日期时间字符串，YES 日期时间字符串 NO 日期字符串
 @param dateFormat 转格式指定的自定义日期格式显示模版
 @return 转格式之后的字符串
 */
+ (NSString *_Nullable)stringFromDateFormattedString:(NSString *_Nonnull)dateFormattedString dateTime:(BOOL)dateTime dateFormat:(NSString *_Nonnull)dateFormat;

/**
 日期格式字符串转格式。(Date string with date fomartter 1 to data string with date fomartter 2.)
 
 @param dateFormattedString 转格式之前传入的日期格式字符串
 @param dateFormatIn 转格式之前传入的自定义日期格式显示模版
 @param dateFormatOut 转格式指定的自定义日期格式显示模版
 @return 转格式之后的字符串
 */
+ (NSString *_Nullable)stringFromDateFormattedString:(NSString *_Nonnull)dateFormattedString dateFormatIn:(NSString *_Nonnull)dateFormatIn dateFormatOut:(NSString *_Nonnull)dateFormatOut;

/**
 日期字符串(例如：2017-07-12)转日期对象。(Date string with date fomart to NSDate.)
 
 @param dateFormattedString 转日期对象之前传入的日期字符串(例如：2017-07-12)
 @return 转换后的日期对象
 */
+ (NSDate *_Nullable)dateFromDateFormattedString:(NSString *_Nonnull)dateFormattedString;

/**
 日期字符串(例如：2017-07-12)或日期时间字符串(例如：2017-07-12 16:00)转日期对象。(Date string with date format or date and time format to NSDate.)
 
 @param dateFormattedString 转日期对象之前传入的日期字符串(例如：2017-07-12)或日期时间字符串(例如：2017-07-12 16:00)，由 dateTime决定
 @param dateTime 转日期对象之前传入的是日期字符串还是日期时间字符串，YES 日期时间字符串 NO 日期字符串
 @return 转换后的日期对象
 */
+ (NSDate *_Nullable)dateFromDateFormattedString:(NSString *_Nonnull)dateFormattedString dateTime:(BOOL)dateTime;

/**
 日期格式字符串转日期对象。(Date string with date fomartter to NSDate.)
 
 @param dateFormattedString 转日期对象之前传入的日期格式字符串
 @param dateFormatIn 转日期对象之前传入的日期字符串显示模版
 @return 转换后的日期对象
 */
+ (NSDate *_Nullable)dateFromDateFormattedString:(NSString *_Nonnull)dateFormattedString dateFormatIn:(NSString *_Nonnull)dateFormatIn;


//MARK: - 编码为 base64字符串和解码为 NSData base64 encoding and decoding
/**
 编码为 base64字符串。(NSData base64 encoding.)
 
 @param data NSData实例
 @return Base64EncodedString
 */
+ (NSString *_Nullable)dataBase64EncodingWith:(NSData *_Nonnull)data;

/**
 解码为 NSData。(NSData base64 decoding.)
 
 @param base64EncodedString Base64EncodedString
 @return NSData实例
 */
+ (NSData *_Nullable)dataBase64DecodingFrom:(NSString *_Nonnull)base64EncodedString;


//MARK: - UIKit
//MARK: UIColor
#define COLOR_HEXSTRING(hexString)                      [EFUtils colorWithHexString:hexString]
#define COLOR_HEXSTRING_ALPHA(hexString, alphaValue)    [EFUtils colorWithHexString:hexString alpha:alphaValue]
#define HEXSTRING_COLOR(color)                          [EFUtils hexStringWithColor:color]

/**
 十六进制颜色码(例如：不带不透明度 #FFFFFF或带不透明度 #1EFFFFFF)转 UIColor。(Color with hex string of color.)
 
 @param hexString 十六进制颜色码，例如：不带不透明度 #FFFFFF或带不透明度 #1EFFFFFF
 @return UIColor实例
 */
+ (UIColor *_Nullable)colorWithHexString:(NSString *_Nonnull)hexString;

/**
 十六进制颜色码(不带不透明度，例如：#FFFFFF)外挂不透明度转 UIColor。(Color with hex string of color and alpha value.)
 
 @param hexString 十六进制颜色码(不带不透明度)，例如：#FFFFFF
 @param alpha 外挂不透明度，0～1
 @return UIColor实例
 */
+ (UIColor *_Nullable)colorWithHexString:(NSString *_Nonnull)hexString alpha:(CGFloat)alpha;

/**
 UIColor转十六进制颜色码，例如：不带不透明度 #FFFFFF或带不透明度 #1EFFFFFF。(Full hex string with color.)
 
 @param color UIColor实例
 @return 十六进制颜色码，例如：不带不透明度 #FFFFFF或带不透明度 #1EFFFFFF
 */
+ (NSString *_Nullable)hexStringWithColor:(UIColor *_Nonnull)color;


//MARK: -
/**
 获取 storyboard中的控制器实例。(Get the instance of the controller which your given a name in a storyboard.)
 
 @param storyboardName storyboard文件名，不含后缀
 @param storyboardID 控制器的 storyboard ID
 @return 控制器实例
 */
+ (id _Nonnull)sharedControllerInstanceWithStoryName:(NSString *_Nonnull)storyboardName andStoryboardID:(NSString *_Nonnull)storyboardID;

/**
 移除所有子视图。(Remove all subviews of parent view.)

 @param parentView 父类
 */
+ (void)removeAllSubviewsOf:(UIView *_Nonnull)parentView;

/**
 生成二维码。(Generate a QRCode image, then return it.)
 
 @param code 字符串
 @param width 宽
 @param height 高
 @return QRCode image
 */
+ (UIImage *_Nullable)generateQRCode:(NSString *_Nonnull)code width:(CGFloat)width height:(CGFloat)height;


//MARK: - Deprecated
/**
 方法已在极致框架2.0弃用，使用 +sharedControllerInstanceWithStoryName:andStoryboardID: 来代替。(Use +sharedControllerInstanceWithStoryName:andStoryboardID: instead, first deprecated in ExtremeFramework 2.0.)
 */
+ (id _Nonnull)sharedStoryboardInstanceWithStoryName:(NSString *_Nonnull)storyboardName storyboardID:(NSString *_Nonnull)storyboardID EFDeprecated("Use +sharedControllerInstanceWithStoryName:andStoryboardID: instead, first deprecated in ExtremeFramework 2.0.");

/**
 方法已在极致框架2.0弃用，使用 +objectIsNilOrNull: 来代替。(Use +objectIsNilOrNull: instead, first deprecated in ExtremeFramework 2.0.)
 */
+ (BOOL)objectIsNullOrEmpty:(id _Nonnull)object EFDeprecated("Use +objectIsNilOrNull: instead, first deprecated in ExtremeFramework 2.0.");

/**
 方法已在极致框架2.0弃用，使用 +stringIsNilOrNullOrEmpty: 来代替。(Use +stringIsNilOrNullOrEmpty: instead, first deprecated in ExtremeFramework 2.0.)
 */
+ (BOOL)stringIsNullOrEmpty:(NSString *_Nonnull)string EFDeprecated("Use +stringIsNilOrNullOrEmpty: instead, first deprecated in ExtremeFramework 2.0.");

/**
 方法已在极致框架2.0弃用，使用 +validateString:byRegExp: 来代替。(Use +validateString:byRegExp: instead, first deprecated in ExtremeFramework 2.0.)
 */
+ (BOOL)checkValue:(NSString *_Nonnull)stringValue byRegExp:(NSString *_Nonnull)regExp EFDeprecated("Use +validateString:byRegExp: instead, first deprecated in ExtremeFramework 2.0.");

/**
 方法已在极致框架2.0弃用，使用 +objectValueIsNilOrNull:withKey: 来代替。(Use +objectValueIsNilOrNull:withKey: instead, first deprecated in ExtremeFramework 2.0.)
 */
+ (BOOL)objectIsNull:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key EFDeprecated("Use +objectValueIsNilOrNull:withKey: instead, first deprecated in ExtremeFramework 2.0.");

/**
 方法已在极致框架2.0弃用，使用 +validateDictionary: 来代替。(Use +validateDictionary: instead, first deprecated in ExtremeFramework 2.0.)
 */
+ (BOOL)validDictionary:(NSDictionary *_Nonnull)dictionary EFDeprecated("Use +validateDictionary: instead, first deprecated in ExtremeFramework 2.0.");

/**
 方法已在极致框架2.0弃用，使用 +stringFromDateFormattedString:dateFormat: 来代替。(Use +stringFromDateFormattedString:dateFormat: instead, first deprecated in ExtremeFramework 2.0.)
 */
+ (NSString *_Nullable)stringFromDateString:(NSString *_Nonnull)dateString dateFormat:(NSString *_Nonnull)dateFormat EFDeprecated("Use +stringFromDateFormattedString:dateFormat: instead, first deprecated in ExtremeFramework 2.0.");

/**
 方法已在极致框架2.0弃用，使用 +stringFromDateFormattedString:dateTime:dateFormat: 来代替。(Use +stringFromDateFormattedString:dateTime:dateFormat: instead, first deprecated in ExtremeFramework 2.0.)
 */
+ (NSString *_Nullable)stringFromDateTimeString:(NSString *_Nonnull)dateTimeString dateTime:(BOOL)dateTime dateFormat:(NSString *_Nonnull)dateFormat EFDeprecated("Use +stringFromDateFormattedString:dateTime:dateFormat: instead, first deprecated in ExtremeFramework 2.0.");

/**
 方法已在极致框架2.0弃用，使用 COLOR_HEXSTRING(hexString) 来代替。(Use COLOR_HEXSTRING(hexString) instead, first deprecated in ExtremeFramework 2.0.)
 */
+ (UIColor *_Nonnull)colorWithRGB:(int)rgbValue EFDeprecated("Use COLOR_HEXSTRING(hexString) instead, first deprecated in ExtremeFramework 2.0.");

/**
 方法已在极致框架2.0弃用，使用 COLOR_HEXSTRING_ALPHA(hexString, alphaValue) 来代替。(Use COLOR_HEXSTRING_ALPHA(hexString, alphaValue) instead, first deprecated in ExtremeFramework 2.0.)
 */
+ (UIColor *_Nonnull)colorWithRGB:(int)rgbValue alpha:(CGFloat)alphaValue EFDeprecated("Use COLOR_HEXSTRING_ALPHA(hexString, alphaValue) instead, first deprecated in ExtremeFramework 2.0.");

@end
