//
//  CustomCancelButton_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/6/9.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "CustomCancelButton_VC.h"

@interface CustomCancelButton_VC ()

@end

@implementation CustomCancelButton_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *another_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭自定义" style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    [leftBarButtonItems addObject:another_barButtonItem];
    [self.navigationItem setLeftBarButtonItems:leftBarButtonItems animated:YES];
    
//    self.customCancel_barButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"extreme.bundle/icon-close-modal") style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    
    @WeakObject(self);
    self.customCancelHandler = ^(id sender) {
        @StrongObject(self);
        [SVProgressHUD showInfoWithStatus:@"自定义取消"];
        [self performSelector:@selector(buttonAction:) withObject:sender];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarStyle = EFBarStyleBlack;
}


- (void)buttonAction:(id)sender {
    if (self.customCancel_barButtonItem) {
        self.customCancel_barButtonItem = nil;
        if (self.customCancelHandler) {
            self.customCancelHandler = nil;
        }
        
        UIBarButtonItem *another_barButtonItem = self.navigationItem.leftBarButtonItems.lastObject;
        if ([another_barButtonItem.title isEqualToString:@"关闭自定义"]) {
            another_barButtonItem.title = @"移除";
        }
    }
    else {
        if (self.customCancelHandler) {
            self.customCancelHandler = nil;
            
            UIBarButtonItem *another_barButtonItem = self.navigationItem.leftBarButtonItems.lastObject;
            if ([another_barButtonItem.title isEqualToString:@"关闭自定义"]) {
                another_barButtonItem.title = @"移除";
            }
        }
        else {
            NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
            [leftBarButtonItems removeLastObject];
            [self.navigationItem setLeftBarButtonItems:leftBarButtonItems animated:YES];
        }
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
