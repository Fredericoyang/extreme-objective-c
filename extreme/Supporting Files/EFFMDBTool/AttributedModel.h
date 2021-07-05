//
//  AttributedModel.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2019/3/13.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

@interface AttributedModel : BaseDataModel

/**
 attributedModelID 关联的模型中嵌入模型的 dataID
 */
@property (strong, nonatomic, nonnull) NSNumber *attributedModelID;
/**
 attributedModelClass 关联的模型中嵌入模型的类
 */
@property (copy, nonatomic, nonnull) NSString *attributedModelClass;

@end
