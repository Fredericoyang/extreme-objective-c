//
//  BaseDataModel.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/28.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseDataModel : JSONModel

/**
 数据标识 ID
 */
@property (strong, nonatomic, nullable) NSNumber<Optional> *dataID;
/**
 数据显示名称
 */
@property (copy, nonatomic, nullable) NSString<Optional> *dataName;

@end

NS_ASSUME_NONNULL_END
