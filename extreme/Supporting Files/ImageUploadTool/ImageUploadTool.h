//
//  ImageUploadTool.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/12/22.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageUploadConfig.h"

#define saveJPEGPicture(i, s, t) [ImageUploadTool saveJPEGPicture:(UIImage*)i size:(CGSize)s type:(SAVE_PICTURE_TYPE)t]

typedef NS_ENUM(NSInteger, SAVE_PICTURE_TYPE) {
    SAVE_PICTURE_KEEP_SIZE,     // 保持不变
    SAVE_PICTURE_FIT_SIZE,      // 等比例拉伸，使图片完全保留
    SAVE_PICTURE_FILL_SIZE,     // 等比例拉伸，使图片填满给定的区域
    SAVE_PICTURE_STRETCH        // 拉伸以填满指定区域
};

@interface AFUploadImageModel : NSObject

// 图片数据(与图片对象任选，优先图片数据)
@property (strong, nonatomic, nonnull) NSData *imageData;
// 图片名称
@property (copy, nonatomic, nonnull) NSString *imageName;
// 图片使用的键
@property (copy, nonatomic, nonnull) NSString *key;

@end

@interface ImageUploadTool : NSObject

/**
 将 UIImage 实例转为 JPEG 格式的 NSData 实例

 @param image UIImage 实例
 @param size 转换后的图像尺寸，单位：像素
 @param type 缩放类型，见 SAVE_PICTURE_TYPE 枚举
 @return NSData 实例
 */
+ (NSData *_Nonnull)saveJPEGPicture:(UIImage *_Nonnull)image size:(CGSize)size type:(SAVE_PICTURE_TYPE)type;

/**
 上传图片
 
 @param url 接口URL
 @param imageData 图片文件数据
 @param imageName 图片名称，缺省为"image"
 @param imageAPIKey 服务器API字段，缺省为"image"
 @param message 消息文本
 @param result 返回结果
 @return NSURLSessionDataTask实例
 */
+ (NSURLSessionDataTask *_Nonnull)uploadImage:(NSString *_Nonnull)url imageData:(NSData *_Nonnull)imageData imageName:(NSString *_Nullable)imageName imageAPIKey:(NSString *_Nullable)imageAPIKey message:(NSString *_Nullable)message result:(RequestResultBlock)result;

@end
