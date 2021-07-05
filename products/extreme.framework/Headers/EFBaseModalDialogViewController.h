//
//  EFBaseModalDialogViewController.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/24.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFBaseViewController.h"

@class EFButton;

@interface EFBaseModalDialogViewController : EFBaseViewController
/**
 是否使用深色导航栏，默认使用浅色导航栏。(Navigation bar style, light as default.)
 */
@property (assign, nonatomic) BOOL navigationBarDark;
/**
 图标。(The icon of modal dialog.)
 */
@property (weak, nonatomic, nullable) IBOutlet UIImageView *icon_imageView;
/**
 自定义图标文件名。(For custom icon.)
 */
@property (strong, nonatomic, nonnull) NSString *iconImageName;
/**
 标题。(The title of modal dialog.)
 */
@property (weak, nonatomic, nullable) IBOutlet UILabel *title_label;
/**
 自定义标题文本。(For custom title.)
 */
@property (strong, nonatomic, nonnull) NSString *titleText;

/**
 关闭对话框，方式1。(Close the modal dialog, the first way.)

 @param sender the close button
 */
- (IBAction)tapToClose:(id _Nullable)sender;
/**
 确定按钮。(OK button.)
 */
@property (weak, nonatomic, nullable) IBOutlet EFButton *OKButton;
/**
 按下确定按钮，处理事件响应，请派生一个子类并使用 OKHandler:。(Press the OK button to handle the event, implement the OKHandler: in a modal dialog based on EFBaseModalDialogViewController.)

 @param sender the ok button
 */
- (IBAction)tapToOK:(id _Nullable)sender;
/**
 关闭对话框，方式2。(Close the modal dialog, the second way.)
 */
- (void)closeModalDialog;
/**
 按下确定按钮回调。(The handler of button when pressed.)

 @param sender the ok button
 */
- (void)OKHandler:(id _Nullable)sender;

@end
