//
//  EFButton.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/20.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFButton.h"

@implementation EFButton
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initBaseUI];
    [self addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self && [self isMemberOfClass:[EFButton class]]) {
        [self initUI];
    }
}

- (void)initBaseUI { // 作为基类时UI改动使用 initBaseUI，以作用于子类
    if (EFUIKit_enableDebug) {
        self.titleLabel.backgroundColor = COLOR_HEXSTRING_ALPHA(@"#0000FF", 0.5);
        self.imageView.backgroundColor = COLOR_HEXSTRING_ALPHA(@"#00FF00", 0.5);
    }
    
    self.clipsToBounds = YES;
    if (!self.imageView.isHidden) {
        if (!_imageScaleAspectFit) {
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        else {
            CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
            if (_imageFixedWidth) {
                self.imageView.sd_layout
                .widthIs(_imageFixedWidth);
                if (!_imageFixedHeight) { // 高度没设置，自动根据原图宽高比得出
                    _imageFixedHeight = _imageFixedWidth * (imageSize.height/imageSize.width);
                    
                    self.imageView.sd_layout
                    .heightIs(_imageFixedHeight);
                }
            }
            if (_imageFixedHeight) {
                self.imageView.sd_layout
                .heightIs(_imageFixedHeight);
                if (!_imageFixedWidth) { // 宽度没设置，自动根据原图宽高比得出
                    _imageFixedWidth = _imageFixedHeight * (imageSize.width/imageSize.height);
                    
                    self.imageView.sd_layout
                    .widthIs(_imageFixedWidth);
                }
            }
        }
    }
}

- (void)initUI {
    [self updateUI];
}

- (void)updateUI {
    CGSize buttonSize = FRAME_SIZE(self);
    
    CGSize imageSize = CGSizeZero;
    CGFloat imageScaledWidth = 0;
    CGFloat imageScaledHeight = 0;
    if (!self.imageView.isHidden && _imageScaleAspectFit) {
        imageSize = [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        if (_imageFixedWidth && _imageFixedHeight) {
            imageScaledWidth = _imageFixedWidth;
            imageScaledHeight = _imageFixedHeight;
        }
        else {
            imageScaledHeight = buttonSize.height;
            imageScaledWidth = imageScaledHeight * (imageSize.width/imageSize.height);
        }
        self.imageView.sd_layout
        .widthIs(imageScaledWidth)
        .heightIs(imageScaledHeight);
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] imageWidth = %g, imageHeight = %g, imageScaledWidth = %g, imageScaledHeight = %g", self.description, imageSize.width, imageSize.height, imageScaledWidth, imageScaledHeight);
        }
    }
    
    if (_betweenSpace < 5) {
        _betweenSpace = 5;
    }
    if (!self.imageView.isHidden) {
        self.imageEdgeInsets = UIEdgeInsetsMake(_imageScaleAspectFit? (buttonSize.height-imageScaledHeight)/2 : 0, _imageScaleAspectFit? -_betweenSpace-(imageScaledWidth-imageSize.width) : 0, 0, 0);
    }
    if (!self.titleLabel.isHidden) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, _imageScaleAspectFit? _betweenSpace+(imageScaledWidth-imageSize.width) : 0, 0, 0);
    }
}


- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    
    self.layer.cornerRadius = cornerRadius;
}

- (void)setDebugBGColor:(UIColor *)debugBGColor {
    _debugBGColor = debugBGColor;
    
    if (EFUIKit_enableDebug) {
        self.backgroundColor = debugBGColor;
    }
}


- (void)setStartColor:(UIColor *)startColor {
    _startColor = startColor;
    
    if (_startColor && _endColor) {
        if (_horizontalGradient) {
            [self setHorizontalGradientWithStartColor:_startColor endColor:_endColor];
        }
        else {
            [self setVerticalGradientWithStartColor:_startColor endColor:_endColor];
        }
    }
}

