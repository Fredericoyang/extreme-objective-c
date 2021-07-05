//
//  BaseDataModel.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/28.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "JSONModel.h"
#import "NSObject+Coding.h"

@interface BaseDataModel : JSONModel <NSSecureCoding>

/**
 数据标识 ID。(Data ID.)
 */
@property (strong, nonatomic, nullable) NSNumber<Optional> *dataID;
/**
 数据显示名称。(Data name for show.)
 */
@property (copy, nonatomic, nullable) NSString<Optional> *dataName;

//MARK: Parser
typedef void (^_Nullable EnumerateBaseDataModelPropertiesFinish)(void);

/**
 遍历基于 BaseDataModel的模型的属性。(Enumerate properties of BaseDataModel based model.)

 @param enumerateBaseDataModelPropertiesBlock EnumerateBaseDataModelProperties实例
 @param finishBlock EnumerateBaseDataModelPropertiesFinish实例
 */
- (void)enumerateBaseDataModelProperties:(EnumerateBaseDataModelProperties)enumerateBaseDataModelPropertiesBlock finish:(EnumerateBaseDataModelPropertiesFinish)finishBlock;

@end
