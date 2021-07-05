//
//  EFNavigationBar.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/18.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface EFNavigationBar : UINavigationBar

/**
 导航栏是否暗色，以此来决定前景色
 */
@property (assign, nonatomic, getter=isDark) BOOL dark;
/**
 自定义调试时显示的背景色
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *debugBGColor;

@end
