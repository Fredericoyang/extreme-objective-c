//
//  Login_TVC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "Login_TVC.h"
#import "../Contact/Model/ContactModel.h"
#import "Manager/AbilityAccountManager.h"

@implementation InputCell

@synthesize control = _control;

@end


@interface Login_TVC () <UITextFieldDelegate>

@end

@implementation Login_TVC {
    NSMutableArray *_textFields_mArray;
    NSMutableArray *_contacts_mArray; // 模拟数据源
    NSInteger _selectedContactID;
    NSArray *_selectedContactIDs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textFields_mArray = [NSMutableArray array];
    
    NSArray *dataSource_array = @[@{@"ContactID":@1, @"ContactMobile":@"180xxxxxxx1"},
                                       @{@"ContactID":@2, @"ContactMobile":@"180xxxxxxx2"},
                                       @{@"ContactID":@3, @"ContactMobile":@"180xxxxxxx3"},
                                       @{@"ContactID":@4, @"ContactMobile":@"180xxxxxxx4"},
                                       @{@"ContactID":@5, @"ContactMobile":@"180xxxxxxx5"}];
    _contacts_mArray = [NSMutableArray array];
    for (NSDictionary *dict in dataSource_array) {
        NSError *error;
        ContactModel *model = [[ContactModel alloc] initWithDictionary:dict error:&error];
        if (model) {
            [_contacts_mArray addObject:model];
        }
    }
    
    self.adjustTableViewEdgeInsetsToFitKeyboard = YES;
}


- (UIView *)selectedBackgroundView {
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, 0.5)];
    selectedBackgroundView.backgroundColor = COLOR_HEXSTRING_ALPHA(@"#EEEEEE", 0.5);
    return selectedBackgroundView;
}


//MARK: 登录模拟
- (void)tapToLogin {
    NSString *userName = ((EFTextField *)_textFields_mArray.firstObject).text;
    NSString *userPassword = ((EFTextField *)_textFields_mArray.lastObject).text;
    if (![AppUtils checkUserName:userName]) {
        [SVProgressHUD showInfoWithStatus:@"用户名是11位手机号码"];
        return;
    }
    else if (![AppUtils checkUserPassword:userPassword]) {
        [SVProgressHUD showInfoWithStatus:@"密码由6-18位字母或数字组成"];
        return;
    }
//    [AbilityAccountManager loginWithUserName:userName password:userPassword result:^(BOOL success, id _Nullable responseObj) {
//        if (success) {
//            // 保存token
//            [USER_DEFAULTS setValue:[EFUtils stringFromDictionary:responseObj withKey:result_key] forKey:@"Token"];
//            [USER_DEFAULTS synchronize];
//
//            if (NAVIGATION_CONTROLLER.originalViewController) {
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }
//
//            // 显示欢迎信息
//            [AbilityAccountManager myNickNameResult:^(BOOL success, id _Nullable responseObj) {
//                RUN_AFTER(SVShowStatusDelayTime, ^{
//                    [SVProgressHUD showSuccessWithStatus:STRING_FORMAT(@"欢迎回来 %@", ![EFUtils objectValueIsNilOrNull:responseObj withKey:result_key]?[EFUtils stringFromDictionary:responseObj withKey:result_key]:@"请设置昵称")];
//                });
//            }];
//        }
//        else {
//            AFHTTPError *http_error = responseObj;
//            if (http_error.isUserLevel) {
//                [SVProgressHUD showErrorWithStatus:http_error.errorDescription];
//            }
//        }
//    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[InputCell class]]) {
        InputCell *input_cell = cell;
        self.focusedControl = input_cell.control;
        [input_cell.control becomeFirstResponder];
    }
    else {
        for (EFTextField *textField in _textFields_mArray) {
            [textField resignFirstResponder];
        }
        [self tapToLogin];
    }
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InputCell *cell = (InputCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectedBackgroundView = [self selectedBackgroundView];
    if ([cell isMemberOfClass:[InputCell class]] && ![_textFields_mArray containsObject:cell.control]) {
        ((EFTextField *)cell.control).placeHolderColor = [UIColor systemBlueColor];
        [_textFields_mArray addObject:cell.control];
    }
    return cell;
}


#pragma mark - Textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    InputCell *input_cell = (InputCell *)[[textField superview] superview];
    [input_cell setSelected:YES];
    self.focusedControl = textField;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    InputCell *cell = (InputCell *)[[textField superview] superview];
    [cell setSelected:NO];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_textFields_mArray.firstObject]) {
        [_textFields_mArray.lastObject becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     [super prepareForSegue:segue sender:sender];
     
     id dest_VC = [segue destinationViewController];
     if ([dest_VC isKindOfClass:[UINavigationController class]]) {
         EFBaseViewController *root_VC = [((EFBaseNavigationController *)dest_VC).viewControllers firstObject];
         if ([root_VC isKindOfClass:[EFBaseModalDialogViewController class]]) {
             if ([segue.identifier isEqualToString:@"contacts_segue"]) {
                 for (EFTextField *textField in _textFields_mArray) {
                     [textField resignFirstResponder];
                 }
                 
                 ListSelector_VC *list_selector = (ListSelector_VC *)root_VC;
                 list_selector.navigationBarDark = YES;
                 list_selector.iconImageName = @"extreme.bundle/icon-default-modal";
                 list_selector.titleText = @"选择联系人";
                 list_selector.singled = YES;
                 list_selector.dataSource_mArray = [_contacts_mArray copy];
                 list_selector.selectedDataID = @(_selectedContactID);
//                 list_selector.selectedDataIDs = _selectedContactIDs;
                 @WeakObject(list_selector);
                 list_selector.OKHandler = ^(NSArray *dataIDs, NSArray *dataNames) {
                     @StrongObject(list_selector);
                     if (dataNames.count > 0) {
                         self->_selectedContactID = [dataIDs.lastObject integerValue];
//                         self->_selectedContactIDs = dataIDs;
                         ((EFTextField *)self->_textFields_mArray.firstObject).text = dataNames.lastObject;
                     }
                     else {
                         [SVProgressHUD showErrorWithStatus:@"获取失败"];
                     }
                     [list_selector closeModalDialog];
                 };
             }
         }
     }
 }

@end
