//
//  EFBaseTableViewCell.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFConfig.h"

@interface EFBaseTableViewCell : UITableViewCell

@property (assign, nonatomic, nullable) id dataModel;
@property (assign, nonatomic, getter=isCellSelected) BOOL cellSelected;

@property (weak, nonatomic, nullable) id control;
@property (weak, nonatomic, nullable) UIImageView *select_imageView;

@end
