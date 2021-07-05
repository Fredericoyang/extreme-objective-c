//
//  EFUtils.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFUtils.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation EFUtils

//MARK: - 验证值是否合法 Validate the value

+ (BOOL)objectIsNilOrNull:(id _Nonnull)object {
    return (!object || [object isKindOfClass:[NSNull class]]);
}

+ (BOOL)stringIsNilOrNullOrEmpty:(NSString *_Nonnull)string {
    return (!string || ![string isKindOfClass:[NSString class]] || !string.length);
}

+ (BOOL)validateString:(NSString *_Nonnull)string byRegExp:(NSString *_Nonnull)regExp {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:string];
}

+ (BOOL)objectValueIsNilOrNull:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key{
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        id value = dictionary[key];
        return [EFUtils objectIsNilOrNull:value];
    }
    return YES;
}

+ (BOOL)objectValueIsEqualTo:(id _Nonnull)value dictionary:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key {
    return [dictionary[key] isKindOfClass:[NSString class]] ? ([dictionary[key] integerValue]==[value integerValue]) : (![EFUtils objectValueIsNilOrNull:dictionary withKey:key]?[dictionary[key] integerValue]==[value integerValue]:NO);
}

+ (BOOL)validateDictionary:(NSDictionary *_Nonnull)dictionary {
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        __block BOOL isNull = NO;
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
            if ([EFUtils objectIsNilOrNull:obj]) {
                isNull = YES;
            }
        }];
        return !isNull;
    }
    return NO;
}


//MARK: - 转换 Conversions

+ (NSString *_Nullable)stringFromDictionary:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key {
    return [dictionary[key] isKindOfClass:[NSString class]] ? dictionary[key] : (![EFUtils objectValueIsNilOrNull:dictionary withKey:key]?[dictionary[key] stringValue]:nil);
}

+ (BOOL)boolValueFromNumber:(NSNumber *_Nullable)number {
    if ([EFUtils objectIsNilOrNull:number]) {
        return NO;
    }
    return number.boolValue;
}

+ (NSString *_Nullable)JSONToString:(id _Nonnull)json {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString;
    if (!jsonData) {
        LOG_FORMAT(@"[FAIL]+JSONToString:, message: %@", error.localizedDescription);
        return nil;
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0, jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0, mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (id _Nullable)stringToJSON:(NSString *_Nonnull)jsonString {
    NSError *error;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        return nil;
    }
    id json = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingMutableContainers
                                                error:&error];
    if (!json) {
        LOG_FORMAT(@"[FAIL]+stringToJSON:, message: %@", error.localizedDescription);
        return nil;
    }
    return json;
}


//MARK: - 日期格式字符串格式化 Date fomartter

+ (NSString *_Nullable)stringFromDate:(NSDate *_Nonnull)date {
    return [EFUtils stringFromDate:date dateTime:NO];
}

+ (NSString *_Nullable)stringFromDate:(NSDate *_Nonnull)date dateTime:(BOOL)dateTime {
    NSString *dateFormat;
    if (dateTime) {
        dateFormat = @"yyyy-MM-dd HH:mm:ss";
    } else {
        dateFormat = @"yyyy-MM-dd";
    }
    return [EFUtils stringFromDate:date dateFormat:dateFormat];
}

+ (NSString *_Nullable)stringFromDate:(NSDate *_Nonnull)date dateFormat:(NSString *_Nonnull)dateFormat {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = dateFormat;
    NSLocale *locale = [NSLocale currentLocale];
    df.locale = locale;
    NSString *str = [df stringFromDate:date];
    return str;
}

+ (NSString *_Nullable)stringFromDateFormattedString:(NSString *_Nonnull)dateFormattedString dateFormat:(NSString *_Nonnull)dateFormat {
    return [EFUtils stringFromDateFormattedString:dateFormattedString dateTime:NO dateFormat:dateFormat];
}

+ (NSString *_Nullable)stringFromDateFormattedString:(NSString *_Nonnull)dateFormattedString dateTime:(BOOL)dateTime dateFormat:(NSString *_Nonnull)dateFormat {
    NSDate *date = [EFUtils dateFromDateFormattedString:dateFormattedString dateTime:dateTime];
    return [EFUtils stringFromDate:date dateFormat:dateFormat];
}

+ (NSString *_Nullable)stringFromDateFormattedString:(NSString *_Nonnull)dateFormattedString dateFormatIn:(NSString *_Nonnull)dateFormatIn dateFormatOut:(NSString *_Nonnull)dateFormatOut {
    NSDate *date = [EFUtils dateFromDateFormattedString:dateFormattedString dateFormatIn:dateFormatIn];
    return [EFUtils stringFromDate:date dateFormat:dateFormatOut];
}

+ (NSDate *_Nullable)dateFromDateFormattedString:(NSString *_Nonnull)dateFormattedString {
    return [EFUtils dateFromDateFormattedString:dateFormattedString dateTime:NO];
}

