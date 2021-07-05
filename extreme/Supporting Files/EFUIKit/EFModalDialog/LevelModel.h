//
//  LevelModel.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/26.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

@interface LevelTwoModel : BaseDataModel

@end

@protocol LevelTwoModel <NSObject>

@end


@interface LevelOneModel : BaseDataModel

/**
 二级数据
 */
@property (strong, nonatomic, nullable) NSArray<LevelTwoModel, Optional> *levelTwo_array;

@end
