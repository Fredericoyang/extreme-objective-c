//
//  ListSelector_TVCell.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/27.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "ListSelector_TVCell.h"

@implementation ListSelector_TVCell

@synthesize select_imageView = _select_imageView;

- (void)initWithModel:(BaseDataModel *_Nonnull)model {
    _dataID = model.dataID;
    _data_label.text = model.dataName;
    [_select_imageView setImage:IMAGE(@"extreme.bundle/unselected")];
}

@end