- (void)setEndColor:(UIColor *)endColor {
    _endColor = endColor;
    
    if (_startColor && _endColor) {
        if (_horizontalGradient) {
            [self setHorizontalGradientWithStartColor:_startColor endColor:_endColor];
        }
        else {
            [self setVerticalGradientWithStartColor:_startColor endColor:_endColor];
        }
    }
}

- (void)setHorizontalGradient:(BOOL)horizontalGradient {
    _horizontalGradient = horizontalGradient;
    
    if (_startColor && _endColor) {
        if (_horizontalGradient) {
            [self setHorizontalGradientWithStartColor:_startColor endColor:_endColor];
        }
        else {
            [self setVerticalGradientWithStartColor:_startColor endColor:_endColor];
        }
    }
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)setHorizontalGradientWithStartColor:(UIColor *_Nonnull)startColor endColor:(UIColor *_Nonnull)endColor {
    [self setGradientBackgroundWithStartColor:startColor endColor:endColor isHorizontal:YES];
}

- (void)setVerticalGradientWithStartColor:(UIColor *_Nonnull)startColor endColor:(UIColor *_Nonnull)endColor {
    [self setGradientBackgroundWithStartColor:startColor endColor:endColor isHorizontal:NO];
}

- (void)setGradientBackgroundWithStartColor:(UIColor *_Nonnull)startColor endColor:(UIColor *_Nonnull)endColor isHorizontal:(BOOL)isHorizontal {
    [self setGradientBackgroundWithColors:@[startColor, endColor] isHorizontal:(BOOL)isHorizontal];
}

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nonnull)colors isHorizontal:(BOOL)isHorizontal {
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    ((CAGradientLayer *)self.layer).colors = [colorsM copy];
    if (isHorizontal) {
        ((CAGradientLayer *)self.layer).startPoint = CGPointMake(0, 0);
        ((CAGradientLayer *)self.layer).endPoint = CGPointMake(1, 0);
    }
    else {
        ((CAGradientLayer *)self.layer).startPoint = CGPointMake(0, 0);
        ((CAGradientLayer *)self.layer).endPoint = CGPointMake(0, 1);
    }
}

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nonnull)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    ((CAGradientLayer *)self.layer).colors = [colorsM copy];
    ((CAGradientLayer *)self.layer).locations = locations;
    ((CAGradientLayer *)self.layer).startPoint = startPoint;
    ((CAGradientLayer *)self.layer).endPoint = endPoint;
}


- (void)setImageFixedWidth:(CGFloat)imageFixedWidth {
    if (EFUIKit_enableDebug && self.imageView.isHidden) {
        LOG_FORMAT(@"[%@] 'imageFixedWidth' not available. Please set image first.", self.description);
        return;
    }
    
    _imageFixedWidth = imageFixedWidth;
    
    CGSize buttonSize = self.bounds.size;
    CGSize imageSize = CGSizeZero;
    if (!self.imageView.isHidden) {
        imageSize = [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    }
    CGSize titleSize = CGSizeZero;
    if (!self.titleLabel.isHidden) {
        titleSize = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    }
    CGFloat availableWidth = [self isMemberOfClass:[EFButtonTopImage class]]? buttonSize.width: buttonSize.width-titleSize.width; // 图标最大可分配宽度
    if (availableWidth < 0) {
        availableWidth = 0;
    }
    if (EFUIKit_enableDebug) {
        LOG_FORMAT(@"[%@] availableWidth = %g", self.description, availableWidth);
    }
    if (_imageFixedWidth > availableWidth) {
        _imageFixedWidth = availableWidth;
        
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] 'imageFixedWidth' limited to 'availableWidth'. new imageFixedWidth = %g", self.description, _imageFixedWidth);
        }
    }
}

