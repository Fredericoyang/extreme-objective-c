//
//  EFUtils.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "EFUtils.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation EFUtils

//MARK: 获取 storyboard中控制器的实例
+ (id)sharedStoryboardInstanceWithStoryName:(NSString *_Nonnull)storyboardName storyboardID:(NSString *_Nonnull)storyboardID {
    UIStoryboard *storyboardHealthAssistant = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    id baseViewController = [storyboardHealthAssistant instantiateViewControllerWithIdentifier:storyboardID];
    return baseViewController;
}


//MARK: - 检查字符串值是否合法
+ (BOOL)checkValue:(NSString *_Nonnull)stringValue byRegExp:(NSString *_Nonnull)regExp {
    NSPredicate *test=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [test evaluateWithObject:stringValue];
}


//MARK: 对象判空
+ (BOOL)objectIsNullOrEmpty:(id _Nonnull)object {
    return (!object || [object isKindOfClass:[NSNull class]]);
}

//MARK: 字符串判空
+ (BOOL)stringIsNullOrEmpty:(NSString *_Nonnull)string {
    return (!string || ![string isKindOfClass:[NSString class]] || !string.length);
}

//MARK: 指定键值转换为字符串
+ (NSString *_Nullable)stringFromDictionary:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key {
    return [dictionary[key] isKindOfClass:[NSString class]] ? dictionary[key] : (![EFUtils objectIsNull:dictionary withKey:key]?((NSNumber *)dictionary[key]).stringValue:nil);
}

//MARK: 指定键值是否为空
+ (BOOL)objectIsNull:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key{
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        id value = dictionary[key];
        if (![value isKindOfClass:[NSNull class]] && value!=nil) {
            return NO;
        }
    }
    return YES;
}

//MARK: 所有键值是否存在空
+ (BOOL)validDictionary:(NSDictionary *_Nonnull)dictionary {
    BOOL isNull = NO;
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        NSArray *keys_array = dictionary.allKeys;
        for (NSString *key in keys_array) {
            id value = dictionary[key];
            if ([value isKindOfClass:[NSNull class]]) {
                isNull = YES;
                break;
            }
        }
    }
    return isNull;
}

//MARK: 指定键值是否等于指定数值
+ (BOOL)objectValueIsEqualTo:(NSInteger)value dictionary:(NSDictionary *_Nonnull)dictionary withKey:(NSString *_Nonnull)key {
    return [dictionary[key] isKindOfClass:[NSString class]] ? (((NSString *)dictionary[key]).integerValue==value) : (![EFUtils objectIsNull:dictionary withKey:key]?((NSNumber *)dictionary[key]).integerValue==value:NO);
}

//MARK: 将NSNumber转换为BOOL
+ (BOOL)boolValueFromNumber:(NSNumber *)number {
    if ([number isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return number.boolValue;
}


#pragma mark - Date fomartter 日期格式字符格式化
+ (NSString *)stringFromDate:(NSDate *_Nonnull)date {
    return [EFUtils stringFromDate:date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)stringFromDate:(NSDate *_Nonnull)date dateTime:(BOOL)dateTime {
    NSString *dateFormat;
    if (dateTime) {
        dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    else {
        dateFormat = @"yyyy-MM-dd";
    }
    return [EFUtils stringFromDate:date dateFormat:dateFormat];
}

+ (NSString *)stringFromDate:(NSDate *_Nonnull)date dateFormat:(NSString *_Nonnull)dateFormat {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormat];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *str = [df stringFromDate:date];
    return str;
}

+ (NSString *)stringFromDateString:(NSString *_Nonnull)dateString dateFormat:(NSString *_Nonnull)dateFormat {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:dateString];
    return [EFUtils stringFromDate:date dateFormat:dateFormat];
}

+ (NSString *)stringFromDateTimeString:(NSString *_Nonnull)dateString dateTime:(BOOL)dateTime dateFormat:(NSString *_Nonnull)dateFormat {
    NSString *sourceDateFormat;
    if (dateTime) {
        sourceDateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    else {
        sourceDateFormat = @"yyyy-MM-dd";
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:sourceDateFormat];
    NSDate *date = [df dateFromString:dateString];
    return [EFUtils stringFromDate:date dateFormat:dateFormat];
}


//MARK: - DES加密
#define LocalStr_None @"" // 排除空白字符
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+ (NSString *)base64StringFromText:(NSString *_Nonnull)text
{
    if (text && ![text isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY
        NSString *key = @"BO8FCScZ";
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin
        data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data];
    }
    else {
        return LocalStr_None;
    }
}

+ (NSString *)textFromBase64String:(NSString *_Nonnull)base64
{
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY
        NSString *key = @"BO8FCScZ";
        NSData *data = [self dataWithBase64EncodedString:base64];
        //IOS 自带DES解密 Begin
        data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}

/************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 **********************************************************/
+ (NSData *)DESEncrypt:(NSData *_Nonnull)data WithKey:(NSString *_Nonnull)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 **********************************************************/
+ (NSData *)DESDecrypt:(NSData *_Nonnull)data WithKey:(NSString *_Nonnull)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 **********************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *_Nonnull)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:@"string must be non-null"];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 **********************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *_Nonnull)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@end
