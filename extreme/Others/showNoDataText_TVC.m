//
//  ShowNoDataText_TVC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/6/10.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "ShowNoDataText_TVC.h"

@interface showNoDataText_TVC ()

@end

@implementation showNoDataText_TVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.enableNoDataDebug = EFUIKit_enableDebug;
    self.noDataText = @"无数据";
    self.noDataTextFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.noDataTextColor = COLOR_HEXSTRING(@"#8888FF");
    [self showNoData];
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
