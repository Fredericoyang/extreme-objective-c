//
//  LevelSelector_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/21.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "LevelSelector_VC.h"
#import "LevelModel.h"

@interface LevelSelector_VC ()

@end

@implementation LevelSelector_VC {
    NSArray *_lv2_array; // 用于暂存2级列表数据源
    NSString *_lv1Name;  // 用于暂存1级显示名称
    NSNumber *_selectedDataID;
    NSString *_selectedDataText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}


#pragma mark - 加载数据
- (void)loadData {
    if (self.dataSource_mArray.count > 0) {
        // 默认选择第一条
        LevelOneModel *lv1_model = self.dataSource_mArray[0];
        if (!_single) {
            _lv1Name = lv1_model.dataName;
            _lv2_array = [lv1_model.levelTwo_array copy];
            LevelTwoModel *lv2_model = _lv2_array[0];
            _selectedDataID = lv2_model.dataID;
            _selectedDataText = STRING_FORMAT(@"%@ %@", _lv1Name, lv2_model.dataName);
        }
        else {
            _selectedDataID = lv1_model.dataID;
            _selectedDataText = lv1_model.dataName;
        }
    }
    [_pickerView reloadAllComponents];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (!_single) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (1 == component) {
        return _lv2_array.count;
    }
    return self.dataSource_mArray.count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (1 == component) {
        LevelTwoModel *model = _lv2_array[row];
        return model.dataName;
    }
    LevelOneModel *model = self.dataSource_mArray[row];
    return model.dataName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (1 == component) {
        LevelTwoModel *model = _lv2_array[row];
        _selectedDataID = model.dataID;
        _selectedDataText = STRING_FORMAT(@"%@ %@", _lv1Name, model.dataName);
    }
    else if (0 == component) {
        LevelOneModel *model = self.dataSource_mArray[row];
        if (!_single) {
            _lv1Name = model.dataName;
            _lv2_array = [model.levelTwo_array copy];
            LevelTwoModel *lv2_model = _lv2_array[0];
            _selectedDataID = lv2_model.dataID;
            _selectedDataText = STRING_FORMAT(@"%@ %@", _lv1Name, lv2_model.dataName);
            [_pickerView reloadComponent:1];
        }
        else {
            _selectedDataID = model.dataID;
            _selectedDataText = model.dataName;
        }
    }
}

/**
 级联选择器回调处理
 
 @param sender the ok button
 */
- (void)OKHandler:(id)sender {
    if (_OKHandler) {
        _OKHandler(_selectedDataID, _selectedDataText);
        [self closeModalDialog];
    }
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
