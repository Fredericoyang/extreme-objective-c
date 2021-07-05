//
//  ImageUploadTest_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/12/22.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "ImageUploadTest_VC.h"
#import <Photos/Photos.h>

@interface ImageUploadTest_VC ()

@end

@implementation ImageUploadTest_VC {
    BOOL _isPresented;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)longPressToShowImageTool:(UILongPressGestureRecognizer *)sender {
    if (!_isPresented) {
        _isPresented = YES;
        [self showPhotoPickerWithMessage:@"上传头像" isCameraDeviceFront:YES completionHandler:^{
            self->_isPresented = NO;
        }];
        @WeakObject(self);
        self.photoPickerFinishHandler = ^(id _Nonnull photoPicker, NSArray<UIImage *> *_Nonnull selectPhotos) {
            @StrongObject(self);
            if (@available(iOS 14, *)) {
                if ([photoPicker isMemberOfClass:[UIImagePickerController class]] && UIImagePickerControllerSourceTypeCamera==((UIImagePickerController *)photoPicker).sourceType) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                // PHPickerViewController will dismiss automatically
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            [self.avatar_imageView setImage:selectPhotos.firstObject];// 本地演示
//            NSString *imageName = STRING_FORMAT(@"%.0lf",[[NSDate date] timeIntervalSince1970]);
//            NSData *imageData = UIImageJPEGRepresentation(selectPhotos.firstObject, 1);
//            NSURLSessionDataTask *dataTask = [ImageUploadTool uploadImage:RU_UploadImage imageData:imageData imageName:imageName imageAPIKey:@"image" message:@"头像上传中" result:^(BOOL success, id responseObj) {
//                if (success) {
//                    [self.avatar_imageView sd_setImageWithURL:[NSURL URLWithString:responseObj[result_key][imageFileURL_key]] placeholderImage:IMAGE(@"extreme.bundle/default_pic")];
//                }
//            }];
//            if (dataTask) {
//                [self.dataTasks addObject:dataTask];
//            }
        };
    }
}


#pragma mark - Photo library change observer

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    LOG_FORMAT(@"%@", changeInstance);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
