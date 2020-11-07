//
//  ImageUploadTest_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/12/22.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "ImageUploadTest_VC.h"

@interface ImageUploadTest_VC ()

@end

@implementation ImageUploadTest_VC {
    BOOL _isPresented;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)longPressToShowImageTool:(UILongPressGestureRecognizer *)sender {
    if (!_isPresented) {
        _isPresented = YES;
        @WeakObj(self);
        [self showPhotoPickerWithMessage:@"上传头像" sourceView:sender.view completion:^{
            self->_isPresented = NO;
        }];
        self.photoPickerResult = ^(UIImagePickerController *imagePicker, NSDictionary *mediaInfo) {
            @StrongObj(self);
            UIImage *image = [mediaInfo objectForKey:UIImagePickerControllerOriginalImage];
            // 本地演示
            [self.avatar_imageView setImage:image];
            [self dismissViewControllerAnimated:YES completion:nil];
            
//            NSString *imageName = FORMAT_STRING(@"%.0lf",[[NSDate date] timeIntervalSince1970]);
//            NSData *imageData = saveJPEGPicture(image, CGSizeMake(414,368), SAVE_PICTURE_FILL_SIZE);
//            NSURLSessionDataTask *dataTask = [ImageUploadTool uploadImage:RU_UploadImage imageData:imageData imageName:imageName imageAPIKey:@"image" message:@"头像上传中" result:^(BOOL success, id responseObj) {
//                if (success) {
//                    [self.avatar_imageView sd_setImageWithURL:[NSURL URLWithString:responseObj[result_key][imageFileURL_key]] placeholderImage:IMAGE(@"extreme.bundle/default_pic")];
//                }
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }];
//            if (dataTask) {
//                [self.dataTasks addObject:dataTask];
//            }
        };
    }
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
