//
//  UseCustomBack_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2019/9/4.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "UseCustomBack_VC.h"

@interface UseCustomBack_VC ()

@end

@implementation UseCustomBack_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *another_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭自定义" style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    self.navigationItem.leftBarButtonItem = another_barButtonItem;
    
    self.customBack_barButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"extreme.bundle/icon-close-modal") style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    self.useCustomBack = YES;
    self.customBack_barButtonItem = nil;

//    NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
//    [leftBarButtonItems addObject:another_barButtonItem];
//    [self.navigationItem setLeftBarButtonItems:leftBarButtonItems animated:YES];

//    self.useCustomBack = NO;
//    another_barButtonItem.title = @"移除";
}


- (void)buttonAction:(id)sender {
    if (self.isUseCustomBack) {
        self.useCustomBack = NO;
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
