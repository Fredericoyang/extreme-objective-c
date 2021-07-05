//
//  EFTextField.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/20.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

IB_DESIGNABLE
@interface EFTextField : UITextField

/** 设置边框宽度 */
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;
/** 设置边框颜色 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *borderColor;
/** 设置圆角弧度 */
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
/**
 自定义调试时显示的背景色
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *debugBGColor;

/** 设置文字横向偏移量 */
@property (assign, nonatomic) IBInspectable CGFloat offsetX;
/** 设置文字纵向偏移量 */
@property (assign, nonatomic) IBInspectable CGFloat offsetY;
/** 自定义占位文字的颜色 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *placeHolderColor;

@end
