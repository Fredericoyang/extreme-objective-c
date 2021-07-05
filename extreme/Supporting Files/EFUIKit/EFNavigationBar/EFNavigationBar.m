//
//  EFNavigationBar.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/18.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFNavigationBar.h"

@implementation EFNavigationBar

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI {
    
}

- (void)setDebugBGColor:(UIColor *)debugBGColor {
    _debugBGColor = debugBGColor;
    
    if (EFUIKit_enableDebug) {
        self.backgroundColor = debugBGColor;
    }
}


- (void)setDark:(BOOL)dark {
    _dark = dark;
    
    if (_dark) {
        self.barTintColor = THEME_COLOR;
        self.tintColor = THEME_COLOR_LIGHT;
        self.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:THEME_COLOR_LIGHT, NSForegroundColorAttributeName, nil];
        self.largeTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:THEME_COLOR_LIGHT, NSForegroundColorAttributeName, nil];
    }
    else {
        self.barTintColor = THEME_COLOR_LIGHT;
        self.tintColor = THEME_COLOR;
        self.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:THEME_COLOR, NSForegroundColorAttributeName, nil];
        self.largeTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:THEME_COLOR, NSForegroundColorAttributeName, nil];
    }
}

@end
