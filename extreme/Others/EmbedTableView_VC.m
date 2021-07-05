//
//  EmbedTableView_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/7/20.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EmbedTableView_VC.h"

@implementation Survey_TVCell

@synthesize control = _control;

@end


@interface EmbedTableView_VC ()

@end

@implementation EmbedTableView_VC {
    NSMutableDictionary *_dataSource_mDictionary; // 模拟数据源
    UILabel *_surveyName_label; // 关联 cell中的 control，转为全局访问，下同
    UISegmentedControl *_surveySex_segmentedControl;
    UITextField *_surveyAge_textField;
    UILabel *_surveyBirthday_label;
    UITextField *_surveyDescription_textField;
}

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sections = 2;
    self.adjustTableViewEdgeInsetsToFitKeyboard = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _dataSource_mDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"name": @"李佳",
                                                                              @"sex": @2,
                                                                              @"age": @20,
                                                                              @"birthday": @"2001-06-30",
                                                                              @"description": @"喜欢买各种模型玩具"}];
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Survey_TVCell *cell = (Survey_TVCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (3 == indexPath.row) {
        [self performSegueWithIdentifier:@"daySelector_segue" sender:cell];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Survey_TVCell *cell = (Survey_TVCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    _surveyName_label = cell.control;
                    _surveyName_label.text = [_dataSource_mDictionary objectForKey:@"name"];
                }
                    break;
                    
                case 1: {
                    _surveySex_segmentedControl = cell.control;
                    _surveySex_segmentedControl.selectedSegmentIndex = [[_dataSource_mDictionary objectForKey:@"sex"] unsignedIntegerValue];
                }
                    break;
                    
                case 2: {
                    _surveyAge_textField = cell.control;
                    _surveyAge_textField.text = [[_dataSource_mDictionary objectForKey:@"age"] stringValue];
                }
                    break;
                    
                case 3: {
                    _surveyBirthday_label = cell.control;
                    _surveyBirthday_label.text = [EFUtils stringFromDateFormattedString:[_dataSource_mDictionary objectForKey:@"birthday"] dateFormat:@"yyyy年MM月dd日"];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 1: {
            _surveyDescription_textField = cell.control;
            _surveyDescription_textField.text = [_dataSource_mDictionary objectForKey:@"description"];
        }
            break;
            
        default:
            break;
    }
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    id dest_VC = [segue destinationViewController];
    if ([dest_VC isKindOfClass:[UINavigationController class]]) {
        EFBaseViewController *root_VC = [((EFBaseNavigationController *)dest_VC).viewControllers firstObject];
        if ([root_VC isKindOfClass:[EFBaseModalDialogViewController class]]) {
            if ([segue.identifier isEqualToString:@"daySelector_segue"]) {
                DaySelector_VC *day_selector = (DaySelector_VC *)root_VC;
                day_selector.navigationBarDark = YES;
                day_selector.iconImageName = @"extreme.bundle/icon-default-modal";
                day_selector.titleText = @"选择生日";
                [day_selector initWithDate:[EFUtils dateFromDateFormattedString:((UILabel *)((Survey_TVCell *)sender).control).text dateFormatIn:@"yyyy年MM月dd日"]];
                day_selector.OKHandler = ^(NSUInteger ti, UIDatePicker * _Nonnull datePicker) {
                    ((UILabel *)((Survey_TVCell *)sender).control).text = [EFUtils stringFromDate:[NSDate dateWithTimeIntervalSince1970:ti] dateFormat:@"yyyy年MM月dd日"];
                };
            }
        }
    }
}

@end
