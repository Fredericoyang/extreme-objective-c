//
//  EFImageView.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/20.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFImageView.h"

@implementation EFImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI {
    if (!_imageScaleAspectFit) {
        self.contentMode = UIViewContentModeScaleAspectFill;
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


- (void)setImageScaleAspectFit:(BOOL)imageScaleAspectFit {
    _imageScaleAspectFit = imageScaleAspectFit;
    
    if (imageScaleAspectFit) {
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    else {
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
}


- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    
    self.layer.shadowColor = shadowColor.CGColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    _shadowOffset = shadowOffset;
    
    self.layer.shadowOffset = shadowOffset;
}

- (void)setShadowOffsetWidth:(CGFloat)shadowOffsetWidth {
    _shadowOffsetWidth = shadowOffsetWidth;
    
    self.layer.shadowOffset = CGSizeMake(shadowOffsetWidth, _shadowOffsetHeight);
}

- (void)setShadowOffsetHeight:(CGFloat)shadowOffsetHeight {
    _shadowOffsetHeight = shadowOffsetHeight;
    
    self.layer.shadowOffset = CGSizeMake(_shadowOffsetWidth, shadowOffsetHeight);
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    _shadowOpacity = shadowOpacity;
    
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    _shadowRadius = shadowRadius;
    
    self.layer.shadowRadius = shadowRadius;
}

@end
