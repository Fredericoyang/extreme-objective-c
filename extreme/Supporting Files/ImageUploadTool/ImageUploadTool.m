//
//  ImageUploadTool.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/12/22.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "ImageUploadTool.h"
#import "AFHTTPTool.h"

@implementation AFUploadImageModel

@end


@implementation ImageUploadTool

+ (NSData *_Nonnull)saveJPEGPicture:(UIImage *_Nonnull)image size:(CGSize)size type:(SAVE_PICTURE_TYPE)type {
    if(type != SAVE_PICTURE_KEEP_SIZE) {
        int w = image.size.width;
        int h = image.size.height;
        if(type == SAVE_PICTURE_FIT_SIZE) {
            float R = MIN(size.width/w, size.height/h);
            w = w*R;
            h = h*R;
        }
        else if(type == SAVE_PICTURE_FILL_SIZE) {
            float R = MAX(size.width/w, size.height/h);
            w = w*R;
            h = h*R;
        }
        else if(type == SAVE_PICTURE_STRETCH) {
            w = size.width;
            h = size.height;
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(w, h));
        [image drawInRect:CGRectMake(0, 0, w, h)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    NSData *imageData = [[NSData alloc]initWithData:UIImageJPEGRepresentation(image, 0.95)];
    NSUInteger sizeImage = [imageData length];
    NSUInteger sizeImageKb = sizeImage /1024;
    for(NSInteger i=0; sizeImageKb>200; i++){
        imageData = [[NSData alloc]initWithData:UIImageJPEGRepresentation(image, 0.90-i*0.05)];
        sizeImage = [imageData length];
        sizeImageKb = sizeImage /1024;
        if (sizeImageKb < 200) {
            return UIImageJPEGRepresentation(image, 0.90-i*0.05);
        }
    }
    return UIImageJPEGRepresentation(image, 0.95);
}

+ (NSURLSessionDataTask *_Nonnull)uploadImage:(NSString *_Nonnull)url imageData:(NSData *_Nonnull)imageData imageName:(NSString *_Nullable)imageName imageAPIKey:(NSString *_Nullable)imageAPIKey message:(NSString *_Nullable)message result:(RequestResultBlock)result
{
    if (imageData==nil || imageData.length==0) {
        NSError *error = [NSError errorWithDomain:@"uploadImage" code:400 userInfo:@{NSLocalizedDescriptionKey:@"上传图片数据为空"}];
        result(NO, error);
        return nil;
    }
    
    AFUploadImageModel *model = [[AFUploadImageModel alloc] init];
    model.imageData = imageData;
    model.imageName = imageName;
    model.key = imageAPIKey;
    
    AFHTTPSessionManager *manager = [AFHTTPTool managerForRequestType:AFHTTPRequestTypeHTTP];
    NSMutableDictionary *headers;
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
    
    AFHTTPRequestProperties *requestProperties = [[AFHTTPRequestProperties alloc] init];
    requestProperties.methodType = AFHTTPMethodTypePost;
    requestProperties.url = url;
    requestProperties.params = nil;
    requestProperties.requestType = AFHTTPRequestTypeHTTP;
    requestProperties.authorized = YES;
    requestProperties.result = result;
    [AFHTTPTool printRequestLog:requestProperties];
    
    return [manager POST:url parameters:nil headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:model.imageData name:model.key?:@"image" fileName:model.imageName?:@"image" mimeType:@"image/jpeg"];
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回传进度
            if (uploadProgress) {
                float progressUnitCount = (float)uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount;
#if PrintResponseLog
                LOG_FORMAT(@"progress: %.0f%%", progressUnitCount*100);
#endif
                if (progressUnitCount < 1) {
                    [SVProgressHUD showProgress:progressUnitCount status:STRING_FORMAT(@"%@, %.0f%%", message?:@"图片上传中，请勿退出", progressUnitCount*100)];
                }
                else {
                    [SVProgressHUD showWithStatus:@"操作即将完成"];
                }
            }
        });
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [AFHTTPTool printResponseLog:requestProperties response:responseObject];
            
            if ([EFUtils objectValueIsEqualTo:statusCode_success dictionary:responseObject withKey:statusCode_key]) {
                result(YES, responseObject);
            }
            else {
                AFHTTPError *http_error = [[AFHTTPError alloc] initWithErrorCode:[EFUtils stringFromDictionary:responseObject withKey:statusCode_key]?:@"-999" errorDescription:[EFUtils stringFromDictionary:responseObject withKey:message_key]?:@"服务器未指明的错误" url:url];
                
                RUN_AFTER(SVShowStatusDelayTime, ^{
                    [SVProgressHUD showErrorWithStatus:http_error.errorDescription];
                });
                
                result(NO, http_error);
            }
        });
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        AFHTTPError *http_error = [[AFHTTPError alloc] initWithError:error url:url];
        if (!http_error.isUserLevel && [AFHTTPTool isClientLevel:http_error]) {
            RUN_AFTER(SVShowStatusDelayTime, ^{
                [SVProgressHUD showErrorWithStatus:http_error.errorDescription];
            });
        }
        else if ([http_error.errorCode isEqualToString:statusCode_expiredToken] || [http_error.errorCode isEqualToString:statusCode_incorrectToken]) {
            [AppUtils presentLoginVC];
        }
        result(NO, http_error);
    }];
}

@end
