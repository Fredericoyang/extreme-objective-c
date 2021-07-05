//
//  LevelSelector_VC.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/21.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelSelector_VC : EFBaseModalDialogViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic, nullable) IBOutlet UIPickerView *pickerView;
/**
 是否单列，目前最多支持两列。(Single column or two columns.)
 */
@property (assign, nonatomic) BOOL single;
/**
 级联选择器回调，返回选择的 dataID与 dataText。(OK callback handler, get the 'dataID' and 'dataText' that you selected.)
 */
@property (strong, nonatomic, nonnull) void(^OKHandler)(NSNumber *_Nonnull dataID, NSString *_Nonnull dataText);

@end
