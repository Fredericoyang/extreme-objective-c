//
//  CustomCancel_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2019/9/4.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "CustomCancel_VC.h"

@interface CustomCancel_VC ()

@end

@implementation CustomCancel_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarStyle = EFBarStyleBlack;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}

@end
