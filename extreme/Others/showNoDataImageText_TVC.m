//
//  showNoDataImageText_TVC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/6/10.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "showNoDataImageText_TVC.h"

@interface showNoDataImageText_TVC ()

@end

@implementation showNoDataImageText_TVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNoDataImageName:@"car_animated" noDataImageExt:@"gif" width:90 height:90];
    [self setNoDataText:@"图标图像还可以设置动图\n文字也可以设置不止一行呢" width:SCREEN_WIDTH lines:2];
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
