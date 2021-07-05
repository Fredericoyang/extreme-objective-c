//
//  EFBaseBarButtonItemCustomView.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFBaseBarButtonItemCustomView.h"

@implementation EFBaseBarButtonItemCustomView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI {
    _intrinsicContentSize = CGSizeMake(70, 44);
}

@end
