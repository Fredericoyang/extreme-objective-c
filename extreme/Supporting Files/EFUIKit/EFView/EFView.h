//
//  EFView.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/20.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

IB_DESIGNABLE
@interface EFView : UIView

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

/** 设置阴影颜色 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *shadowColor;
/** 设置阴影偏移量 */
@property (assign, nonatomic) CGSize shadowOffset;
/** 设置阴影偏移宽 */
@property (assign, nonatomic) IBInspectable CGFloat shadowOffsetWidth;
/** 设置阴影偏移高 */
@property (assign, nonatomic) IBInspectable CGFloat shadowOffsetHeight;
/** 设置阴影透明度 */
@property (assign, nonatomic) IBInspectable CGFloat shadowOpacity;
/** 设置阴影半径 */
@property (assign, nonatomic) IBInspectable CGFloat shadowRadius;

@end
