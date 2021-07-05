//
//  EFBaseTitleView.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFBaseTitleView.h"
#import "EFMacros.h"

@implementation EFBaseTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI {
    _intrinsicContentSize = CGSizeMake(SCREEN_WIDTH-140, 44);
}

@end