- (void)setImageFixedHeight:(CGFloat)imageFixedHeight {
    if (EFUIKit_enableDebug && self.imageView.isHidden) {
        LOG_FORMAT(@"[%@] 'imageFixedHeight' not available. Please set image first.", self.description);
        return;
    }
    
    _imageFixedHeight = imageFixedHeight;
    
    CGSize buttonSize = self.bounds.size;
    CGSize imageSize = CGSizeZero;
    if (!self.imageView.isHidden) {
        imageSize = [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    }
    CGSize titleSize = CGSizeZero;
    if (!self.titleLabel.isHidden) {
        titleSize = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    }
    CGFloat availableHeight = [self isMemberOfClass:[EFButtonTopImage class]]? buttonSize.height-titleSize.height: buttonSize.height; // 图标最大可分配高度
    if (EFUIKit_enableDebug) {
        LOG_FORMAT(@"[%@] availableHeight = %g", self.description, availableHeight);
    }
    if (_imageFixedHeight > availableHeight) {
        _imageFixedHeight = availableHeight;
        
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] 'imageFixedHeight' limited to 'availableHeight'. new imageFixedHeight = %g", self.description, _imageFixedHeight);
        }
    }
}

- (void)setImageScaleAspectFit:(BOOL)imageScaleAspectFit {
    if (self.imageView.isHidden) {
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] 'imageScaleAspectFit' is not available. Please set image first. ", self.description);
        }
        return;
    }
    
    _imageScaleAspectFit = imageScaleAspectFit;
    
    if (imageScaleAspectFit) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (void)setBetweenSpace:(CGFloat)betweenSpace {
    if (self.imageView.isHidden || self.titleLabel.isHidden) {
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] 'betweenSpace' is not available. Please set image or title first. ", self.description);
        }
        return;
    }
    
    _betweenSpace = betweenSpace;
}

- (void)tap:(id)sender {
    if (_tapHandler) {
        _tapHandler(sender);
    }
}

@end


@implementation EFButtonLeftImage

- (void)awakeFromNib {
    [super awakeFromNib];

    [self initUI];
}

- (void)initUI {
    [self updateUI];
}

