//
//  OrderModel.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

@interface OrderModel : JSONModel

/**
 唯一标识
 */
@property (copy, nonatomic, nonnull) NSNumber* orderID;

/**
 订单标题
 */
@property (copy, nonatomic, nullable) NSString<Optional>* orderName;

@end
