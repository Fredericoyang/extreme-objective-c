//
//  CustomBackButton_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/6/9.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "CustomBackButton_VC.h"

@interface CustomBackButton_VC ()

@end

@implementation CustomBackButton_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *another_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭自定义" style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    self.navigationItem.leftBarButtonItem = another_barButtonItem;
    
    self.useCustomBack = YES;
    
    @WeakObject(self);
    self.customBackHandler = ^(id sender) {
        @StrongObject(self);
        [SVProgressHUD showInfoWithStatus:@"自定义返回"];
        [self performSelector:@selector(buttonAction:) withObject:sender];
    };
}


- (void)buttonAction:(id)sender {
    if (self.isUseCustomBack) {
        self.useCustomBack = NO;
        if (self.customBackHandler) {
            self.customBackHandler = nil;
        }
        UIBarButtonItem *another_barButtonItem = self.navigationItem.leftBarButtonItems.lastObject;
        if ([another_barButtonItem.title isEqualToString:@"关闭自定义"]) {
            another_barButtonItem.title = @"移除";
        }
    }
    else {
        [self.navigationItem setLeftBarButtonItems:nil animated:YES];
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
