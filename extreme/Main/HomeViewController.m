//
//  HomeViewController.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/20.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
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
    
    if (self.previousViewController) {
        self.navigationBarStyle = EFBarStyleTranslucent;
        
        self.navigationItem.rightBarButtonItems = nil;
        _list_button.hidden = YES;
    }
    else {
//        self.navigationBarStyle = EFBarStyleBlack; //深色风格
        _list_button.backgroundColor = self.navigationBar.barTintColor;
        [_list_button setTitleColor:self.navigationBar.tintColor forState:UIControlStateNormal];
        
//        NSString *token = [USER_DEFAULTS objectForKey:@"Token"];
//        if (!token) {
//            //TODO: 要求登录
//            [AppUtils presentLoginVC];
//            RUN_AFTER(SVShowStatusDelayTime, ^{
//                [SVProgressHUD showInfoWithStatus:@"开始前，轻点登录(演示帐号)"];
//            });
//        }
//        else {
//            //TODO: 登录成功
//            [AbilityAccountManager myNickNameResult:^(BOOL success, id _Nullable responseObj) {
//                if (success) {
//                    RUN_AFTER(SVShowStatusDelayTime, ^{
//                        [SVProgressHUD showSuccessWithStatus:STRING_FORMAT(@"欢迎回来 %@", ![EFUtils objectIsNull:responseObj withKey:result_key]?[EFUtils stringFromDictionary:responseObj withKey:result_key]:@"请设置昵称")];
//                    });
//                }
//                else {
//                    AFHTTPError *http_error = responseObj;
//                    if (http_error.isUserLevel) {
//                        RUN_AFTER(SVShowStatusDelayTime, ^{
//                            [SVProgressHUD showErrorWithStatus:http_error.errorDescription];
//                        });
//                    }
//                }
//            }];
//        }
    }
}


//MARK: 导航栏操作按钮初始化
- (void)rightBarButtonItems {
    UIBarButtonItem *login_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"版本" style:UIBarButtonItemStylePlain target:self action:@selector(version:)];
    self.navigationItem.rightBarButtonItems = @[login_barButtonItem];
}

//MARK: 主要操作按钮初始化
- (void)version:(id)sender {
    [SVProgressHUD showInfoWithStatus:STRING_FORMAT(@"%@ 版本 %@(内部版本 %@)", APP_NAME, APP_VERSION, APP_BUILD)];
}

//MARK: 功能列表
- (IBAction)list:(id)sender {
    [self performSegueWithIdentifier:@"list_segue" sender:sender];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}

@end
