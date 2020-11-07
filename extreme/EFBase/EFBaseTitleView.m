//
//  EFBaseTitleView.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "EFBaseTitleView.h"
#import "EFMacros.h"

@implementation EFBaseTitleView

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
    if (@available(iOS 11.0, *)) {
        _intrinsicContentSize = CGSizeMake(SCREEN_WIDTH-140, 44);
    }
}

@end
