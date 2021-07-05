//
//  EFBaseModalDialogViewController.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/24.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFBaseModalDialogViewController.h"
#import "EFMacros.h"
#import "EFNavigationBar.h"
#import "EFButton.h"

@interface EFBaseModalDialogViewController ()

@end

@implementation EFBaseModalDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarDark = _navigationBarDark;
    if (_iconImageName) {
        UIImage *icon_image = [IMAGE(_iconImageName) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_icon_imageView setImage:icon_image];
    }
    if (_titleText) {
        _title_label.text = _titleText;
    }
}


- (void)setNavigationBarDark:(BOOL)navigationBarDark {
    _navigationBarDark = navigationBarDark;
    
    if (_navigationBarDark) {
        self.navigationBarStyle = EFBarStyleBlack;
    }
    else {
        self.navigationBarStyle = EFBarStyleDefault;
    }
    _title_label.textColor = self.navigationBar.tintColor;
    _OKButton.backgroundColor = self.navigationBar.barTintColor;
    [_OKButton setTitleColor:_title_label.textColor forState:UIControlStateNormal];
}


- (IBAction)tapToClose:(id _Nullable)sender {
    [self closeModalDialog];
}

- (IBAction)tapToOK:(id _Nullable)sender {
    [self OKHandler:sender];
}

- (void)closeModalDialog {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)OKHandler:(id _Nullable)sender {}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
