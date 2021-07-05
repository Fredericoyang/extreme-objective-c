//
//  EFTextField.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/20.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFTextField.h"

@implementation EFTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI {
    if (self.placeholder && _placeHolderColor) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName : _placeHolderColor}];
        self.attributedPlaceholder = attributedString;
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


- (void)setOffsetX:(CGFloat)offsetX {
    _offsetX = offsetX;
}

- (void)setOffsetY:(CGFloat)offsetY {
    _offsetY = offsetY;
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor = placeHolderColor;
    
    [self initUI];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x+_offsetX, bounds.origin.y+_offsetY, bounds.size.width-_offsetX*2, bounds.size.height-_offsetY*2);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x+_offsetX, bounds.origin.y+_offsetY, bounds.size.width-_offsetX*2, bounds.size.height-_offsetY*2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x+_offsetX, bounds.origin.y+_offsetY, bounds.size.width-_offsetX*2, bounds.size.height-_offsetY*2);
}

@end
