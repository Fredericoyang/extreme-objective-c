//
//  AttributedModel.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2019/3/13.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "AttributedModel.h"

@implementation AttributedModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
        @"dataID": @"parentModelID",        // dataID 关联的模型 dataID
        @"dataName": @"parentAttributeName" // dataName 关联的模型中嵌入模型的属性名
    }];
}

@end
