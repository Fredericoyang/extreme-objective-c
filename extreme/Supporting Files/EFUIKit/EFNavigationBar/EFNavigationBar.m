//
//  EFNavigationBar.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/18.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "EFNavigationBar.h"

@implementation EFNavigationBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI {
    
}


- (void)setDark:(BOOL)dark {
    _dark = dark;
    if (_dark) {
        self.tintColor = THEME_COLOR_LIGHT;
        self.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightTextColor],NSForegroundColorAttributeName, nil];
        if (@available(iOS 11.0, *)) {
            self.largeTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
        } else {
            // Fallback on earlier versions
        }
    }
    else {
        self.tintColor = THEME_COLOR;
        self.titleTextAttributes = nil;
        if (@available(iOS 11.0, *)) {
            self.largeTitleTextAttributes = nil;
        } else {
            // Fallback on earlier versions
        }
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
    if (colorsM.count == 0) {
        return;
    }
    ((CAGradientLayer *)self.layer).colors = [colorsM copy];
    ((CAGradientLayer *)self.layer).locations = locations;
    ((CAGradientLayer *)self.layer).startPoint = startPoint;
    ((CAGradientLayer *)self.layer).endPoint = endPoint;
}

@end
