//
//  DaySelector_VC.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/21.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

@interface DaySelector_VC : EFBaseModalDialogViewController

/**
 日期选择器，时区为 "Asia/Hong_Kong"。(Date picker with time zone named "Asia/Hong_Kong".)
 */
@property (weak, nonatomic, nullable) IBOutlet UIDatePicker *datePicker;
/**
 日期选择器回调，返回选择的日期时间戳和 UIDatePicker。(OK callback handler, get the date picker and the time interval since 1970 of day time that you selected.)
 */
@property (strong, nonatomic, nonnull) void(^OKHandler)(NSUInteger ti, UIDatePicker *_Nonnull datePicker);

/**
 用于在显示前初始化日期选择器。(Show the day you get on the date picker.)
 
 @param date 初始日期
 */
- (void)initWithDate:(NSDate *_Nonnull)date;
/**
 用于在显示前初始化日期时间选择器，可选显示时间。(Show the day time you get on the date picker.)
 
 @param date 初始日期
 @param showTime 是否显示时间
 */
- (void)initWithDate:(NSDate *_Nonnull)date showTime:(BOOL)showTime;
/**
 用于在显示前初始化日期时间选择器，可设定上下限，可选显示时间。(Show the day time you get on the date picker, there is a rang for your select.)

 @param date 初始日期
 @param minimumDate 最小日期
 @param maximumDate 最大日期
 @param showTime 是否显示时间
 */
- (void)initWithDate:(NSDate *_Nonnull)date minimumDate:(NSDate *_Nullable)minimumDate maximumDate:(NSDate *_Nullable)maximumDate showTime:(BOOL)showTime;

@end