- (void)updateUI {
    CGSize buttonSize = FRAME_SIZE(self);
    
    CGSize imageSize = CGSizeZero;
    CGFloat imageScaledWidth = 0;
    CGFloat imageScaledHeight = 0;
    if (!self.imageView.isHidden) {
        imageSize = [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        if (self.imageFixedWidth && self.imageFixedHeight) {
            imageScaledWidth = self.imageFixedWidth;
            imageScaledHeight = self.imageFixedHeight;
        }
        else {
            imageScaledHeight = buttonSize.height*0.5;
            imageScaledWidth = imageScaledHeight * (imageSize.width/imageSize.height);
        }
        // 重设图标大小
        self.imageView.sd_layout
        .widthIs(imageScaledWidth)
        .heightIs(imageScaledHeight);
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] imageWidth = %g, imageHeight = %g, imageScaledWidth = %g, imageScaledHeight = %g", self.description, imageSize.width, imageSize.height, imageScaledWidth, imageScaledHeight);
        }
    }
    
    if (_leftRightSpace < 10) {
        _leftRightSpace = 10;
    }
    CGSize titleSize = CGSizeZero;
    if (!self.titleLabel.isHidden) { // 根据左右边距、图标与文字间距自动调整文本宽度
        titleSize = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] titleWidth = %g, titleHeight = %g", self.description, titleSize.width, titleSize.height);
        }
        UILabel *titlePlaceholder_label = [[UILabel alloc] init];
        titlePlaceholder_label.text = @"字字字";
        titlePlaceholder_label.font = self.titleLabel.font;
        CGSize titlePlaceholderSize = [titlePlaceholder_label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        CGFloat availableTitleLabelWidth = buttonSize.width - _leftRightSpace*2 - self.betweenSpace - imageScaledWidth;
        if (availableTitleLabelWidth < titlePlaceholderSize.width) {
            availableTitleLabelWidth = buttonSize.width- _leftRightSpace*2 - imageScaledWidth; // 优先左右边距
            if (availableTitleLabelWidth < titlePlaceholderSize.width) {
                availableTitleLabelWidth = titlePlaceholderSize.width;
            }
        }
        titleSize = [self.titleLabel sizeThatFits:CGSizeMake(availableTitleLabelWidth, imageScaledHeight)];
        if (titleSize.width > availableTitleLabelWidth) {
            titleSize.width = availableTitleLabelWidth;
            if (EFUIKit_enableDebug) {
                LOG_FORMAT(@"[%@] The width of 'titleLabel' is limited to 'availableTitleLabelWidth'. new titleWidth = %g", self.description, titleSize.width);
            }
        }
        // 重设文本大小
        self.titleLabel.sd_layout
        .centerYEqualToView(self.imageView)
        .widthIs(titleSize.width);
    }
    
    CGFloat availableLeftRightSpace = (buttonSize.width - imageScaledWidth - titleSize.width)/2;
    if (availableLeftRightSpace < 0) {
        availableLeftRightSpace = 0;
    }
    if (EFUIKit_enableDebug) {
        LOG_FORMAT(@"[%@] availableLeftRightSpace = %g", self.description, availableLeftRightSpace);
    }
    if (_leftRightSpace > availableLeftRightSpace) {
        _leftRightSpace = availableLeftRightSpace;
        
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] 'leftRightSpace' is limited to availableLeftRightSpace. new leftRightSpace = %g", self.description, _leftRightSpace);
        }
    }
    
    CGFloat availableBetweenSpaceSpace = (availableLeftRightSpace - _leftRightSpace)*2;
    if (availableBetweenSpaceSpace < 0) {
        availableBetweenSpaceSpace = 0;
    }
    if (EFUIKit_enableDebug) {
        LOG_FORMAT(@"[%@] availableBetweenSpaceSpace = %g", self.description, availableBetweenSpaceSpace);
    }
    if (self.betweenSpace < 5) {
        self.betweenSpace = 5;
    }
    if (self.betweenSpace > availableBetweenSpaceSpace) {
        self.betweenSpace = availableBetweenSpaceSpace;
        
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] 'betweenSpace' is limited to 'availableBetweenSpaceSpace'. new betweenSpace = %g", self.description, self.betweenSpace);
        }
    }
    
    self.contentEdgeInsets = UIEdgeInsetsMake(0, _leftRightSpace, 0, _leftRightSpace);
    if (!self.imageView.isHidden) {
        self.imageEdgeInsets = UIEdgeInsetsMake((buttonSize.height-imageScaledHeight)/2, 0, 0, 0);
    }
    if (!self.titleLabel.isHidden) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, self.betweenSpace+(imageScaledWidth-imageSize.width), 0, 0);
    }
}

- (void)setLeftRightSpace:(CGFloat)leftRightSpace {
    _leftRightSpace = leftRightSpace;
}

@end


@implementation EFButtonTopImage

- (void)awakeFromNib {
    [super awakeFromNib];

    [self initUI];
}

- (void)initUI {
    [self updateUI];
}

