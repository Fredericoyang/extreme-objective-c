//
//  EFButton.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/20.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

IB_DESIGNABLE
@interface EFButton : UIButton

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

/**
 手动设置图标宽度，可单独设置宽度，高度按原图宽高比自动算出
 */
@property (assign, nonatomic) IBInspectable CGFloat imageFixedWidth;
/**
 手动设置图标高度，可单独设置高度，宽度按原图宽高比自动算出
 */
@property (assign, nonatomic) IBInspectable CGFloat imageFixedHeight;
/**
 图标是否自动等比缩放至合适大小显示，YES 等比缩放至合适大小，NO 等比缩放至平铺全部显示区域，可能有裁剪，默认 NO
 */
@property (assign, nonatomic) IBInspectable BOOL imageScaleAspectFit;
/**
 图标与文字的距离，缺省值为 5
 */
@property (assign, nonatomic) IBInspectable CGFloat betweenSpace;

/**
 按钮点按回调
 */
@property (strong, nonatomic, nullable) void(^tapHandler)(id _Nonnull sender);

@end


//MARK: 图标居左的按钮
IB_DESIGNABLE
@interface EFButtonLeftImage : EFButton

/**
 按钮左右边距，缺省值为 10
 */
@property (assign, nonatomic) IBInspectable CGFloat leftRightSpace;

@end


//MARK: 图标居上的按钮
IB_DESIGNABLE
@interface EFButtonTopImage : EFButton

/**
 按钮上下边距，缺省值为 10
 */
@property (assign, nonatomic) IBInspectable CGFloat topBottomSpace;

@end
