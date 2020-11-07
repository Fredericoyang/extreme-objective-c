//
//  HomeViewController.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/20.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "HomeViewController.h"
#import "../User/Manager/AbilityAccountManager.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self rightBarButtonItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarStyle = EFBarStyleTranslucent;
    self.navigationBar.dark = YES;
    if (self.previousViewController) {
        self.navigationItem.rightBarButtonItems = nil;
        _list_button.hidden = YES;
        [SVProgressHUD showInfoWithStatus:@"你没看错！首页就是应用了透明样式导航栏"];
    }
    else {
        NSString *token = [USER_DEFAULTS objectForKey:@"token"];
        if (!token) {
            //TODO: 登录
            [AppUtils presentLoginVC];
            RUN_AFTER(SVShowStatusDelayTime, ^{
                [SVProgressHUD showInfoWithStatus:@"开始前，轻点登录(演示帐号)"];
            });
        }
        else {
            // 显示欢迎信息
            [AbilityAccountManager myNickNameResult:^(BOOL success, id _Nullable responseObj) {
                if (success) {
                    RUN_AFTER(SVShowStatusDelayTime, ^{
                        [SVProgressHUD showSuccessWithStatus:FORMAT_STRING(@"欢迎回来 %@", ![EFUtils objectIsNull:responseObj withKey:result_key]?[EFUtils stringFromDictionary:responseObj withKey:result_key]:@"请设置昵称")];
                    });
                }
                else {
                    AFHTTPError *http_error = responseObj;
                    if (http_error.isUserLevel) {
                        RUN_AFTER(SVShowStatusDelayTime, ^{
                            [SVProgressHUD showErrorWithStatus:http_error.errorDescription];
                        });
                    }
                }
            }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationBar.dark = NO;
}


#pragma mark 导航栏操作按钮初始化
- (void)rightBarButtonItems {
    UIBarButtonItem *login_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"版本" style:UIBarButtonItemStylePlain target:self action:@selector(version:)];
    self.navigationItem.rightBarButtonItems = @[login_barButtonItem];
}

- (void)version:(id)sender {
    [SVProgressHUD showInfoWithStatus:FORMAT_STRING(@"%@ 版本 %@(内部版本 %@)", APP_NAME, APP_VERSION, APP_BUILD)];
}

#pragma mark 功能列表
- (IBAction)list:(id)sender {
    [self performSegueWithIdentifier:@"list_segue" sender:sender];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}

@end
