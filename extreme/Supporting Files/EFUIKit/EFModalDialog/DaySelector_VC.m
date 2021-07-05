//
//  DaySelector_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/21.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "DaySelector_VC.h"

@interface DaySelector_VC ()

@end

@implementation DaySelector_VC {
    NSDate *_date;
    NSDate *_minimumDate;
    NSDate *_maximumDate;
    BOOL _showTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
    [_datePicker setTimeZone:timeZone];
    if (_date) {
        [_datePicker setDate:_date animated:YES];
    }
    if (_minimumDate) {
        [_datePicker setMinimumDate:_minimumDate];
    }
    if (_maximumDate) {
        [_datePicker setMaximumDate:_maximumDate];
    }
    if (!_showTime) {
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
}

- (void)initWithDate:(NSDate *)date {
    [self initWithDate:date minimumDate:nil maximumDate:nil showTime:NO];
}

- (void)initWithDate:(NSDate *)date showTime:(BOOL)showTime {
    [self initWithDate:date minimumDate:nil maximumDate:nil showTime:showTime];
}

- (void)initWithDate:(NSDate *)date minimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate showTime:(BOOL)showTime {
    _date = date;
    _minimumDate = minimumDate;
    _maximumDate = maximumDate;
    _showTime = showTime;
}


/**
 日期选择器回调处理

 @param sender the ok button
 */
- (void)OKHandler:(id)sender {
    if (_OKHandler) {
        NSUInteger ti = _datePicker.date.timeIntervalSince1970;
        _OKHandler(ti, _datePicker);
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
