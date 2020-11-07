//
//  LABiometryTest_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/13.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "LABiometryTest_VC.h"

@interface LABiometryTest_VC ()

@end

@implementation LABiometryTest_VC {
    LABiometryTool *la_tool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    la_tool = [LABiometryTool sharedLABiometryTool];
    la_tool.fallbackButtonTitle = @"输入密码";
    LOG(@"BiometryDeviceAvailable: %d", la_tool.isLABiometryDeviceAvailable);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapToTry:(id)sender {
    _result_label.text = @"";
    [la_tool ownerAuthorizationWithDescription:@"开启指纹支付" resultBlock:^(BOOL success, id resultObject) {
        if (success) {
            self.result_label.text = FORMAT_STRING(@"验证成功 %@，不会执行任何操作", [EFUtils stringFromDate:[NSDate date]]);
        }
        else {
            LABiometryError *la_error = resultObject;
            self.result_label.text = FORMAT_STRING(@"[error %ld] %@", (long)la_error.errorCode, la_error.errorDescription);
        }
    }];
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