- (void)updateUI {
    CGSize buttonSize = self.bounds.size;
    
    CGSize imageSize = CGSizeZero;
    CGFloat imageScaledWidth = 0;
    CGFloat imageScaledHeight = 0;
    if (!self.imageView.isHidden) {
        imageSize = [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        if (self.imageFixedWidth && self.imageFixedHeight) {
            imageScaledWidth = self.imageFixedWidth;
            imageScaledHeight = self.imageFixedHeight;
        }
        else {
            imageScaledWidth = buttonSize.width*0.5;
            imageScaledHeight = imageScaledWidth * (buttonSize.height/buttonSize.width);
        }
        self.imageView.sd_layout
        .widthIs(imageScaledWidth)
        .heightIs(imageScaledHeight);
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] imageWidth = %g, imageHeight = %g, imageScaledWidth = %g, imageScaledHeight = %g", self.description, imageSize.width, imageSize.height, imageScaledWidth, imageScaledHeight);
        }
    }
    
    if (_topBottomSpace < 10) {
        _topBottomSpace = 10;
    }
    CGSize titleSize = CGSizeZero;
    if (!self.titleLabel.isHidden) { // 根据上下边距、图标与文字间距自动调整文本高度
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        titleSize = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] titleWidth = %g, titleHeight = %g", self.description, titleSize.width, titleSize.height);
        }
        UILabel *titlePlaceholder_label = [[UILabel alloc] init];
        titlePlaceholder_label.text = @"一行字";
        titlePlaceholder_label.font = self.titleLabel.font;
        CGSize titlePlaceholderSize = [titlePlaceholder_label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        CGFloat availableTitleLabelHeight = buttonSize.height - _topBottomSpace*2 - self.betweenSpace - imageScaledHeight;
        if (availableTitleLabelHeight < titlePlaceholderSize.height) {
            availableTitleLabelHeight = buttonSize.height- _topBottomSpace*2 -imageScaledHeight; // 优先上下边距
            if (availableTitleLabelHeight < titlePlaceholderSize.height) {
                availableTitleLabelHeight = titlePlaceholderSize.height;
            }
        }
        titleSize = [self.titleLabel sizeThatFits:CGSizeMake(imageScaledWidth, availableTitleLabelHeight)];
        if (titleSize.height > availableTitleLabelHeight) {
            titleSize.height = availableTitleLabelHeight;
            if (EFUIKit_enableDebug) {
                LOG_FORMAT(@"[%@] The height of 'titleLabel' is limited to 'availableTitleLabelHeight'. new titleHeight = %g", self.description, titleSize.height);
            }
        }
        self.titleLabel.sd_layout
        .centerXEqualToView(self.imageView)
        .heightIs(titleSize.height);
    }
    
    CGFloat availableTopBottomSpace = (buttonSize.height - imageScaledHeight - titleSize.height)/2;
    if (availableTopBottomSpace < 0) {
        availableTopBottomSpace = 0;
    }
    if (EFUIKit_enableDebug) {
        LOG_FORMAT(@"[%@] availableTopBottomSpace = %g", self.description, availableTopBottomSpace);
    }
    if (_topBottomSpace > availableTopBottomSpace) {
        _topBottomSpace = availableTopBottomSpace;
        
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] 'topBottomSpace' is limited to availableTopBottomSpace. new topBottomSpace = %g", self.description, _topBottomSpace);
        }
    }
    
    CGFloat availableBetweenSpaceSpace = (availableTopBottomSpace - _topBottomSpace)*2;
    if (availableBetweenSpaceSpace < 0) {
        availableBetweenSpaceSpace = 0;
    }
    if (EFUIKit_enableDebug) {
        LOG_FORMAT(@"[%@] availableBetweenSpaceSpace = %g", self.description, availableBetweenSpaceSpace);
    }
    if (self.betweenSpace < 5) {
        self.betweenSpace = 5;
    }
    if (self.betweenSpace > availableBetweenSpaceSpace) {
        self.betweenSpace = availableBetweenSpaceSpace;
        
        if (EFUIKit_enableDebug) {
            LOG_FORMAT(@"[%@] 'betweenSpace' is limited to 'availableBetweenSpaceSpace'. new betweenSpace = %g", self.description, self.betweenSpace);
        }
    }
    
    self.contentEdgeInsets = UIEdgeInsetsMake(_topBottomSpace, 0, _topBottomSpace, 0);
    if (!self.imageView.isHidden) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, (buttonSize.width-imageScaledWidth)/2, 0, 0);
    }
    if (!self.titleLabel.isHidden) {
        self.titleEdgeInsets = UIEdgeInsetsMake(imageScaledHeight+self.betweenSpace, -imageSize.width+(buttonSize.width-imageScaledWidth)/2, 0, 0);
    }
}

- (void)setTopBottomSpace:(CGFloat)topBottomSpace {
    _topBottomSpace = topBottomSpace;
}

@end
