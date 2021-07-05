//
//  ShowNoDataImage_TVC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/6/10.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "ShowNoDataImage_TVC.h"

@interface showNoDataImage_TVC ()

@end

@implementation showNoDataImage_TVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.enableNoDataDebug = EFUIKit_enableDebug;
    [self setNoDataImageName:@"extreme.bundle/no_bill" width:88 height:105];
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
