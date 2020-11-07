//
//  CustomBackButton_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/6/9.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "CustomBackButton_VC.h"

@interface CustomBackButton_VC ()

@end

@implementation CustomBackButton_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customBack_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"自定义返回按钮" style:UIBarButtonItemStylePlain target:self action:@selector(customBack:)];
    self.useCustomBack = YES;
    
    if (self.isUseCustomBack) {
        UIBarButtonItem *back_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭自定义" style:UIBarButtonItemStylePlain target:self action:@selector(pop:)];
        self.navigationItem.leftBarButtonItems = @[self.customBack_barButtonItem, back_barButtonItem];
    }
    
    @WeakObj(self);
    self.tapCustomBack = ^(id sender) {
        @StrongObj(self);
        UIBarButtonItem *button = sender;
        if ([button.title isEqualToString:@"自定义返回按钮"]) {
            self.customBack_barButtonItem = nil;
        }
        else {
            self.customBack_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"自定义返回按钮" style:UIBarButtonItemStylePlain target:self action:@selector(customBack:)];
        }
    };
}


- (void)customBack:(id)sender {
    self.customBack_barButtonItem = nil;
}

- (void)pop:(id)sender {
    if (self.isUseCustomBack) {
        UIBarButtonItem *button = sender;
        if ([button.title isEqualToString:@"关闭自定义"]) {
            self.navigationItem.leftBarButtonItems = @[self.customBack_barButtonItem];
            self.useCustomBack = NO;
            if (self.tapCustomBack) {
                self.tapCustomBack = nil;
            }
        }
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"必须先启用 useCustomBack"];
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
