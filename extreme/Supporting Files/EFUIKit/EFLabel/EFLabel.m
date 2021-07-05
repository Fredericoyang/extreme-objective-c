//
//  EFLabel.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/20.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFLabel.h"

const UIFontWeight UIFontWeightNone = 0;

@implementation EFLabel {
    UILabel *_fitSize_label;
}

- (instancetype _Nonnull)initWithString:(NSString *_Nonnull)string {
    self = [super init];
    if (self) {
        self.text = string;
        [self initUI];
    }
    return self;
}

- (instancetype _Nonnull)initWithString:(NSString *_Nonnull)string systemFontOfSize:(CGFloat)systemFontOfSize {
    return [self initWithString:string font:[UIFont systemFontOfSize:systemFontOfSize] textColor:nil];
}

- (instancetype _Nonnull)initWithString:(NSString *_Nonnull)string font:(UIFont *_Nonnull)font {
    return [self initWithString:string font:font textColor:nil];
}

- (instancetype _Nonnull)initWithString:(NSString *_Nonnull)string font:(UIFont *_Nonnull)font textColor:(UIColor *_Nullable)textColor {
    self = [super init];
    if (self) {
        self.text = string;
        self.font = font;
        if (textColor) {
            self.textColor = textColor;
        }
        [self initUI];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI {
    CGSize labelSize = FRAME_SIZE(self);
    CGSize labelFitSize = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    if (labelFitSize.width-labelSize.width>0 && _tiped) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToShowTip)];
        [self addGestureRecognizer:tap];
        _fitSize_label = [[UILabel alloc] init];
        _fitSize_label.numberOfLines = 0;
        _fitSize_label.text = self.text;
        _fitSize_label.textColor = COLOR_HEXSTRING(@"#333333");
        _fitSize_label.font = self.font;
        _fitSize_label.backgroundColor = COLOR_HEXSTRING(@"#FFFFFF");
        _fitSize_label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapTip = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHideTip)];
        [_fitSize_label addGestureRecognizer:tapTip];
        _fitSize_label.hidden = YES;
        if (EFUIKit_enableDebug) {
            _fitSize_label.alpha = 0.5;
        }
        [self.superview addSubview:_fitSize_label];
        
        _fitSize_label.sd_layout
        .leftEqualToView(self)
        .topEqualToView(self)
        .widthIs(labelSize.width)
        .heightIs([_fitSize_label sizeThatFits:CGSizeMake(labelSize.width, CGFLOAT_MAX)].height);
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
    self.layer.masksToBounds = cornerRadius > 0;
}

- (void)setDebugBGColor:(UIColor *)debugBGColor {
    _debugBGColor = debugBGColor;
    
    if (EFUIKit_enableDebug) {
        self.backgroundColor = debugBGColor;
    }
}


- (void)setTiped:(BOOL)tiped {
    _tiped = tiped;
}

- (void)tapToShowTip {
    _fitSize_label.hidden = NO;
}

- (void)tapToHideTip {
    _fitSize_label.hidden = YES;
}

@end