+ (NSDate *_Nullable)dateFromDateFormattedString:(NSString *_Nonnull)dateFormattedString dateTime:(BOOL)dateTime {
    NSString *sourceDateFormat;
    if (dateTime) {
        sourceDateFormat = @"yyyy-MM-dd HH:mm:ss";
    } else {
        sourceDateFormat = @"yyyy-MM-dd";
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = sourceDateFormat;
    return [df dateFromString:dateFormattedString];
}

+ (NSDate *_Nullable)dateFromDateFormattedString:(NSString *_Nonnull)dateFormattedString dateFormatIn:(NSString *_Nonnull)dateFormatIn {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = dateFormatIn;
    return [df dateFromString:dateFormattedString];
}


//MARK: - 编码为 base64字符串和解码为 NSData base64 encoding and decoding

+ (NSString *_Nullable)dataBase64EncodingWith:(NSData *_Nonnull)data {
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (NSData *_Nullable)dataBase64DecodingFrom:(NSString *_Nonnull)base64EncodedString {
    return [[NSData data] initWithBase64EncodedString:base64EncodedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
}


//MARK: - UIKit
//MARK: UIColor

+ (UIColor *_Nullable)colorWithHexString:(NSString *_Nonnull)hexString {
    return [EFUtils colorWithHexString:hexString alpha:1];
}

+ (UIColor *_Nullable)colorWithHexString:(NSString *_Nonnull)hexString alpha:(CGFloat)alpha {
    //去除空白字符并全部转成大写
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //把开头截取
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    else if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    //仅处理常见的6位和8位
    if ([cString length]!=6 && [cString length]!=8) {
        return nil;
    }
    //取出不透明度、红、绿、蓝
    unsigned int a, r, g, b;
    NSRange range;
    range.length = 2;
    if (cString.length == 8) {
        //a
        range.location = 0;
        NSString *aString = [cString substringWithRange:range];
        //r
        range.location = 2;
        NSString *rString = [cString substringWithRange:range];
        //g
        range.location = 4;
        NSString *gString = [cString substringWithRange:range];
        //b
        range.location = 6;
        NSString *bString = [cString substringWithRange:range];
        
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return alpha<1 ? [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:alpha] : [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:(a / 255.0f)];
    } else {
        //r
        range.location = 0;
        NSString *rString = [cString substringWithRange:range];
        //g
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        //b
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:alpha];
    }
}

+ (NSString *_Nullable)hexStringWithColor:(UIColor *_Nonnull)color {
    NSInteger count = CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    if (count == 4) {
        CGFloat r = components[0];
        CGFloat g = components[1];
        CGFloat b = components[2];
        CGFloat a = components[3];
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX", lroundf(a * 255), lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
    } else {
        CGFloat c = components[0];
        CGFloat a = components[1];
        if (1.0 == a) {
            return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(c * 255), lroundf(c * 255), lroundf(c * 255)];
        }
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX", lroundf(c * 255), lroundf(c * 255), lroundf(c * 255), lroundf(a * 255)];
    }
}


//MARK: -

+ (id _Nonnull)sharedControllerInstanceWithStoryName:(NSString *_Nonnull)storyboardName andStoryboardID:(NSString *_Nonnull)storyboardID {
    UIStoryboard *storyboardHealthAssistant = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    id baseViewController = [storyboardHealthAssistant instantiateViewControllerWithIdentifier:storyboardID];
    return baseViewController;
}

+ (void)removeAllSubviewsOf:(UIView *_Nonnull)parentView {
    for (UIView *view in parentView.subviews) {
        [view removeFromSuperview];
    }
}

+ (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrcodeImage;
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的 frame
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}


//MARK: - Deprecated

+ (id _Nonnull)sharedStoryboardInstanceWithStoryName:(NSString *_Nonnull)storyboardName storyboardID:(NSString *_Nonnull)storyboardID {
    return [EFUtils sharedControllerInstanceWithStoryName:@"Login" andStoryboardID:@"Login_NC"];
}

+ (BOOL)objectIsNullOrEmpty:(id _Nonnull)object {
    return [EFUtils objectIsNilOrNull:object];
}

+ (BOOL)stringIsNullOrEmpty:(NSString *_Nonnull)string {
    return [EFUtils stringIsNilOrNullOrEmpty:string];
}

+ (BOOL)checkValue:(NSString *_Nonnull)stringValue byRegExp:(NSString *_Nonnull)regExp {
    return [EFUtils validateString:stringValue byRegExp:regExp];
}

+ (BOOL)objectIsNull:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key {
    return [EFUtils objectValueIsNilOrNull:dictionary withKey:key];
}

+ (BOOL)validDictionary:(NSDictionary *_Nonnull)dictionary {
    return ![EFUtils validateDictionary:dictionary];
}

+ (NSString *_Nullable)stringFromDateString:(NSString *_Nonnull)dateString dateFormat:(NSString *_Nonnull)dateFormat {
    return [EFUtils stringFromDateFormattedString:dateString dateFormat:dateFormat];
}

+ (NSString *_Nullable)stringFromDateTimeString:(NSString *_Nonnull)dateString dateTime:(BOOL)dateTime dateFormat:(NSString *_Nonnull)dateFormat {
    return [EFUtils stringFromDateFormattedString:dateString dateTime:dateTime dateFormat:dateFormat];
}

+ (UIColor *_Nonnull)colorWithRGB:(int)rgbValue {
    return COLOR_HEXSTRING(STRING_FORMAT(@"#%02X", rgbValue));
}

+ (UIColor *_Nonnull)colorWithRGB:(int)rgbValue alpha:(CGFloat)alphaValue {
    return COLOR_HEXSTRING_ALPHA(STRING_FORMAT(@"#%02X", rgbValue), alphaValue);
}

@end
