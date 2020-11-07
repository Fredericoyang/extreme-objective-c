//
//  Login_TVC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "Login_TVC.h"
#import "Manager/AbilityAccountManager.h"

@implementation InputCell

@end


@interface Login_TVC () <UITextFieldDelegate>

@end

@implementation Login_TVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.adjustTableViewEdgeInsetsToFitKeyboard = YES;
}


- (void)tapToLogin {
    for (UITextField *textField in _textFields) {
        if (textField.isFirstResponder) {
            [textField resignFirstResponder];
        }
    }
    
    NSString *userName = ![EFUtils stringIsNullOrEmpty:((UITextField *)_textFields[0]).text]?((UITextField *)_textFields[0]).text:((UITextField *)_textFields[0]).placeholder;
    NSString *userPassword = ![EFUtils stringIsNullOrEmpty:((UITextField *)_textFields[1]).text]?((UITextField *)_textFields[1]).text:((UITextField *)_textFields[1]).placeholder;
    if (![AppUtils checkUserName:userName]) {
        [SVProgressHUD showInfoWithStatus:@"用户名是11位手机号码"];
        return;
    }
    else if (![AppUtils checkUserPassword:userPassword]) {
        [SVProgressHUD showInfoWithStatus:@"密码由6-18位字母或数字组成"];
        return;
    }
    [AbilityAccountManager loginWithUserName:userName password:userPassword result:^(BOOL success, id _Nullable responseObj) {
        if (success) {
            // 保存token
            [USER_DEFAULTS setValue:[EFUtils stringFromDictionary:responseObj withKey:result_key] forKey:@"token"];
            [USER_DEFAULTS synchronize];
            
            if (NAVIGATION_CONTROLLER.originalViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            // 显示欢迎信息
            [AbilityAccountManager myNickNameResult:^(BOOL success, id _Nullable responseObj) {
                RUN_AFTER(SVShowStatusDelayTime, ^{
                    [SVProgressHUD showSuccessWithStatus:FORMAT_STRING(@"欢迎回来 %@", ![EFUtils objectIsNull:responseObj withKey:result_key]?[EFUtils stringFromDictionary:responseObj withKey:result_key]:@"请设置昵称")];
                });
            }];
        }
        else {
            AFHTTPError *http_error = responseObj;
            if (http_error.isUserLevel) {
                [SVProgressHUD showErrorWithStatus:http_error.errorDescription];
            }
        }
    }];
}

- (IBAction)tapToChangeAPIEnv:(UITapGestureRecognizer *)sender {
#ifndef __OPTIMIZE__
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"服务器环境配置" message:@"仅开发测试有效" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:API_ENV==1?@"测试环境✔️":@"测试环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [USER_DEFAULTS setInteger:1 forKey:@"Test Env"];
        [USER_DEFAULTS synchronize];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:API_ENV==2?@"预生产环境✔️":@"预生产环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [USER_DEFAULTS setInteger:2 forKey:@"Test Env"];
        [USER_DEFAULTS synchronize];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:API_ENV==3?@"生产环境✔️":@"生产环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [USER_DEFAULTS setInteger:3 forKey:@"Test Env"];
        [USER_DEFAULTS synchronize];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
#endif
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[InputCell class]]) {
        InputCell *input_cell = cell;
        input_cell.selectedBackgroundView = [[UIView alloc] init];
        [input_cell.input_textField becomeFirstResponder];
        self.focusedContentOffset = [input_cell.contentView convertPoint:FRAME_ORIGIN(input_cell.input_textField) toView:self.tableView];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self tapToLogin];
    }
}


#pragma mark - Textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    InputCell *input_cell = (InputCell *)[[textField superview] superview];
    input_cell.selectedBackgroundView = [[UIView alloc] init];
    [input_cell setSelected:YES];
    self.focusedContentOffset = [textField.superview convertPoint:FRAME_ORIGIN(textField) toView:self.tableView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    InputCell *cell = (InputCell *)[[textField superview] superview];
    [cell setSelected:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSUInteger i = 0;
    if (UIReturnKeyNext == textField.returnKeyType) {
        i++;
        UITextField *next_textField = _textFields[i];
        [next_textField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
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
