//
//  CustomCancelButton_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/6/9.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "CustomCancelButton_VC.h"

@interface CustomCancelButton_VC ()

@end

@implementation CustomCancelButton_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customCancel_barButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"extreme.bundle/back") style:UIBarButtonItemStylePlain target:self action:@selector(customCancel:)];
    
    UIBarButtonItem *cancel_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭自定义" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
    
    self.navigationItem.leftBarButtonItems = @[self.customCancel_barButtonItem, cancel_barButtonItem];
    
    @WeakObj(self);
    self.tapCustomCancel = ^(id sender) {
        @StrongObj(self);
        UIBarButtonItem *button = sender;
        if (button.image) {
            self.customCancel_barButtonItem = nil;
        }
        else {
            self.customCancel_barButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"extreme.bundle/back") style:UIBarButtonItemStylePlain target:self action:@selector(customCancel:)];
        }
    };
}


- (void)customCancel:(id)sender {
    self.customCancel_barButtonItem = nil;
}

- (void)dismiss:(id)sender {
    UIBarButtonItem *button = sender;
    if ([button.title isEqualToString:@"关闭自定义"]) {
        self.navigationItem.leftBarButtonItems = @[self.customCancel_barButtonItem];
        self.customCancel_barButtonItem = nil;
        if (self.tapCustomCancel) {
            self.tapCustomCancel = nil;
        }
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
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
