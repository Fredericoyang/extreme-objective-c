//
//  ListSelector_TVCell.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/27.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

@class BaseDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ListSelector_TVCell :EFBaseTableViewCell

/**
 数据标识 ID。(Data ID.)
 */
@property (assign, nonatomic, nonnull) NSNumber *dataID;
/**
 数据显示内容。(Title for show in list.)
 */
@property (weak, nonatomic, nullable) IBOutlet UILabel *data_label;
/**
 是否已选。(Show selected image or unselected image.)
 */
@property (weak, nonatomic) IBOutlet UIImageView *select_imageView;


/**
 初始化单元格，元素基于 BaseDataModel的数据源。(Init with BaseDataModel based data source.)

 @param model 基于 BaseDataModel的实例
 */
- (void)initWithModel:(BaseDataModel *_Nonnull)model;

@end

NS_ASSUME_NONNULL_END
