//
//  EFBaseNavigationController.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "EFBaseNavigationController.h"
#import "EFMacros.h"

@interface EFBaseNavigationController ()

@end

@implementation EFBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


//MARK: 导航栏
- (void)setNavigationBarStyle:(EFBarStyle)navigationBarStyle {
    _navigationBarStyle = navigationBarStyle;
    if (EFBarStyleDefault == navigationBarStyle) {
        self.navigationBar.barStyle = UIBarStyleDefault;
        
        self.navigationBar.translucent = YES;
        [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:nil];
    }
    else {
        self.navigationBar.barStyle = UIBarStyleBlack;
        
        self.navigationBar.translucent = YES;
        if (EFBarStyleTranslucent == navigationBarStyle) {
            [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setShadowImage:[[UIImage alloc] init]];
        }
        else {
            [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setShadowImage:nil];
        }
    }
}

@end
