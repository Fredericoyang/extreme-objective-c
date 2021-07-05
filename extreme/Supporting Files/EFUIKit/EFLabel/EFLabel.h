//
//  EFLabel.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/20.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

IB_DESIGNABLE
@interface EFLabel : UILabel

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

/**
 文字显示不全时，是否以浮动提示方式显示全部文字
 */
@property (assign, nonatomic) IBInspectable BOOL tiped;

/**
 用一个 String初始化 Label

 @param string a NSString
 @return EFLabel 实例
 */
- (instancetype _Nonnull)initWithString:(NSString *_Nonnull)string;
/**
 用一个 String初始化 Label，指定字体大小

 @param string a NSString
 @param systemFontOfSize 字体大小
 @return EFLabel 实例
 */
- (instancetype _Nonnull)initWithString:(NSString *_Nonnull)string systemFontOfSize:(CGFloat)systemFontOfSize;
/**
 用一个 String初始化 Label，指定字体

 @param string a NSString
 @param font 字体
 @return EFLabel 实例
 */
- (instancetype _Nonnull)initWithString:(NSString *_Nonnull)string font:(UIFont *_Nonnull)font;
/**
 用一个 String初始化 Label，指定字体和文本颜色

 @param string a NSString
 @param font 字体
 @param textColor 文本颜色
 @return EFLabel 实例
 */
- (instancetype _Nonnull)initWithString:(NSString *_Nonnull)string font:(UIFont *_Nonnull)font textColor:(UIColor *_Nullable)textColor;

@end
