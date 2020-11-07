//
//  EFNavigationBar.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/18.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface EFNavigationBar : UINavigationBar

/**
 导航栏是否暗色，以此来决定前景色
 */
@property (assign, nonatomic, getter=isDark) IBInspectable BOOL dark;

/**
 渐变开始的颜色
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *startColor;
/**
 渐变结束的颜色
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *endColor;
/**
 是否横向渐变
 */
@property (assign, nonatomic, getter=isHorizontalGradient) IBInspectable BOOL horizontalGradient;
/**
 添加横向渐变
 
 @param startColor 渐变开始的颜色
 @param endColor 渐变结束的颜色
 */
- (void)setHorizontalGradientWithStartColor:(UIColor *_Nonnull)startColor endColor:(UIColor *_Nonnull)endColor;
/**
 添加纵向渐变
 
 @param startColor 渐变开始的颜色
 @param endColor 渐变结束的颜色
 */
- (void)setVerticalGradientWithStartColor:(UIColor *_Nonnull)startColor endColor:(UIColor *_Nonnull)endColor;
/**
 添加自定义渐变
 
 @param colors 渐变色序列
 @param locations 渐变位置序列
 @param startPoint 开始位置
 @param endPoint 结束位置
 */
- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nonnull)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
